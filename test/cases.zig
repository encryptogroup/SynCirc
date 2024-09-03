const std = @import("std");

const Case = @import("../src/test.zig").Case;
const SynthesisScript = Case.SynthesisScript;

const scripts = [_]SynthesisScript{
    .synth, .manual,
};

pub fn addCases(cases: *std.ArrayList(Case)) !void {
    for ([_]?u8{ null, 2, 3, 4 }) |pub_lut_size| {
        for (scripts) |script| {
            try addCasesExtended(cases, pub_lut_size, script);
        }
    }
}

// adapted from std.fmt.comptimePrint
fn encode_u32(comptime val: u32) *const [32:0]u8 {
    comptime {
        var buf: [32:0]u8 = undefined;
        _ = std.fmt.bufPrint(&buf, "{b:0>32}", .{val}) catch unreachable;
        buf[buf.len] = 0;

        std.mem.reverse(u8, &buf);

        return &buf;
    }
}

fn encode_f32(comptime val: f32) *const [32:0]u8 {
    return encode_u32(@bitCast(u32, val));
}

fn addCasesExtended(
    cases: *std.ArrayList(Case),
    pub_lut_size: ?u8,
    script: SynthesisScript,
) !void {
    for ([_][]const u8{ "simple/simple.v", "simple/simple_depth_1.v", "simple/simple_depth_2.v" }) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("simple/simple.spfe"),
            //     .expected_prog_file = @embedFile("simple/simple.spfe.prog"),
            // },
        });
    }
    for ([_][]const u8{ "invert/invert.v", "invert/invert_depth_3.v" }) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("invert/invert.spfe"),
            //     .expected_prog_file = @embedFile("invert/invert.spfe.prog"),
            // },
        });
    }
    for ([_][]const u8{ "constant/constant.v", "constant/constant_depth_2.v" }) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("constant/constant.spfe"),
            //     .expected_prog_file = @embedFile("constant/constant.spfe.prog"),
            // },
        });
    }
    for ([_][]const u8{ "and2/and2.v", "and2/and2_depth_3.v" }) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("and2/and2.spfe"),
            //     .expected_prog_file = @embedFile("and2/and2.spfe.prog"),
            // },
        });
    }
    for ([_][]const u8{ "reused_output/reused_output.v", "reused_output/reused_output_depth_2.v" }) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("reused_output/reused_output.spfe"),
            //     .expected_prog_file = @embedFile("reused_output/reused_output.spfe.prog"),
            // },
            .evaluate_check = &.{
                .{
                    .input = &.{"00"},
                    .output = "00",
                },
                .{
                    .input = &.{"11"},
                    .output = "11",
                },
                .{
                    .input = &.{"10"},
                    .output = "00",
                },
            },
        });
    }
    for ([_][]const u8{"reused_output/reused_output2.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("reused_output/reused_output.spfe"),
            //     .expected_prog_file = @embedFile("reused_output/reused_output.spfe.prog"),
            // },
            .evaluate_check = &.{
                .{
                    .input = &.{"00"},
                    .output = "0000",
                },
                .{
                    .input = &.{"11"},
                    .output = "1111",
                },
                .{
                    .input = &.{"10"},
                    .output = "1000",
                },
                .{
                    .input = &.{"01"},
                    .output = "0100",
                },
            },
        });
    }
    for ([_][]const u8{"reused_output/reused_output3.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            // .output_equality_check = .{
            //     .expected_spfe_file = @embedFile("reused_output/reused_output.spfe"),
            //     .expected_prog_file = @embedFile("reused_output/reused_output.spfe.prog"),
            // },
            .evaluate_check = &.{
                .{
                    .input = &.{"00"},
                    .output = "0000",
                },
                .{
                    .input = &.{"11"},
                    .output = "1111",
                },
                .{
                    .input = &.{"10"},
                    .output = "0010",
                },
                .{
                    .input = &.{"01"},
                    .output = "0001",
                },
            },
        });
    }
    for ([_][]const u8{"and4/and4.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1111"},
                    .output = "1",
                },
                .{
                    .input = &.{"1001"},
                    .output = "0",
                },
            },
        });
    }
    for ([_][]const u8{"add32/add32.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_u32(0), comptime encode_u32(0)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(0)},
                    .output = comptime encode_u32(1),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(1)},
                    .output = comptime encode_u32(2),
                },
                .{
                    .input = &.{comptime encode_u32(1234), comptime encode_u32(2345)},
                    .output = comptime encode_u32(3579),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(0)},
                    .output = comptime encode_u32(std.math.maxInt(u32)),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(1)},
                    .output = comptime encode_u32(0),
                },
            },
        });
    }
    for ([_][]const u8{"sub32/sub32.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_u32(0), comptime encode_u32(0)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(0)},
                    .output = comptime encode_u32(1),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(1)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(2345), comptime encode_u32(1234)},
                    .output = comptime encode_u32(1111),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(0)},
                    .output = comptime encode_u32(std.math.maxInt(u32)),
                },
                .{
                    .input = &.{comptime encode_u32(0), comptime encode_u32(1)},
                    .output = comptime encode_u32(std.math.maxInt(u32)),
                },
            },
        });
    }
    for ([_][]const u8{"mul32/mul32.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_u32(0), comptime encode_u32(0)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(0)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(1)},
                    .output = comptime encode_u32(1),
                },
                .{
                    .input = &.{comptime encode_u32(1234), comptime encode_u32(2345)},
                    .output = comptime encode_u32(2893730),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(0)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(1)},
                    .output = comptime encode_u32(std.math.maxInt(u32)),
                },
            },
        });
    }
    for ([_][]const u8{"div32/div32.v"}) |path| {
        // FIXME library has a bug
        if (script == .manual) continue;
        if (pub_lut_size != null) continue;

        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_u32(0), comptime encode_u32(1)},
                    .output = comptime encode_u32(0),
                },
                .{
                    .input = &.{comptime encode_u32(1), comptime encode_u32(1)},
                    .output = comptime encode_u32(1),
                },
                .{
                    .input = &.{comptime encode_u32(1024), comptime encode_u32(2)},
                    .output = comptime encode_u32(512),
                },
                .{
                    .input = &.{comptime encode_u32(12345), comptime encode_u32(234)},
                    .output = comptime encode_u32(52),
                },
                .{
                    .input = &.{comptime encode_u32(std.math.maxInt(u32)), comptime encode_u32(1)},
                    .output = comptime encode_u32(std.math.maxInt(u32)),
                },
            },
        });
    }
    for ([_][]const u8{"cmp32/gt.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1010000000000000000000000000000010000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010100000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000001"},
                    .output = "0",
                },
                .{
                    .input = &.{"1111111111111111111111111111111100000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1111111111111111111111111111111110000000000000000000000000000000"},
                    .output = "1",
                },
            },
        });
    }
    for ([_][]const u8{"cmp32/gte.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1010000000000000000000000000000010000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010100000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000001"},
                    .output = "0",
                },
                .{
                    .input = &.{"1111111111111111111111111111111100000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1111111111111111111111111111111110000000000000000000000000000000"},
                    .output = "1",
                },
            },
        });
    }
    for ([_][]const u8{"cmp32/lt.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1010000000000000000000000000000010000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010100000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000001"},
                    .output = "1",
                },
                .{
                    .input = &.{"1111111111111111111111111111111100000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1111111111111111111111111111111110000000000000000000000000000000"},
                    .output = "0",
                },
            },
        });
    }
    for ([_][]const u8{"cmp32/lte.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010000000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1010000000000000000000000000000010000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1000000000000000000000000000000010100000000000000000000000000000"},
                    .output = "1",
                },
                .{
                    .input = &.{"1000000000000000000000000000000000000000000000000000000000000001"},
                    .output = "1",
                },
                .{
                    .input = &.{"1111111111111111111111111111111100000000000000000000000000000000"},
                    .output = "0",
                },
                .{
                    .input = &.{"1111111111111111111111111111111110000000000000000000000000000000"},
                    .output = "0",
                },
            },
        });
    }
    for ([_][]const u8{"cond_increment/cond_increment.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_u32(0)},
                    .output = "10000000000000000000000000000000",
                },
                .{
                    .input = &.{"00000000000000000000000000000001"},
                    .output = "00000000000000000000000000000001",
                },
                .{
                    .input = &.{"00000000000000000000000000100000"},
                    .output = "00000000000000000000000000100000",
                },
                .{
                    .input = &.{"11100110000000000000000000000000"},
                    .output = "00010110000000000000000000000000",
                },
                .{
                    .input = &.{"11100110000000000100000000000000"},
                    .output = "11100110000000000100000000000000",
                },
            },
        });
    }
    for ([_][]const u8{"bitreverse/bitreverse.v"}) |path| {
        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{"0000"},
                    .output = "0000",
                },
                .{
                    .input = &.{"1000"},
                    .output = "0001",
                },
                .{
                    .input = &.{"0001"},
                    .output = "1000",
                },
                .{
                    .input = &.{"1001"},
                    .output = "1001",
                },
                .{
                    .input = &.{"1100"},
                    .output = "0011",
                },
                .{
                    .input = &.{"1010"},
                    .output = "0101",
                },
            },
        });
    }
    for ([_][]const u8{"f32/add.v"}) |path| {
        // float not supported by synth
        if (script == .synth) continue;

        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_f32(0.0), comptime encode_f32(0.0)},
                    .output = comptime encode_f32(0.0),
                },
                .{
                    .input = &.{comptime encode_f32(0.0), comptime encode_f32(1.0)},
                    .output = comptime encode_f32(1.0),
                },
                .{
                    .input = &.{comptime encode_f32(0.0), comptime encode_f32(-1.0)},
                    .output = comptime encode_f32(-1.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(0.0)},
                    .output = comptime encode_f32(1.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(0.0)},
                    .output = comptime encode_f32(1.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(-1.0)},
                    .output = comptime encode_f32(0.0),
                },
                .{
                    .input = &.{comptime encode_f32(42.0), comptime encode_f32(0.625)},
                    .output = comptime encode_f32(42.625),
                },
                .{
                    .input = &.{comptime encode_f32(42.0), comptime encode_f32(-42.625)},
                    .output = comptime encode_f32(-0.625),
                },
            },
        });
    }
    for ([_][]const u8{"f32/mul.v"}) |path| {
        // float not supported by synth
        if (script == .synth) continue;

        try cases.append(.{
            .input_file_path = path,
            .pub_lut_size = pub_lut_size,
            .script = script,
            .evaluate_check = &.{
                .{
                    .input = &.{comptime encode_f32(0.0), comptime encode_f32(0.0)},
                    .output = comptime encode_f32(0.0),
                },
                .{
                    .input = &.{comptime encode_f32(0.0), comptime encode_f32(1.0)},
                    .output = comptime encode_f32(0.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(0.0)},
                    .output = comptime encode_f32(0.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(1.0)},
                    .output = comptime encode_f32(1.0),
                },
                .{
                    .input = &.{comptime encode_f32(1.0), comptime encode_f32(-1.0)},
                    .output = comptime encode_f32(-1.0),
                },
                .{
                    .input = &.{comptime encode_f32(42.0), comptime encode_f32(0.5)},
                    .output = comptime encode_f32(21.0),
                },
                .{
                    .input = &.{comptime encode_f32(42.0), comptime encode_f32(-0.25)},
                    .output = comptime encode_f32(-10.5),
                },
            },
        });
    }
}
