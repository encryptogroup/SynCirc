const std = @import("std");

const Circuit = @import("Circuit.zig");
const BristolParser = @import("BristolParser.zig");
const Parser = @import("Parser.zig");

const countGateTypes = @import("count_gate_types.zig").countGateTypes;
const DepthAnalysis = @import("DepthAnalysis.zig");

const log = std.log.scoped(.convert);

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    log.err(format, args);
    std.process.exit(1);
}

const usage =
    \\usage: {s} [circuit file]
    \\
    \\Supported file types:
    \\        .bristol  Bristol circuit format
    \\        .syncirc  SynCirc circuit format
    \\
;

const InputFormat = enum {
    bristol,
    syncirc,
};

fn classifyFileExt(file_name: []const u8) ?InputFormat {
    if (std.mem.endsWith(u8, file_name, ".bristol")) {
        return .bristol;
    } else if (std.mem.endsWith(u8, file_name, ".syncirc")) {
        return .syncirc;
    } else {
        return null;
    }
}

pub fn main() !void {
    var gpa_instance = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa_instance.deinit();
    const gpa = gpa_instance.allocator();

    var arena_instance = std.heap.ArenaAllocator.init(gpa);
    defer arena_instance.deinit();
    const arena = arena_instance.allocator();

    const args = try std.process.argsAlloc(arena);
    if (args.len != 2) {
        std.debug.print(usage, .{args[0]});
        fatal("expected circuit file", .{});
    }

    const input_file_path = args[1];

    const input_file_dirname = std.fs.path.dirname(input_file_path) orelse ".";
    const input_file_basename = std.fs.path.basename(input_file_path);

    var working_dir = try std.fs.cwd().openDir(input_file_dirname, .{});
    defer working_dir.close();

    const input_file_type = classifyFileExt(input_file_basename) orelse {
        fatal("unrecognized input file type", .{});
    };

    const circuit: Circuit = switch (input_file_type) {
        .bristol => try BristolParser.parseBristol(
            arena,
            working_dir,
            input_file_basename,
        ),
        .syncirc => try Parser.parseCircuit(
            arena,
            working_dir,
            input_file_basename,
        ),
    };

    const stdout = std.io.getStdOut().writer();

    const count = countGateTypes(circuit);

    const depths = try DepthAnalysis.analyzeDepth(gpa, circuit);
    defer depths.deinit();

    try stdout.print(
        \\INV: {}
        \\AND2: {}
        \\AND3: {}
        \\AND4: {}
        \\XOR: {}
        \\LUT: {}
        \\
    , .{
        count.inv,
        count.@"and",
        count.and3,
        count.and4,
        count.xor,
        count.lut,
    });

    for (count.lut_input_sizes) |amount, size| {
        if (amount == 0) continue;
        try stdout.print("LUT{}:{}\n", .{size, amount});
    }

    try stdout.print("output depths: {any}\n", .{depths.output_depth});
    try stdout.print("total depth: {}\n", .{std.mem.max(DepthAnalysis.Depth, depths.output_depth)});
}
