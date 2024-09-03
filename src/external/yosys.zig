const std = @import("std");

const run = @import("run.zig").run;

const techmap_files = [_][]const u8{
    "map.v",

    "mux.v",

    "ADD8.v",
    "ADD16.v",
    "ADD32.v",
    "ADD64.v",
    "ADDC64.v",

    "bitext.v",

    "SUB8.v",
    "SUB16.v",
    "SUB32.v",
    "SUB64.v",

    "MUX16.v",
    "MUX32.v",
    "MUX64.v",

    "MULT8.v",
    "MULT16.v",
    "MULT32.v",

    "SUBC16.v",
    "SUBC32.v",
    "SUBC64.v",

    "DIV8.v",
    "DIV16.v",
    "DIV32.v",

    "COMP8.v",
    "COMP16.v",
    "COMP32.v",
    "COMP64.v",

    "bitonic_sort16.v",
    "bitonic_sort32.v",
    "bitonic_sort64.v",

    "Maxpool.v",

    "Argmax.v",

    "relu.v",
    "relu_bitext.v",

    "square_root_comb32.v",
    "square_root_comb64.v",

    "f32add.v",
    "f32sub.v",
    "f32mul.v",

    "f64add.v",
    "f64sub.v",
    "f64mul.v",

    "sbox.v",

    "psi.v",
};

fn getLibDir(
    allocator: std.mem.Allocator,
) ![]const u8 {
    const self_exe_dir_path = try std.fs.selfExeDirPathAlloc(allocator);
    defer allocator.free(self_exe_dir_path);
    const upper = std.fs.path.dirname(self_exe_dir_path) orelse return error.UnexpectedExeLocation;

    return try std.fs.path.join(allocator, &.{ upper, "lib", "syncirc" });
}

fn runYosysScript(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    yosys_script: []const u8,
) !void {
    const script_file_name = "tmp_spfe_yosys_script";
    try working_dir.writeFile(script_file_name, yosys_script);

    try run(allocator, working_dir, verbose, &.{ "yosys", "-s", script_file_name });

    try working_dir.deleteFile(script_file_name);
}

fn runAbcScript(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    abc_script: []const u8,
) !void {
    const script_file_name = "tmp_spfe_abc_script";
    try working_dir.writeFile(script_file_name, abc_script);

    try run(allocator, working_dir, verbose, &.{ "yosys-abc", "-f", script_file_name });

    try working_dir.deleteFile(script_file_name);
}

pub const SynthesisScript = enum {
    synth,
    manual,
};

pub fn verilogToJson(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    verilog_file_path: []const u8,
    json_file_path: []const u8,
    torder_file_path: []const u8,
    top_level_module: []const u8,
    script: SynthesisScript,
    pub_lut_size: ?u8,
) !void {
    var arena_instance = std.heap.ArenaAllocator.init(allocator);
    defer arena_instance.deinit();
    const arena = arena_instance.allocator();

    if (pub_lut_size) |lut_size| {
        try verilogToJsonLut(
            arena,
            working_dir,
            verbose,
            verilog_file_path,
            json_file_path,
            torder_file_path,
            top_level_module,
            lut_size,
        );
    } else {
        switch (script) {
            .synth => try verilogToJsonSynth(
                arena,
                working_dir,
                verbose,
                verilog_file_path,
                json_file_path,
                torder_file_path,
                top_level_module,
            ),
            .manual => try verilogToJsonManual(
                arena,
                working_dir,
                verbose,
                verilog_file_path,
                json_file_path,
                torder_file_path,
                top_level_module,
            ),
        }
    }
}

pub fn verilogToJsonSynth(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    verilog_file_path: []const u8,
    json_file_path: []const u8,
    torder_file_path: []const u8,
    top_level_module: []const u8,
) !void {
    const yosys_script = try std.fmt.allocPrint(
        arena,
        \\read_verilog {s}
        \\synth -top {s} -flatten
        \\abc -g AND,XOR
        \\tee -o {s} torder
        \\write_json {s}
    ,
        .{
            verilog_file_path,
            top_level_module,
            torder_file_path,
            json_file_path,
        },
    );

    try runYosysScript(arena, working_dir, verbose, yosys_script);
}

pub fn verilogToJsonManual(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    verilog_file_path: []const u8,
    json_file_path: []const u8,
    torder_file_path: []const u8,
    top_level_module: []const u8,
) !void {
    const lib_dir = try getLibDir(arena);

    const liberty_file_name = try std.fs.path.join(arena, &.{ lib_dir, "lib" });
    const abc_script_file_name = try std.fs.path.join(arena, &.{ lib_dir, "abc_script" });

    const techmap_lib_files = try arena.alloc([]const u8, techmap_files.len);
    for (techmap_files) |name, i| {
        techmap_lib_files[i] = try std.fs.path.join(arena, &.{ lib_dir, name });
    }

    const yosys_script = try std.fmt.allocPrint(
        arena,
        \\read_verilog -lib {s}
        \\read_verilog {s}
        \\hierarchy -check -top {s}
        \\proc; fsm; flatten; opt;
        \\booth
        \\techmap -autoproc -map {s}; opt;
        \\techmap; opt;
        \\dfflibmap -liberty {s}
        \\abc -liberty {s} -script {s}
        \\opt; clean;
        \\opt_clean -purge
        \\tee -o {s} torder
        \\write_json {s}
    ,
        .{
            try std.mem.join(
                arena,
                "\nread_verilog -lib ",
                techmap_lib_files
            ),
            verilog_file_path,
            top_level_module,
            try std.mem.join(
                arena,
                " -map ",
                techmap_lib_files
            ),
            liberty_file_name,
            liberty_file_name,
            abc_script_file_name,
            torder_file_path,
            json_file_path,
        },
    );

    try runYosysScript(arena, working_dir, verbose, yosys_script);
}

pub fn verilogToJsonLut(
    arena: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    verilog_file_path: []const u8,
    json_file_path: []const u8,
    torder_file_path: []const u8,
    top_level_module: []const u8,
    lut_size: u8,
) !void {
    const lib_dir = try getLibDir(arena);

    const techmap_lib_files = try arena.alloc([]const u8, techmap_files.len);
    for (techmap_files) |name, i| {
        techmap_lib_files[i] = try std.fs.path.join(arena, &.{ lib_dir, name });
    }

    const yosys_script = try std.fmt.allocPrint(
        arena,
        \\read_verilog -lib {s}
        \\read_verilog {s}
        \\hierarchy -check -top {s}
        \\techmap -autoproc -map {s}; opt;
        \\synth -top {s} -flatten -lut {}
        \\tee -o {s} torder
        \\write_json {s}
    ,
        .{
            try std.mem.join(
                arena,
                "\nread_verilog -lib ",
                techmap_lib_files
            ),
            verilog_file_path,
            top_level_module,
            try std.mem.join(
                arena,
                " -map ",
                techmap_lib_files
            ),
            top_level_module,
            lut_size,
            torder_file_path,
            json_file_path,
        },
    );

    try runYosysScript(arena, working_dir, verbose, yosys_script);
}
