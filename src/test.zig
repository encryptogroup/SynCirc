const std = @import("std");
const builtin = @import("builtin");
const build_options = @import("build_options");
const yosys = @import("external/yosys.zig");

pub const Case = struct {
    input_file_path: []const u8,
    pub_lut_size: ?u8 = null,
    script: yosys.SynthesisScript = .synth,
    output_equality_check: ?OutputEquality = null,
    evaluate_check: ?[]const InputOutput = null,

    pub const SynthesisScript = yosys.SynthesisScript;

    pub const OutputEquality = struct {
        expected_syncirc_file: []const u8,
    };

    /// input and output strings (e.g. "0110")
    pub const InputOutput = struct {
        input: []const []const u8,
        output: []const u8,
    };

    pub fn run(case: Case, gpa: std.mem.Allocator) !void {
        var arena_instance = std.heap.ArenaAllocator.init(gpa);
        defer arena_instance.deinit();
        const arena = arena_instance.allocator();

        const name = try std.fmt.allocPrint(arena, "{s} lut_size={any} script={}", .{
            case.input_file_path,
            case.pub_lut_size,
            case.script,
        });

        var tmp_dir = std.testing.tmpDir(.{});
        defer tmp_dir.cleanup();

        // TODO find a way to make this independent of cwd
        var test_dir = try std.fs.cwd().openDir("test", .{});
        defer test_dir.close();

        const tmp_dir_path = try std.fs.path.join(
            arena,
            &.{ "zig-cache", "tmp", &tmp_dir.sub_path },
        );
        const compiler_exe_path = try std.fs.path.join(
            arena,
            &.{ "zig-out", "bin", "syncirc" },
        );
        const eval_exe_path = try std.fs.path.join(
            arena,
            &.{ "zig-out", "bin", "eval" },
        );

        const tmp_input_file_path = try std.fs.path.join(
            arena,
            &.{ tmp_dir_path, "test.v" },
        );

        try test_dir.copyFile(case.input_file_path, tmp_dir.dir, "test.v", .{});

        const output_formats: []const []const u8 = if (case.pub_lut_size != null)
            &.{"syncirc"}
        else
            &.{"bristol", "syncirc"};

        for (output_formats) |output_format| {
            var arg_list = std.ArrayList([]const u8).init(arena);
            try arg_list.appendSlice(&.{
                compiler_exe_path,
                tmp_input_file_path,
                "-s",
                @tagName(case.script),
                "-f",
                output_format,
            });
            if (case.pub_lut_size) |lut_size| {
                try arg_list.appendSlice(&.{
                    "-L",
                    try std.fmt.allocPrint(arena, "{}", .{lut_size}),
                });
            }
            const args = arg_list.toOwnedSlice();

            const result = try std.ChildProcess.exec(.{
                .allocator = arena,
                .argv = args,
            });
            if (result.term != .Exited or result.term.Exited != 0) {
                std.debug.print("test case {s}: The following exited abnormally with {}:\n{s}\n", .{
                    name,
                    result.term,
                    try std.mem.join(arena, " ", args),
                });
                if (result.stdout.len > 0) std.debug.print("compiler stdout: {s}", .{result.stdout});
                if (result.stderr.len > 0) std.debug.print("compiler stderr: {s}", .{result.stderr});
                return error.CompilerFailed;
            }
        }

        if (case.output_equality_check) |data| {
            const syncirc = try tmp_dir.dir.readFileAlloc(arena, "test.syncirc", 40 * 1024 * 1024);

            try std.testing.expectEqualStrings(data.expected_syncirc_file, syncirc);
        }

        if (case.evaluate_check) |data| {
            for (output_formats) |output_format| {
                const filename = try std.fmt.allocPrint(arena, "test.{s}", .{output_format});
                const path = try std.fs.path.join(arena, &.{ tmp_dir_path, filename });

                for (data) |input_output| {
                    var arg_list = std.ArrayList([]const u8).init(arena);
                    try arg_list.appendSlice(&.{
                        eval_exe_path,
                        path,
                    });
                    try arg_list.appendSlice(input_output.input);
                    const args = arg_list.toOwnedSlice();

                    const eval_result = try std.ChildProcess.exec(.{
                        .allocator = arena,
                        .argv = args,
                    });
                    if (eval_result.term != .Exited or eval_result.term.Exited != 0) {
                        std.debug.print("test case {s}: {s} exited abnormally: {}\n", .{
                            name,
                            eval_exe_path,
                            eval_result.term,
                        });
                        if (eval_result.stdout.len > 0) std.debug.print("eval stdout: {s}", .{eval_result.stdout});
                        if (eval_result.stderr.len > 0) std.debug.print("eval stderr: {s}", .{eval_result.stderr});
                        return error.EvalFailed;
                    }

                    const cleaned_output = std.mem.trimRight(u8, eval_result.stdout, "\n");
                    std.testing.expectEqualStrings(input_output.output, cleaned_output) catch {
                        std.debug.print("in test case {s}\n", .{
                            name,
                        });
                        return error.EvalFailed;
                    };
                }
            }
        }
    }
};

fn probe(exe_path: []const u8) !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const result = try std.ChildProcess.exec(.{
        .allocator = arena,
        .argv = &.{exe_path},
    });
    switch (result.term) {
        .Exited => return,
        else => return error.ProbeFailed,
    }
}

test {
    const allocator = std.testing.allocator;
    var cases = std.ArrayList(Case).init(allocator);
    defer cases.deinit();

    try @import("test_cases").addCases(&cases);

    var progress = std.Progress{};
    const root_node = progress.start("", 0);
    defer root_node.end();

    var tests_node = root_node.start("testing", cases.items.len);
    tests_node.activate();
    for (cases.items) |case| {
        try case.run(allocator);
        tests_node.completeOne();
    }
    tests_node.end();
}
