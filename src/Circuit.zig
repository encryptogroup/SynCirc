const std = @import("std");

nodes: std.MultiArrayList(Node).Slice,
luts: []const Node.Index,
inputs: []const Node.Index,
outputs: []const Node.Index,
lut_tables: []const u1,
max_wire_number: Node.Index,

pub const Node = struct {
    tag: Tag,
    data: Data,

    pub const Tag = enum(u8) {
        /// Constant zero. Uses constant field
        zero,
        /// Constant one. Uses constant field
        one,
        /// Invert. Uses one_input field
        inv,
        /// And. Uses two_input field
        @"and",
        /// 3-input And. Uses three_input field
        and3,
        /// 4-input And. Uses four_input field
        and4,
        /// Exclusive or. Uses two_input field
        xor,
        /// Look-up table. Uses lut field
        lut,
    };

    pub const Index = u64;

    pub const Data = union {
        constant: struct {
            output: Index,
        },
        one_input: struct {
            input: Index,
            output: Index,
        },
        two_input: struct {
            input_a: Index,
            input_b: Index,
            output: Index,
        },
        three_input: struct {
            input_a: Index,
            input_b: Index,
            input_c: Index,
            output: Index,
        },
        four_input: struct {
            input_a: Index,
            input_b: Index,
            input_c: Index,
            input_d: Index,
            output: Index,
        },
        lut: struct {
            offset: Index,
            table_offset: Index,
            arity: u8,
            output: Index,
        },
    };
};
