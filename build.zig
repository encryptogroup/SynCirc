const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    b.installDirectory(.{
        .source_dir = "lib",
        .install_dir = .lib,
        .install_subdir = "syncirc",
    });

    const compiler = b.addExecutable("syncirc", "src/main.zig");
    compiler.setTarget(target);
    compiler.setBuildMode(mode);
    compiler.install();

    const convert = b.addExecutable("convert", "src/convert.zig");
    convert.setTarget(target);
    convert.setBuildMode(mode);
    convert.install();

    const eval = b.addExecutable("eval", "src/eval.zig");
    eval.setTarget(target);
    eval.setBuildMode(mode);
    eval.install();

    const stats = b.addExecutable("stats", "src/stats.zig");
    stats.setTarget(target);
    stats.setBuildMode(mode);
    stats.install();

    const tests = b.addTest("src/test.zig");
    tests.setTarget(target);
    tests.setBuildMode(mode);
    tests.addPackagePath("test_cases", "test/cases.zig");
    tests.step.dependOn(b.getInstallStep());

    const test_options = b.addOptions();
    tests.addOptions("build_options", test_options);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.step);
}
