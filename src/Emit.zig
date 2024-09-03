const std = @import("std");

const Circuit = @import("Circuit.zig");

const Emit = @This();

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

    var emit = Emit{
        .circuit = circuit,
        .dead_nodes = dead_nodes,
        .circuit_buffered_writer = std.io.bufferedWriter(circuit_file.writer()),
    };

    try emit.emitCircuit();
}

fn emitCircuit(emit: *Emit) !void {
    try emit.emitInputs();

    const circuit_tags = emit.circuit.nodes.items(.tag);
    for (circuit_tags) |tag, index| {
        if (emit.dead_nodes) |dead_nodes| {
            if (dead_nodes.isSet(index)) continue;
        }

        switch (tag) {
            .zero => try emit.emitConstant(index),
            .one => try emit.emitConstant(index),

            .inv => try emit.emitOneInput(index),

            .@"and" => try emit.emitTwoInput(index),
            .xor => try emit.emitTwoInput(index),

            .and3 => try emit.emitThreeInput(index),

            .and4 => try emit.emitFourInput(index),

            .lut => try emit.emitLut(index),
        }
    }

    try emit.emitOutputs();

    try emit.circuit_buffered_writer.flush();
}

fn emitInputs(emit: *Emit) !void {
    const writer = emit.circuit_buffered_writer.writer();
    if (emit.circuit.inputs.len > 0) {
        try writer.writeAll("C");
        for (emit.circuit.inputs) |input| {
            try writer.print(" {}", .{input});
        }
        try writer.writeAll("\n");
    }
}

fn emitOutputs(emit: *Emit) !void {
    const writer = emit.circuit_buffered_writer.writer();
    if (emit.circuit.outputs.len > 0) {
        try writer.writeAll("O");
        for (emit.circuit.outputs) |output| {
            try writer.print(" {}", .{output});
        }
        try writer.writeAll("\n");
    }
}

fn emitConstant(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const constant = emit.circuit.nodes.items(.data)[node].constant;

    const prefix = switch (tag) {
        .zero => "0",
        .one => "1",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("{s} {}\n", .{
        prefix,
        constant.output,
    });
}

fn emitOneInput(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const one_input = emit.circuit.nodes.items(.data)[node].one_input;

    const prefix = switch (tag) {
        .inv => "I",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("{s} {} {}\n", .{
        prefix,
        one_input.input,
        one_input.output,
    });
}

fn emitTwoInput(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const two_input = emit.circuit.nodes.items(.data)[node].two_input;

    const prefix = switch (tag) {
        .@"and" => "A",
        .xor => "E",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("{s} {} {} {}\n", .{
        prefix,
        two_input.input_a,
        two_input.input_b,
        two_input.output,
    });
}

fn emitThreeInput(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const three_input = emit.circuit.nodes.items(.data)[node].three_input;

    const prefix = switch (tag) {
        .and3 => "3",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("{s} {} {} {} {}\n", .{
        prefix,
        three_input.input_a,
        three_input.input_b,
        three_input.input_c,
        three_input.output,
    });
}

fn emitFourInput(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const four_input = emit.circuit.nodes.items(.data)[node].four_input;

    const prefix = switch (tag) {
        .and4 => "4",
        else => unreachable,
    };

    try emit.circuit_buffered_writer.writer().print("{s} {} {} {} {} {}\n", .{
        prefix,
        four_input.input_a,
        four_input.input_b,
        four_input.input_c,
        four_input.input_d,
        four_input.output,
    });
}

fn emitLut(emit: *Emit, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const lut = emit.circuit.nodes.items(.data)[node].lut;

    const prefix = switch (tag) {
        .lut => "L",
        else => unreachable,
    };

    const writer = emit.circuit_buffered_writer.writer();
    try writer.print("{s}", .{prefix});
    for (emit.circuit.luts[lut.offset..][0..lut.arity]) |input| {
        try writer.print(" {}", .{input});
    }
    try writer.print(" {} ", .{lut.output});

    // len = 2 ^ arity
    const table_len = @as(usize, 1) << @intCast(std.math.Log2Int(usize), lut.arity);

    switch (tag) {
        .lut => {
            for (emit.circuit.lut_tables[lut.table_offset..][0..table_len]) |bit| {
                try writer.print("{}", .{bit});
            }
            try writer.writeAll("\n");
        },
        else => unreachable,
    }
}
