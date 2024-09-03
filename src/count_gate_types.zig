const std = @import("std");

const Circuit = @import("Circuit.zig");

// TODO replace with std.enums.EnumMap
pub const GateTypeCount = struct {
    inv: Circuit.Node.Index = 0,
    @"and": Circuit.Node.Index = 0,
    and3: Circuit.Node.Index = 0,
    and4: Circuit.Node.Index = 0,
    xor: Circuit.Node.Index = 0,
    lut: Circuit.Node.Index = 0,

    lut_input_sizes: [256]Circuit.Node.Index = .{0} ** 256,
};

pub fn countGateTypes(
    circuit: Circuit,
) GateTypeCount {
    const circuit_tags = circuit.nodes.items(.tag);
    const circuit_data = circuit.nodes.items(.data);

    var count = GateTypeCount{};
    for (circuit_tags) |tag, index| {
        switch (tag) {
            .zero, .one => continue,

            .inv => count.inv += 1,
            .@"and" => count.@"and" += 1,
            .and3 => count.and3 += 1,
            .and4 => count.and4 += 1,
            .xor => count.xor += 1,

            .lut => {
                count.lut += 1;

                const arity = circuit_data[index].lut.arity;
                count.lut_input_sizes[arity] += 1;
            },
        }
    }

    return count;
}
