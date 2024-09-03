const std = @import("std");

const Circuit = @import("Circuit.zig");

const BristolParser = @This();

gpa: std.mem.Allocator,

circuit_buffered_reader: std.io.BufferedReader(4096, std.fs.File.Reader),

circuit_nodes: std.MultiArrayList(Circuit.Node) = .{},
circuit_luts: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_inputs: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_outputs: std.ArrayListUnmanaged(Circuit.Node.Index) = .{},
circuit_max_wire_number: Circuit.Node.Index = 0,

pub fn parseBristol(
    gpa: std.mem.Allocator,
    working_dir: std.fs.Dir,
    bristol_file_path: []const u8,
) !Circuit {
    var bristol_file = try working_dir.openFile(bristol_file_path, .{});
    defer bristol_file.close();

    var parser = BristolParser{
        .gpa = gpa,
        .circuit_buffered_reader = std.io.bufferedReader(bristol_file.reader()),
    };
    try parser.parse();

    return Circuit{
        .nodes = parser.circuit_nodes.toOwnedSlice(),
        .luts = parser.circuit_luts.toOwnedSlice(gpa),
        .inputs = parser.circuit_inputs.toOwnedSlice(gpa),
        .outputs = parser.circuit_outputs.toOwnedSlice(gpa),
        .lut_tables = &.{},
        .max_wire_number = parser.circuit_max_wire_number,
    };
}

fn addNode(parser: *BristolParser, node: Circuit.Node) !void {
    const gpa = parser.gpa;
    try parser.circuit_nodes.ensureUnusedCapacity(gpa, 1);
    parser.circuit_nodes.appendAssumeCapacity(node);
}

