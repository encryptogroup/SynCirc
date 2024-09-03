const std = @import("std");

const Builder = @import("Builder.zig");
const Circuit = @import("Circuit.zig");
const Emit = @import("Emit.zig");
const Torder = @import("Torder.zig");
const Parser = @import("Parser.zig");
const Linearize = @import("Linearize.zig");
const EmitBristol = @import("EmitBristol.zig");
const dead_node_elimination = @import("dead_node_elimination.zig");
const yosys = @import("external/yosys.zig");
const xls = @import("external/xls.zig");

const log = std.log.scoped(.syncirc);

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    log.err(format, args);
    std.process.exit(1);
}

const usage =
    \\usage: {s} [options] [input file]
    \\
    \\Supported input file types:
    \\            .c              C
    \\            .cpp            C++
    \\            .v              Verilog
    \\
    \\Supported output file types:
    \\            .syncirc        SynCirc
    \\            .bristol        Bristol
    \\
    \\Options:
    \\ -L [num]                   Use LUTs of size num (default=yao)
    \\ -k                         Keep intermediate files
    \\ -v                         Enable verbose output
    \\ -s [manual|synth]          Use a different Yosys workflow
    \\                            (default=manual)
    \\ -t [name]                  Top-level function/module
    \\                            (default=main)
    \\ -I [dir]                   Add include directory for HLS
    \\ --loop-bound [num]         Upper bound of loop iterations (default=1000)
    \\ -f [format]                Output circuit format (default=bristol)
    \\
;

const InputFormat = enum {
    c,
    cxx,
    verilog,
};

const OutputFormat = enum {
    syncirc,
    bristol,
};

