const std = @import("std");

const Circuit = @import("Circuit.zig");

const EmitVerilog = @This();

circuit: Circuit,
module_name: []const u8,
verilog_buffered_writer: std.io.BufferedWriter(4096, std.fs.File.Writer),

pub fn writeCircuit(
    circuit: Circuit,
    working_dir: std.fs.Dir,
    module_name: []const u8,
    verilog_file_path: []const u8,
) !void {
    var verilog_file = try working_dir.createFile(verilog_file_path, .{});
    defer verilog_file.close();

    var emit = EmitVerilog{
        .circuit = circuit,
        .module_name = module_name,
        .verilog_buffered_writer = std.io.bufferedWriter(verilog_file.writer()),
    };

    try emit.emitCircuit();
}

fn emitCircuit(emit: *EmitVerilog) !void {
    try emit.emitModuleBegin();
    try emit.emitWireDefinitions();
    try emit.emitInputAssignments();

    const circuit_tags = emit.circuit.nodes.items(.tag);
    for (circuit_tags) |tag, index| {
        switch (tag) {
            .zero => try emit.emitConstant(index),
            .one => try emit.emitConstant(index),

            .inv => try emit.emitOneInput(index),

            .@"and" => try emit.emitTwoInput(index),
            .xor => try emit.emitTwoInput(index),

            .and3 => try emit.emitThreeInput(index),

            .and4 => try emit.emitFourInput(index),

            .lut => return error.UnsupportedNodeType,
        }
    }

    try emit.emitOutputAssignments();
    try emit.emitModuleEnd();

    try emit.verilog_buffered_writer.flush();
}

fn emitModuleBegin(emit: *EmitVerilog) !void {
    const writer = emit.verilog_buffered_writer.writer();

    try writer.print("module {s}(\n", .{emit.module_name});

    if (emit.circuit.inputs.len > 0) {
        try writer.print("  input wire [{}:0] __spfe_input,\n", .{emit.circuit.inputs.len - 1});
    }
    if (emit.circuit.outputs.len > 0) {
        try writer.print("  output wire [{}:0] __spfe_output,\n", .{emit.circuit.outputs.len - 1});
    }

    try writer.writeAll(");\n");
}

fn emitWireDefinitions(emit: *EmitVerilog) !void {
    const writer = emit.verilog_buffered_writer.writer();

    for (emit.circuit.inputs) |input| {
        try writer.print("  wire __wire_{};\n", .{input});
    }

    const circuit_tags = emit.circuit.nodes.items(.tag);
    for (circuit_tags) |tag, index| {
        const output = switch (tag) {
            .zero,
            .one,
            => emit.circuit.nodes.items(.data)[index].constant.output,

            .inv => emit.circuit.nodes.items(.data)[index].one_input.output,

            .@"and",
            .xor,
            => emit.circuit.nodes.items(.data)[index].two_input.output,

            .and3 => emit.circuit.nodes.items(.data)[index].three_input.output,

            .and4 => emit.circuit.nodes.items(.data)[index].four_input.output,

            .lut => return error.UnsupportedNodeType,
        };

        try writer.print("  wire __wire_{};\n", .{output});
    }
}

fn emitInputAssignments(emit: *EmitVerilog) !void {
    const writer = emit.verilog_buffered_writer.writer();

    for (emit.circuit.inputs) |input, i| {
        try writer.print("  assign __wire_{} = __spfe_input[{}];\n", .{ input, i });
    }
}

fn emitOutputAssignments(emit: *EmitVerilog) !void {
    const writer = emit.verilog_buffered_writer.writer();

    for (emit.circuit.outputs) |output, i| {
        try writer.print("  assign __wire_{} = __spfe_output[{}];\n", .{ output, i });
    }
}

fn emitModuleEnd(emit: *EmitVerilog) !void {
    const writer = emit.verilog_buffered_writer.writer();

    try writer.print("endmodule // {s}", .{emit.module_name});
}

fn emitConstant(emit: *EmitVerilog, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const constant = emit.circuit.nodes.items(.data)[node].constant;

    const value = switch (tag) {
        .zero => "0",
        .one => "1",
        else => unreachable,
    };

    try emit.verilog_buffered_writer.writer().print("  assign __wire_{} = {s};\n", .{
        constant.output,
        value,
    });
}

fn emitOneInput(emit: *EmitVerilog, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const one_input = emit.circuit.nodes.items(.data)[node].one_input;

    const un_op = switch (tag) {
        .inv => "~",
        else => unreachable,
    };

    try emit.verilog_buffered_writer.writer().print("  assign __wire_{} = {s}__wire_{};\n", .{
        one_input.output,
        un_op,
        one_input.input,
    });
}

fn emitTwoInput(emit: *EmitVerilog, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const two_input = emit.circuit.nodes.items(.data)[node].two_input;

    const bin_op = switch (tag) {
        .@"and" => "&",
        .xor => "^",
        else => unreachable,
    };

    try emit.verilog_buffered_writer.writer().print("  assign __wire_{} = __wire_{} {s} __wire_{};\n", .{
        two_input.output,
        two_input.input_a,
        bin_op,
        two_input.input_b,
    });
}

fn emitThreeInput(emit: *EmitVerilog, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const three_input = emit.circuit.nodes.items(.data)[node].three_input;

    const bin_op = switch (tag) {
        .and3 => "^",
        else => unreachable,
    };

    try emit.verilog_buffered_writer.writer().print(
        "  assign __wire_{} = __wire_{} {s} __wire_{} {s} __wire_{};\n",
        .{
            three_input.output,
            three_input.input_a,
            bin_op,
            three_input.input_b,
            bin_op,
            three_input.input_c,
        },
    );
}

fn emitFourInput(emit: *EmitVerilog, node: Circuit.Node.Index) !void {
    const tag = emit.circuit.nodes.items(.tag)[node];
    const four_input = emit.circuit.nodes.items(.data)[node].four_input;

    const bin_op = switch (tag) {
        .and4 => "^",
        else => unreachable,
    };

    try emit.verilog_buffered_writer.writer().print(
        "  assign __wire_{} = __wire_{} {s} __wire_{} {s} __wire_{} {s} __wire_{};\n",
        .{
            four_input.output,
            four_input.input_a,
            bin_op,
            four_input.input_b,
            bin_op,
            four_input.input_c,
            bin_op,
            four_input.input_d,
        },
    );
}
