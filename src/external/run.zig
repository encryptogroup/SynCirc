const std = @import("std");

const log = std.log.scoped(.external);

pub fn run(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    verbose: bool,
    argv: []const []const u8,
) !void {
    var child_process = std.ChildProcess.init(argv, allocator);

    child_process.stdin_behavior = .Ignore;
    child_process.stdout_behavior = if (verbose) .Inherit else .Ignore;
    child_process.stderr_behavior = if (verbose) .Inherit else .Ignore;
    child_process.cwd_dir = working_dir;

    const term = child_process.spawnAndWait() catch |err| {
        switch (err) {
            error.FileNotFound => log.err("{s} not found", .{argv[0]}),
            else => {},
        }
        return err;
    };

    if (term != .Exited or term.Exited != 0) {
        log.err("{s} exited abnormally: {}", .{ argv[0], term });
        if (!verbose) log.err("To see the full output, pass -v on the command-line", .{});
        return error.RunError;
    }
}