fn classifyFileExt(file_name: []const u8) ?InputFormat {
    if (std.mem.endsWith(u8, file_name, ".c")) {
        return .c;
    } else if (std.mem.endsWith(u8, file_name, ".cpp")) {
        return .cxx;
    } else if (std.mem.endsWith(u8, file_name, ".v")) {
        return .verilog;
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

    var input_file_path: ?[]const u8 = null;
    var keep_intermediate_files = false;
    var verbose = false;
    var script: yosys.SynthesisScript = .manual;
    var pub_lut_size: ?u8 = null;
    var top_level_fn_module: []const u8 = "main";
    var loop_bound: u32 = 10_000;
    var output_format: OutputFormat = .bristol;
    var include_dirs = std.ArrayList([]const u8).init(arena);
    defer include_dirs.deinit();

    {
        var i: usize = 1;
        while (i < args.len) : (i += 1) {
            const arg = args[i];
            if (std.mem.eql(u8, "-h", arg) or std.mem.eql(u8, "--help", arg)) {
                std.debug.print(usage, .{args[0]});
                std.process.exit(1);
            } else if (std.mem.eql(u8, "-k", arg)) {
                keep_intermediate_files = true;
            } else if (std.mem.eql(u8, "-v", arg)) {
                verbose = true;
            } else if (std.mem.eql(u8, "-s", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                script = std.meta.stringToEnum(yosys.SynthesisScript, args[i]) orelse fatal("invalid script '{s}'", .{args[i]});
            } else if (std.mem.eql(u8, "-L", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                pub_lut_size = std.fmt.parseInt(u8, args[i], 10) catch fatal("invalid LUT size '{s}'", .{args[i]});
            } else if (std.mem.eql(u8, "-t", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                top_level_fn_module = args[i];
            } else if (std.mem.eql(u8, "-I", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                try include_dirs.append(args[i]);
            } else if (std.mem.eql(u8, "--loop-bound", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                loop_bound = std.fmt.parseInt(u8, args[i], 10) catch fatal("invalid loop bound size '{s}'", .{args[i]});
            } else if (std.mem.eql(u8, "-f", arg)) {
                if (i + 1 >= args.len) fatal("expected parameter after '{s}'", .{arg});
                i += 1;
                output_format = std.meta.stringToEnum(OutputFormat, args[i]) orelse fatal("invalid output format '{s}'", .{args[i]});
            } else {
                if (input_file_path == null and !std.mem.startsWith(u8, arg, "-")) {
                    input_file_path = arg;
                } else {
                    fatal("unrecognized parameter: '{s}'", .{arg});
                }
            }
        }
    }

    if (input_file_path == null) fatal("no input file provided", .{});

    if (pub_lut_size != null and output_format == .bristol)
        fatal("cannot output bristol files using LUTs", .{});

    const input_file_dirname = std.fs.path.dirname(input_file_path.?) orelse ".";
    const input_file_basename = std.fs.path.basename(input_file_path.?);

    var working_dir = try std.fs.cwd().openDir(input_file_dirname, .{});
    defer working_dir.close();

    const input_file_type = classifyFileExt(input_file_basename) orelse {
        fatal("unrecognized input file type", .{});
    };

    const root_name = switch (input_file_type) {
        .c => input_file_basename[0 .. input_file_basename.len - ".c".len],
        .cxx => input_file_basename[0 .. input_file_basename.len - ".cxx".len],
        .verilog => input_file_basename[0 .. input_file_basename.len - ".v".len],
    };

    const verilog_file_path = try std.fmt.allocPrint(arena, "{s}.v", .{root_name});
    const json_file_path = try std.fmt.allocPrint(arena, "{s}.json", .{root_name});
    const torder_file_path = try std.fmt.allocPrint(arena, "{s}.torder", .{root_name});

    var progress = std.Progress{};
    const root_node = progress.start("", 0);
    defer root_node.end();

    switch (input_file_type) {
        .c, .cxx => {
            var xls_node = root_node.start("running high-level synthesis with XLS", 0);
            xls_node.activate();
            progress.refresh();

            const ir_file_path = try std.fmt.allocPrint(arena, "{s}.ir", .{root_name});
            const opt_ir_file_path = try std.fmt.allocPrint(arena, "{s}.opt.ir", .{root_name});

            xls.cxxToVerilog(
                gpa,
                working_dir,
                verbose,
                input_file_basename,
                ir_file_path,
                opt_ir_file_path,
                verilog_file_path,
                top_level_fn_module,
                include_dirs.items,
                loop_bound,
            ) catch |err| fatal("xls execution error: {}", .{err});

            if (!keep_intermediate_files) {
                try working_dir.deleteFile(ir_file_path);
                try working_dir.deleteFile(opt_ir_file_path);
            }

            xls_node.end();
        },
        else => {},
    }

    var yosys_node = root_node.start("compiling public components", 0);
    yosys_node.activate();
    progress.refresh();

    yosys.verilogToJson(
        gpa,
        working_dir,
        verbose,
        verilog_file_path,
        json_file_path,
        torder_file_path,
        top_level_fn_module,
        script,
        pub_lut_size,
    ) catch |err| fatal("yosys execution error: {}", .{err});
    yosys_node.end();

    const parsed_json = try parseJson(arena, working_dir, json_file_path);

    const torder = try Torder.parse(arena, working_dir, torder_file_path);

    var merge_node = root_node.start("merging circuits", 0);
    merge_node.activate();
    progress.refresh();

    var builder = Builder{
        .gpa = arena,
        .root = parsed_json.root,
        .torder = torder,
        .top_module = top_level_fn_module,
    };
    const circuit = builder.build() catch |err| switch (err) {
        error.BuildFail => fatal("{s}", .{builder.err_msg.?.msg}),
        else => return err,
    };
    // const dead_nodes = try dead_node_elimination.calculateDeadNodes(arena, circuit);
    merge_node.end();

    switch (output_format) {
        .syncirc => {
            const syncirc_file_path = try std.fmt.allocPrint(arena, "{s}.syncirc", .{root_name});

            try Emit.writeCircuit(circuit, null, working_dir, syncirc_file_path);
        },
        .bristol => {
            var linearize = Linearize{
                .gpa = arena,
                .circuit = circuit,
            };
            const circuit2 = linearize.run() catch |err| switch (err) {
                error.PassFail => fatal("{s}", .{linearize.err_msg.?.msg}),
                else => return err,
            };

            const bristol_file_path = try std.fmt.allocPrint(arena, "{s}.bristol", .{root_name});

            try EmitBristol.writeCircuit(circuit2, null, working_dir, bristol_file_path);
        },
    }

    if (!keep_intermediate_files) {
        if (input_file_type != .verilog) {
            try working_dir.deleteFile(verilog_file_path);
        }
        try working_dir.deleteFile(json_file_path);
        try working_dir.deleteFile(torder_file_path);
    }
}

fn parseJson(allocator: std.mem.Allocator, working_dir: std.fs.Dir, json_file_path: []const u8) !std.json.ValueTree {
    var json_file = try working_dir.openFile(json_file_path, .{});
    defer json_file.close();

    const json_file_contents = try json_file.readToEndAlloc(allocator, 4 * 1024 * 1024 * 1024);
    var json_parser = std.json.Parser.init(allocator, true);
    return try json_parser.parse(json_file_contents);
}
