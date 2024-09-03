const std = @import("std");

const Circuit = @import("Circuit.zig");

const EmitBristol = @This();

circuit: Circuit,
dead_nodes: ?std.DynamicBitSetUnmanaged,
circuit_buffered_writer: std.io.BufferedWriter(4096, std.fs.File.Writer),

pub fn writeCircuit(
    circuit: Circuit,
    dead_nodes: ?std.DynamicBitSetUnmanaged,
    working_dir: std.fs.Dir,
    circuit_file_path: []const u8,
) !void {
    var circuit_file = try working_dir.createFile(circuit_file_path, .{});
    defer circuit_file.close();

    var emit = EmitBristol{
        .circuit = circuit,
        .dead_nodes = dead_nodes,
        .circuit_buffered_writer = std.io.bufferedWriter(circuit_file.writer()),
    };

    try emit.emitCircuit();
}

fn emitCircuit(emit: *EmitBristol) !void {
    try emit.emitHeader();

    const circuit_tags = emit.circuit.nodes.items(.tag);
    for (circuit_tags) |tag, index| {
        if (emit.dead_nodes) |dead_nodes| {
            if (dead_nodes.isSet(index)) continue;
        }

        switch (tag) {
            .zero => return error.UnsupportedNodeType,
            .one => return error.UnsupportedNodeType,

            .inv => try emit.emitOneInput(index),

            .@"and" => try emit.emitTwoInput(index),
            .xor => try emit.emitTwoInput(index),

            .and3 => try emit.emitThreeInput(index),

            .and4 => try emit.emitFourInput(index),

            .lut => return error.UnsupportedNodeType,
        }
    }

    try emit.circuit_buffered_writer.flush();
}

fn emitHeader(emit: *EmitBristol) !void {
    const writer = emit.circuit_buffered_writer.writer();

    try writer.print(
        \\{} {}
        \\{} {}
        \\
        \\
    ,
        .{
            emit.circuit.nodes.len,
            emit.circuit.max_wire_number + 1,
            emit.circuit.inputs.len,
            emit.circuit.outputs.len,
        },
    );
}

fn emitOneInput(emit: *EmitBristol, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const one_input = emit.circuit.nodes.items(.data)[node].one_input;

    const postfix = switch (tag) {
        .inv => "INV",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("1 1 {} {} {s}\n", .{
        one_input.input,
        one_input.output,
        postfix,
    });
}

fn emitTwoInput(emit: *EmitBristol, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const two_input = emit.circuit.nodes.items(.data)[node].two_input;

    const postfix = switch (tag) {
        .@"and" => "AND",
        .xor => "XOR",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("2 1 {} {} {} {s}\n", .{
        two_input.input_a,
        two_input.input_b,
        two_input.output,
        postfix,
    });
}

fn emitThreeInput(emit: *EmitBristol, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const three_input = emit.circuit.nodes.items(.data)[node].three_input;

    const postfix = switch (tag) {
        .and3 => "AND3",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("3 1 {} {} {} {} {s}\n", .{
        three_input.input_a,
        three_input.input_b,
        three_input.input_c,
        three_input.output,
        postfix,
    });
}

fn emitFourInput(emit: *EmitBristol, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const four_input = emit.circuit.nodes.items(.data)[node].four_input;

    const postfix = switch (tag) {
        .and4 => "AND4",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("4 1 {} {} {} {} {} {s}\n", .{
        four_input.input_a,
        four_input.input_b,
        four_input.input_c,
        four_input.input_d,
        four_input.output,
        postfix,
    });
}
