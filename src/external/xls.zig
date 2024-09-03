const std = @import("std");

const run = @import("run.zig").run;

fn runXlscc(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    cxx_file_path: []const u8,
    ir_file_path: []const u8,
    top_level_fn_module: []const u8,
    include_dirs: []const []const u8,
    loop_bound: u32,
) !void {
    const xlscc: []const u8 = if (std.process.hasEnvVarConstant("XLSCC")) blk: {
        break :blk try std.process.getEnvVarOwned(arena, "XLSCC");
    } else "xlscc";

    const loop_bound_str = try std.fmt.allocPrint(arena, "{}", .{loop_bound});

    var args = std.ArrayList([]const u8).init(arena);
    defer args.deinit();

    try args.appendSlice(&.{
        xlscc,
        cxx_file_path,
        "--out",
        ir_file_path,
        "--top",
        top_level_fn_module,
        "--max_unroll_iters",
        loop_bound_str,
    });

    if (include_dirs.len > 0) {
        try args.appendSlice(&.{
            "--include_dirs",
            try std.mem.join(arena, ",", include_dirs),
        });
    }

    try run(arena, working_dir, verbose, args.items);
}

fn runOpt(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    ir_file_path: []const u8,
    opt_ir_file_path: []const u8,
) !void {
    const opt: []const u8 = if (std.process.hasEnvVarConstant("XLS_OPT")) blk: {
        break :blk try std.process.getEnvVarOwned(arena, "XLS_OPT");
    } else "opt_main";

    try run(arena, working_dir, verbose, &.{
        opt,
        ir_file_path,
        "--skip_passes",
        "inlining",
        "--out",
        opt_ir_file_path,
    });
}

fn runCodegen(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    opt_ir_file_path: []const u8,
    verilog_file_path: []const u8,
) !void {
    const codegen: []const u8 = if (std.process.hasEnvVarConstant("XLS_CODEGEN")) blk: {
        break :blk try std.process.getEnvVarOwned(arena, "XLS_CODEGEN");
    } else "codegen_main";

    try run(arena, working_dir, verbose, &.{
        codegen,
        "--generator=combinational",
        "--use_system_verilog=false",
        "--output_verilog_path",
        verilog_file_path,
        opt_ir_file_path,
    });
}

pub fn cxxToVerilog(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    cxx_file_path: []const u8,
    ir_file_path: []const u8,
    opt_ir_file_path: []const u8,
    verilog_file_path: []const u8,
    top_level_fn_module: []const u8,
    include_dirs: []const []const u8,
    loop_bound: u32,
) !void {
    var arena_instance = std.heap.ArenaAllocator.init(allocator);
    defer arena_instance.deinit();
    const arena = arena_instance.allocator();

    try runXlscc(arena, working_dir, verbose, cxx_file_path, ir_file_path, top_level_fn_module, include_dirs, loop_bound);

    try runOpt(arena, working_dir, verbose, ir_file_path, opt_ir_file_path);

    try runCodegen(arena, working_dir, verbose, opt_ir_file_path, verilog_file_path);
}
