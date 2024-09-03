//! Creates a linearized version of a circuit. A linearized circuit
//! has the following properties:
//!
//! - Input wires begin with 0 and end with <num_inputs> - 1
//! - Output wires begin with
//!     <max_wire_number> - <num_outputs>
//!   and end with
//!     <max_wire_number>
//! - No constant gates are in the circuit

const std = @import("std");
const assert = std.debug.assert;

const Circuit = @import("Circuit.zig");

const Linearize = @This();

gpa: std.mem.Allocator,

circuit: Circuit,

circuit_nodes: std.MultiArrayList(Circuit.Node) = .{},
circuit_luts: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_inputs: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_outputs: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_lut_tables: std.ArrayListUnmanaged(u1) = .{},
circuit_max_wire_number: Circuit.Node.Index = 0,

permutation: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
permutation_set: std.ArrayListUnmanaged(bool) = .{},

next_free_wire_number: Circuit.Node.Index = 0,

err_msg: ?ErrorMsg = null,

const ErrorMsg = struct {
    msg: []const u8,
};

const InnerError = error{
    OutOfMemory,
    PassFail,
};

pub fn run(lin: *Linearize) InnerError!Circuit {
    // LUT tables can be added as-is
    try lin.circuit_lut_tables.appendSlice(lin.gpa, lin.circuit.lut_tables);

    // Make space for the LUT inputs
    try lin.circuit_luts.resize(lin.gpa, lin.circuit.luts.len);

    // Set up permutation
    try lin.permutation.resize(lin.gpa, lin.circuit.max_wire_number + 1);
    try lin.permutation_set.resize(lin.gpa, lin.circuit.max_wire_number + 1);
    std.mem.set(bool, lin.permutation_set.items, false);

    // Set initial max_wire_number
    lin.circuit_max_wire_number = lin.circuit.max_wire_number;

    // Every constant gate requires an extra wire
    const tags = lin.circuit.nodes.items(.tag);
    for (tags) |tag| switch (tag) {
        .zero, .one => lin.circuit_max_wire_number += 1,
        else => {},
    };

    // Every input that is directly connected to an output requires a
    // copy consisting of two INVs, thus an extra wire. Additionally,
    // we need an additional wire number for the extra non-input wire
    // slot in the output wires.
    for (lin.circuit.inputs) |input| {
        if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.outputs, input) != null)
            lin.circuit_max_wire_number += 2;
    }

    // Every output wire that was mentioned earlier in the output
    // wires requires a copy consisting of two INVs, thus an extra
    // wire. Additionally, we need an additional wire number for the
    // extra non-duplicate slot in the output wires.
    for (lin.circuit.outputs) |output, i| {
        if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.outputs[0..i], output) != null)
            lin.circuit_max_wire_number += 2;
    }

    try lin.processInputs();

    try lin.processOutputsBegin();

    try lin.processGates();

    try lin.processOutputsEnd();

    return Circuit{
        .nodes = lin.circuit_nodes.toOwnedSlice(),
        .luts = lin.circuit_luts.toOwnedSlice(lin.gpa),
        .inputs = lin.circuit_inputs.toOwnedSlice(lin.gpa),
        .outputs = lin.circuit_outputs.toOwnedSlice(lin.gpa),
        .lut_tables = lin.circuit_lut_tables.toOwnedSlice(lin.gpa),
        .max_wire_number = lin.circuit_max_wire_number,
    };
}

fn fail(lin: *Linearize, comptime format: []const u8, args: anytype) InnerError {
    @setCold(true);
    assert(lin.err_msg == null);
    lin.err_msg = ErrorMsg{ .msg = try std.fmt.allocPrint(lin.gpa, format, args) };
    return error.PassFail;
}

fn addNode(lin: *Linearize, node: Circuit.Node) !void {
    try lin.circuit_nodes.ensureUnusedCapacity(lin.gpa, 1);
    lin.circuit_nodes.appendAssumeCapacity(node);
}

fn addMapping(lin: *Linearize, old_wire_number: Circuit.Node.Index, new_wire_number: Circuit.Node.Index) !void {
    assert(!lin.permutation_set.items[old_wire_number]);
    lin.permutation.items[old_wire_number] = new_wire_number;
    lin.permutation_set.items[old_wire_number] = true;
}

fn getFreshWireNumber(lin: *Linearize) Circuit.Node.Index {
    // check that we are not giving out wire numbers assigned to output
    assert(lin.next_free_wire_number <= lin.circuit_max_wire_number - lin.circuit.outputs.len);

    const new_wire_number = lin.next_free_wire_number;
    lin.next_free_wire_number += 1;

    return new_wire_number;
}

fn getMapping(
    lin: *Linearize,
    old_wire_number: Circuit.Node.Index,
) !Circuit.Node.Index {
    if (!lin.permutation_set.items[old_wire_number]) {
        const new_wire_number = lin.getFreshWireNumber();
        try lin.addMapping(old_wire_number, new_wire_number);
    }

    return lin.permutation.items[old_wire_number];
}

fn processInputs(lin: *Linearize) !void {
    try lin.circuit_inputs.resize(lin.gpa, lin.circuit.inputs.len);

    for (lin.circuit.inputs) |old_wire_number, i| {
        const new_wire_number = i;
        lin.circuit_inputs.items[i] = new_wire_number;
        try lin.addMapping(old_wire_number, new_wire_number);
    }

    lin.next_free_wire_number = lin.circuit.inputs.len;
}

