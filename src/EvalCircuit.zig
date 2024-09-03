const std = @import("std");

const Circuit = @import("Circuit.zig");

const Eval = @This();

circuit: Circuit,
wire_values: std.DynamicBitSetUnmanaged,

pub fn evaluateCircuit(
    gpa: std.mem.Allocator,
    circuit: Circuit,
    inputs: []const u1,
) ![]const u1 {
    var eval = Eval{
        .circuit = circuit,
        .wire_values = try std.DynamicBitSetUnmanaged.initEmpty(gpa, circuit.max_wire_number + 1),
    };

    if (inputs.len != circuit.inputs.len) return error.InvalidNumberOfInputs;
    for (inputs) |bit, i| {
        switch (bit) {
            0 => eval.wire_values.unset(circuit.inputs[i]),
            1 => eval.wire_values.set(circuit.inputs[i]),
        }
    }

    try eval.evalCircuit();

    const outputs = try gpa.alloc(u1, circuit.outputs.len);
    for (circuit.outputs) |wire_number, i| {
        outputs[i] = @boolToInt(eval.wire_values.isSet(wire_number));
    }
    return outputs;
}

fn evalCircuit(eval: *Eval) !void {
    const circuit_tags = eval.circuit.nodes.items(.tag);
    for (circuit_tags) |tag, index| {
        switch (tag) {
            .zero => try eval.evalConstant(index),
            .one => try eval.evalConstant(index),

            .inv => try eval.evalOneInput(index),

            .@"and" => try eval.evalTwoInput(index),
            .xor => try eval.evalTwoInput(index),

            .and3 => try eval.evalThreeInput(index),

            .and4 => try eval.evalFourInput(index),

            .lut => try eval.evalLut(index),
        }
    }
}

fn evalConstant(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const constant = eval.circuit.nodes.items(.data)[node].constant;

    const output = switch (tag) {
        .zero => false,
        .one => true,
        else => unreachable,
    };

    eval.wire_values.setValue(constant.output, output);
}

fn evalOneInput(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const one_input = eval.circuit.nodes.items(.data)[node].one_input;

    const input = eval.wire_values.isSet(one_input.input);
    const output = switch (tag) {
        .inv => !input,
        else => unreachable,
    };

    eval.wire_values.setValue(one_input.output, output);
}

fn evalTwoInput(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const two_input = eval.circuit.nodes.items(.data)[node].two_input;

    const input_a = eval.wire_values.isSet(two_input.input_a);
    const input_b = eval.wire_values.isSet(two_input.input_b);
    const output = switch (tag) {
        .@"and" => input_a and input_b,
        .xor => input_a != input_b,
        else => unreachable,
    };

    eval.wire_values.setValue(two_input.output, output);
}

fn evalThreeInput(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const three_input = eval.circuit.nodes.items(.data)[node].three_input;

    const input_a = eval.wire_values.isSet(three_input.input_a);
    const input_b = eval.wire_values.isSet(three_input.input_b);
    const input_c = eval.wire_values.isSet(three_input.input_c);
    const output = switch (tag) {
        .and3 => input_a and input_b and input_c,
        else => unreachable,
    };

    eval.wire_values.setValue(three_input.output, output);
}

fn evalFourInput(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const four_input = eval.circuit.nodes.items(.data)[node].four_input;

    const input_a = eval.wire_values.isSet(four_input.input_a);
    const input_b = eval.wire_values.isSet(four_input.input_b);
    const input_c = eval.wire_values.isSet(four_input.input_c);
    const input_d = eval.wire_values.isSet(four_input.input_d);
    const output = switch (tag) {
        .and4 => input_a and input_b and input_c and input_d,
        else => unreachable,
    };

    eval.wire_values.setValue(four_input.output, output);
}

fn evalLut(eval: *Eval, node: Circuit.Node.Index) !void {
    const tag = eval.circuit.nodes.items(.tag)[node];
    const lut = eval.circuit.nodes.items(.data)[node].lut;

    const input_wires = eval.circuit.luts[lut.offset..][0..lut.arity];
    const output = switch (tag) {
        .lut => blk: {
            // len = 2 ^ arity
            const table_len = @as(usize, 1) << @intCast(std.math.Log2Int(usize), lut.arity);
            const table = eval.circuit.lut_tables[lut.table_offset..][0..table_len];

            var index_into_table: usize = 0;
            for (input_wires) |input_wire, i| {
                const input = @boolToInt(eval.wire_values.isSet(input_wire));
                index_into_table |= @as(usize, input) << @intCast(std.math.Log2Int(usize), i);
            }

            break :blk switch (table[index_into_table]) {
                0 => false,
                1 => true,
            };
        },
        else => unreachable,
    };

    eval.wire_values.setValue(lut.output, output);
}