fn parse(
    parser: *BristolParser,
) !void {
    const circuit_reader = parser.circuit_buffered_reader.reader();

    var buf: [4096]u8 = undefined;

    // First line
    // <number of gates> <number of wires>
    const num_wires = blk: {
        const line = (try circuit_reader.readUntilDelimiterOrEof(&buf, '\n')) orelse return error.ExpectedData;
        var iter = std.mem.tokenize(u8, line, " ");
        _ = iter.next() orelse return error.ExpectedData;

        const num_wires_raw = iter.next() orelse return error.ExpectedData;
        break :blk try std.fmt.parseInt(Circuit.Node.Index, num_wires_raw, 10);
    };

    // Second line
    // <number of input wires parent a> <number of input wires parent a> <number of output wires>
    // OR
    // <number of input wires> <number of output wires>
    {
        const line = (try circuit_reader.readUntilDelimiterOrEof(&buf, '\n')) orelse return error.ExpectedData;
        var iter = std.mem.tokenize(u8, line, " ");

        const field1_raw = iter.next() orelse return error.ExpectedData;
        const field2_raw = iter.next() orelse return error.ExpectedData;

        var num_input_wires: Circuit.Node.Index = undefined;
        var num_output_wires: Circuit.Node.Index = undefined;

        if (iter.next()) |field3_raw| {
            const num_input_wires_a_raw = field1_raw;
            const num_input_wires_b_raw = field2_raw;
            const num_output_wires_raw = field3_raw;

            const num_input_wires_a = try std.fmt.parseInt(Circuit.Node.Index, num_input_wires_a_raw, 10);
            const num_input_wires_b = try std.fmt.parseInt(Circuit.Node.Index, num_input_wires_b_raw, 10);
            num_input_wires = num_input_wires_a + num_input_wires_b;
            num_output_wires = try std.fmt.parseInt(Circuit.Node.Index, num_output_wires_raw, 10);
        } else {
            const num_input_wires_raw = field1_raw;
            const num_output_wires_raw = field2_raw;

            num_input_wires = try std.fmt.parseInt(Circuit.Node.Index, num_input_wires_raw, 10);
            num_output_wires = try std.fmt.parseInt(Circuit.Node.Index, num_output_wires_raw, 10);
        }

        {
            try parser.circuit_inputs.ensureUnusedCapacity(parser.gpa, num_input_wires);
            var i: Circuit.Node.Index = 0;
            while (i < num_input_wires) : (i += 1) {
                parser.circuit_inputs.appendAssumeCapacity(i);
            }
        }

        {
            try parser.circuit_outputs.ensureUnusedCapacity(parser.gpa, num_output_wires);
            var i: Circuit.Node.Index = num_wires - num_output_wires;
            while (i < num_wires) : (i += 1) {
                parser.circuit_outputs.appendAssumeCapacity(i);
            }
        }
    }

    // Nodes
    // <number of inputs> <number of outputs> <input>... <output>... <type>
    while (try circuit_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) continue;

        // Actually create the circuit node
        var iter = std.mem.tokenize(u8, line, " ");

        const num_inputs_raw = iter.next() orelse return error.ExpectedData;
        const num_outputs_raw = iter.next() orelse return error.ExpectedData;

        const num_inputs = try std.fmt.parseInt(Circuit.Node.Index, num_inputs_raw, 10);
        const num_outputs = try std.fmt.parseInt(Circuit.Node.Index, num_outputs_raw, 10);

        var inputs: [4]Circuit.Node.Index = undefined;
        var outputs: [4]Circuit.Node.Index = undefined;

        {
            var i: Circuit.Node.Index = 0;
            while (i < num_inputs) : (i += 1) {
                const wire_number_raw = iter.next() orelse return error.ExpectedData;
                const wire_number = try std.fmt.parseInt(Circuit.Node.Index, wire_number_raw, 10);
                parser.circuit_max_wire_number = @max(parser.circuit_max_wire_number, wire_number);
                inputs[i] = wire_number;
            }
        }

        {
            var i: Circuit.Node.Index = 0;
            while (i < num_outputs) : (i += 1) {
                const wire_number_raw = iter.next() orelse return error.ExpectedData;
                const wire_number = try std.fmt.parseInt(Circuit.Node.Index, wire_number_raw, 10);
                parser.circuit_max_wire_number = @max(parser.circuit_max_wire_number, wire_number);
                outputs[i] = wire_number;
            }
        }

        const line_type = iter.next() orelse return error.ExpectedType;
        if (std.mem.eql(u8, "XOR", line_type)) {
            if (num_inputs != 2) return error.InvalidNumberOfInputs;
            if (num_outputs != 1) return error.InvalidNumberOfOutputs;

            try parser.addNode(.{
                .tag = .xor,
                .data = .{ .two_input = .{
                    .input_a = inputs[0],
                    .input_b = inputs[1],
                    .output = outputs[0],
                } },
            });
        } else if (std.mem.eql(u8, "AND", line_type)) {
            if (num_inputs != 2) return error.InvalidNumberOfInputs;
            if (num_outputs != 1) return error.InvalidNumberOfOutputs;

            try parser.addNode(.{
                .tag = .@"and",
                .data = .{ .two_input = .{
                    .input_a = inputs[0],
                    .input_b = inputs[1],
                    .output = outputs[0],
                } },
            });
        } else if (std.mem.eql(u8, "AND3", line_type)) {
            if (num_inputs != 3) return error.InvalidNumberOfInputs;
            if (num_outputs != 1) return error.InvalidNumberOfOutputs;

            try parser.addNode(.{
                .tag = .and3,
                .data = .{ .three_input = .{
                    .input_a = inputs[0],
                    .input_b = inputs[1],
                    .input_c = inputs[2],
                    .output = outputs[0],
                } },
            });
        } else if (std.mem.eql(u8, "AND4", line_type)) {
            if (num_inputs != 4) return error.InvalidNumberOfInputs;
            if (num_outputs != 1) return error.InvalidNumberOfOutputs;

            try parser.addNode(.{
                .tag = .and4,
                .data = .{ .four_input = .{
                    .input_a = inputs[0],
                    .input_b = inputs[1],
                    .input_c = inputs[2],
                    .input_d = inputs[3],
                    .output = outputs[0],
                } },
            });
        } else if (std.mem.eql(u8, "INV", line_type)) {
            if (num_inputs != 1) return error.InvalidNumberOfInputs;
            if (num_outputs != 1) return error.InvalidNumberOfOutputs;

            try parser.addNode(.{
                .tag = .inv,
                .data = .{ .one_input = .{
                    .input = inputs[0],
                    .output = outputs[0],
                } },
            });
        } else {
            return error.UnsupportedType;
        }

        if (iter.next() != null) return error.UnexpectedExtraData;
    }
}
