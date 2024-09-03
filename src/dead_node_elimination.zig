const std = @import("std");

const Circuit = @import("Circuit.zig");

const Queue = std.TailQueue(Circuit.Node.Index);

fn append(allocator: std.mem.Allocator, queue: *Queue, index: Circuit.Node.Index) !void {
    const node = try allocator.create(Queue.Node);
    node.* = .{ .data = index };
    queue.append(node);
}

pub fn calculateDeadNodes(
    allocator: std.mem.Allocator,
    circuit: Circuit,
) !std.DynamicBitSetUnmanaged {
    const circuit_tags = circuit.nodes.items(.tag);
    const circuit_data = circuit.nodes.items(.data);

    var dead_nodes = try std.DynamicBitSetUnmanaged.initFull(allocator, circuit.nodes.len);

    // Map from wire number to node outputting that wire number.
    //
    // Node number 0 represents an input, node numbers n > 0 represent
    // the node n - 1.
    var output_map = std.AutoHashMap(Circuit.Node.Index, Circuit.Node.Index).init(allocator);
    defer output_map.deinit();

    for (circuit.inputs) |index| {
        try output_map.putNoClobber(index, 0);
    }
    nodes: for (circuit_tags) |tag, index| {
        const output = switch (tag) {
            .zero, .one => circuit_data[index].constant.output,

            .inv => circuit_data[index].one_input.output,

            .@"and", .xor, .y => circuit_data[index].two_input.output,

            .x => {
                const two_input_two_output = circuit_data[index].two_input_two_output;
                try output_map.putNoClobber(two_input_two_output.output_a, index + 1);
                try output_map.putNoClobber(two_input_two_output.output_b, index + 1);
                continue :nodes;
            },

            .u => circuit_data[index].lut.output,

            .lut => circuit_data[index].lut.output,
        };

        try output_map.putNoClobber(output, index + 1);
    }

    var queue = Queue{};

    // Breadth first search
    for (circuit.outputs) |output| try append(allocator, &queue, output);
    while (queue.popFirst()) |queue_node| {
        const wire = queue_node.data;
        allocator.destroy(queue_node);

        const raw_node = output_map.get(wire).?;
        if (raw_node == 0) continue; // circuit input
        const node = raw_node - 1;

        if (!dead_nodes.isSet(node)) continue;
        dead_nodes.unset(node);

        switch (circuit.nodes.items(.tag)[node]) {
            .zero, .one => continue,

            .inv => {
                const one_input = circuit_data[node].one_input;
                try append(allocator, &queue, one_input.input);
            },

            .@"and", .xor, .y => {
                const two_input = circuit_data[node].two_input;
                try append(allocator, &queue, two_input.input_a);
                try append(allocator, &queue, two_input.input_b);
            },

            .x => {
                const two_input_two_output = circuit_data[node].two_input_two_output;
                try append(allocator, &queue, two_input_two_output.input_a);
                try append(allocator, &queue, two_input_two_output.input_b);
            },

            .u => {
                const lut = circuit_data[node].lut;
                for (circuit.luts[lut.offset..][0..lut.arity]) |input| {
                    try append(allocator, &queue, input);
                }
            },
        }
    }

    return dead_nodes;
}