fn processOutputsBegin(lin: *Linearize) !void {
    const num_outputs = lin.circuit.outputs.len;

    for (lin.circuit.outputs) |old_wire_number, i| {
        const new_wire_number = lin.circuit_max_wire_number - num_outputs + i + 1;

        // If this wire is a copy from an input wire, use the existing
        // mapping from the input wire
        if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.inputs, old_wire_number) != null)
            continue;

        // If this wire has been mentioned earlier in the output
        // wires, use the existing mapping from the first mention
        if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.outputs[0..i], old_wire_number) != null)
            continue;

        try lin.addMapping(old_wire_number, new_wire_number);
    }
}

fn addCopyNode(
    lin: *Linearize,
    input_wire: Circuit.Node.Index,
    output_wire: Circuit.Node.Index,
) !void {
    const tmp_wire = lin.getFreshWireNumber();

    try lin.addNode(.{
        .tag = .inv,
        .data = .{ .one_input = .{
            .input = input_wire,
            .output = tmp_wire,
            } },
    });

    try lin.addNode(.{
        .tag = .inv,
        .data = .{ .one_input = .{
            .input = tmp_wire,
            .output = output_wire,
            } },
    });
}

fn processOutputsEnd(lin: *Linearize) !void {
    const num_outputs = lin.circuit.outputs.len;
    try lin.circuit_outputs.resize(lin.gpa, lin.circuit.outputs.len);

    for (lin.circuit.outputs) |old_wire_number, i| {
        const new_wire_number = lin.circuit_max_wire_number - num_outputs + i + 1;

        if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.inputs, old_wire_number)) |input_wire_i| {
            try lin.addCopyNode(
                try lin.getMapping(lin.circuit.inputs[input_wire_i]),
                new_wire_number,
            );
        } else if (std.mem.indexOfScalar(Circuit.Node.Index, lin.circuit.outputs[0..i], old_wire_number)) |first_output_wire_i| {
            try lin.addCopyNode(
                try lin.getMapping(lin.circuit.outputs[first_output_wire_i]),
                new_wire_number,
            );
        }

        lin.circuit_outputs.items[i] = new_wire_number;
    }
}

fn processGates(lin: *Linearize) !void {
    try lin.circuit_nodes.ensureUnusedCapacity(lin.gpa, lin.circuit.nodes.len);

    const tags = lin.circuit.nodes.items(.tag);
    const datas = lin.circuit.nodes.items(.data);
    for (tags) |tag, i| {
        const data: Circuit.Node.Data = switch (tag) {
            // 0 = x AND (NOT x)
            // 1 = x XOR (NOT x)
            .zero, .one => {
                const constant = datas[i].constant;

                const tmp_wire = lin.getFreshWireNumber();
                const output_wire = try lin.getMapping(constant.output);

                try lin.addNode(.{
                    .tag = .inv,
                    .data = .{ .one_input = .{
                        .input = try lin.getMapping(lin.circuit.inputs[0]),
                        .output = tmp_wire,
                    } },
                });

                try lin.addNode(.{
                    .tag = switch (tag) {
                        .zero => .@"and",
                        .one => .xor,
                        else => unreachable,
                    },
                    .data = .{ .two_input = .{
                        .input_a = try lin.getMapping(lin.circuit.inputs[0]),
                        .input_b = tmp_wire,
                        .output = output_wire,
                    } },
                });

                continue;
            },
            .inv => blk: {
                const one_input = datas[i].one_input;
                break :blk .{ .one_input = .{
                    .input = try lin.getMapping(one_input.input),
                    .output = try lin.getMapping(one_input.output),
                } };
            },
            .@"and",
            .xor,
            => blk: {
                const two_input = datas[i].two_input;
                break :blk .{ .two_input = .{
                    .input_a = try lin.getMapping(two_input.input_a),
                    .input_b = try lin.getMapping(two_input.input_b),
                    .output = try lin.getMapping(two_input.output),
                } };
            },
            .and3 => blk: {
                const three_input = datas[i].three_input;
                break :blk .{ .three_input = .{
                    .input_a = try lin.getMapping(three_input.input_a),
                    .input_b = try lin.getMapping(three_input.input_b),
                    .input_c = try lin.getMapping(three_input.input_c),
                    .output = try lin.getMapping(three_input.output),
                } };
            },
            .and4 => blk: {
                const four_input = datas[i].four_input;
                break :blk .{ .four_input = .{
                    .input_a = try lin.getMapping(four_input.input_a),
                    .input_b = try lin.getMapping(four_input.input_b),
                    .input_c = try lin.getMapping(four_input.input_c),
                    .input_d = try lin.getMapping(four_input.input_d),
                    .output = try lin.getMapping(four_input.output),
                } };
            },
            .lut => blk: {
                const lut = datas[i].lut;

                for (lin.circuit.luts[lut.offset..][0..lut.arity]) |input, j| {
                    lin.circuit_luts.items[lut.offset + j] = try lin.getMapping(input);
                }

                break :blk .{ .lut = .{
                    .offset = lut.offset,
                    .table_offset = lut.table_offset,
                    .arity = lut.arity,
                    .output = try lin.getMapping(lut.output),
                } };
            },
        };

        try lin.addNode(.{
            .tag = tag,
            .data = data,
        });
    }
}
