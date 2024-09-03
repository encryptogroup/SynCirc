const std = @import("std");
const Allocator = std.mem.Allocator;

const Circuit = @import("Circuit.zig");

const DepthAnalysis = @This();

circuit: Circuit,
fg: ForwardGraph,

node_depth: []Depth,
output_depth: []Depth,

pub const Depth = u32;

pub const Result = struct {
    gpa: Allocator,

    node_depth: []const Depth,
    output_depth: []const Depth,

    pub fn deinit(result: Result) void {
        result.gpa.free(result.node_depth);
        result.gpa.free(result.output_depth);
    }
};

pub fn analyzeDepth(
    gpa: Allocator,
    circuit: Circuit,
) !Result {
    var node_depth = try gpa.alloc(Depth, circuit.nodes.len);
    errdefer gpa.free(node_depth);
    std.mem.set(Depth, node_depth, 0);

    var output_depth = try gpa.alloc(Depth, circuit.outputs.len);
    errdefer gpa.free(output_depth);
    std.mem.set(Depth, output_depth, 0);

    var fg = try buildForwardGraph(gpa, circuit);
    defer fg.deinit(gpa);

    var depth_analysis: DepthAnalysis = .{
        .circuit = circuit,
        .fg = fg,
        .node_depth = node_depth,
        .output_depth = output_depth,
    };

    for (circuit.inputs) |_, i| {
        depth_analysis.visitInput(i);
    }

    // correct depth
    //
    // nodes with depth 0 (never visited) will stay at depth 0
    for (node_depth) |*x| x.* -|= 1;
    for (output_depth) |*x| x.* -|= 1;

    return .{
        .gpa = gpa,

        .node_depth = node_depth,
        .output_depth = output_depth,
    };
}

fn visitSink(
    da: DepthAnalysis,
    sink: Circuit.Node.Index,
    depth: Depth,
) void {
    const node_len = da.circuit.nodes.items(.tag).len;

    if (sink < node_len) {
        da.visitNode(sink, depth);
    } else {
        da.visitOutput(sink - node_len, depth);
    }
}

fn visitInput(
    da: DepthAnalysis,
    input_index: Circuit.Node.Index,
) void {
    // purposefully set to 1 as 1 symbolizes the smallest depth and 0
    // symbolizes "not visited"
    const depth = 1;

    for (da.fg.input_out_edges[input_index].items) |sink| {
        da.visitSink(sink, depth);
    }
}

fn visitNode(
    da: DepthAnalysis,
    node_index: Circuit.Node.Index,
    depth: Depth,
) void {
    const circuit_tags = da.circuit.nodes.items(.tag);

    if (depth > da.node_depth[node_index]) {
        da.node_depth[node_index] = depth;

        const output_depth = switch (circuit_tags[node_index]) {
            .@"and", .and3, .and4, .lut => depth + 1,
            else => depth,
        };

        for (da.fg.node_out_edges[node_index].items) |sink| {
            da.visitSink(sink, output_depth);
        }
    }
}

fn visitOutput(
    da: DepthAnalysis,
    output_index: Circuit.Node.Index,
    depth: Depth,
) void {
    da.output_depth[output_index] = std.math.max(da.output_depth[output_index], depth);
}

/// Contains edges from outputs of inputs/nodes to inputs of
/// nodes/outputs
const ForwardGraph = struct {
    /// i in 0..node_len -> wire sink is node i
    /// i in node_len..node_len + output_len -> wire sink is output i - node_len
    input_out_edges: []std.ArrayListUnmanaged(Circuit.Node.Index),
    /// see `input_out_edges`
    node_out_edges: []std.ArrayListUnmanaged(Circuit.Node.Index),

    fn deinit(fg: *ForwardGraph, gpa: Allocator) void {
        for (fg.input_out_edges) |*list| list.deinit(gpa);
        for (fg.node_out_edges) |*list| list.deinit(gpa);

        gpa.free(fg.input_out_edges);
        gpa.free(fg.node_out_edges);
    }
};

fn connect(
    gpa: Allocator,
    source_wire: Circuit.Node.Index,
    sink_node: Circuit.Node.Index,
    input_len: usize,
    input_out_edges: []std.ArrayListUnmanaged(Circuit.Node.Index),
    node_out_edges: []std.ArrayListUnmanaged(Circuit.Node.Index),
) !void {
    if (source_wire < input_len) {
        try input_out_edges[source_wire].append(gpa, sink_node);
    } else {
        try node_out_edges[source_wire - input_len].append(gpa, sink_node);
    }
}

fn buildForwardGraph(gpa: Allocator, circuit: Circuit) !ForwardGraph {
    const circuit_tags = circuit.nodes.items(.tag);
    const circuit_data = circuit.nodes.items(.data);
    const node_len = circuit_tags.len;
    const input_len = circuit.inputs.len;

    // i in 0..input_len -> wire source is input wire i
    // i in input_len..input_len + node_len -> wire source is node i - input_len
    var wire_source_map = try gpa.alloc(Circuit.Node.Index, circuit.max_wire_number + 1);
    defer gpa.free(wire_source_map);

    var input_out_edges = try gpa.alloc(std.ArrayListUnmanaged(Circuit.Node.Index), circuit.inputs.len);
    for (input_out_edges) |*x| x.* = .{};

    var node_out_edges = try gpa.alloc(std.ArrayListUnmanaged(Circuit.Node.Index), circuit.nodes.len);
    for (node_out_edges) |*x| x.* = .{};

    // stage 1: build wire_source_map
    for (circuit.inputs) |input_wire, i| {
        wire_source_map[input_wire] = i;
    }

    for (circuit_tags) |tag, index| {
        switch (tag) {
            .zero, .one => {
                const constant = circuit_data[index].constant;
                wire_source_map[constant.output] = input_len + index;
            },

            .inv => {
                const one_input = circuit_data[index].one_input;
                wire_source_map[one_input.output] = input_len + index;
            },

            .@"and", .xor => {
                const two_input = circuit_data[index].two_input;
                wire_source_map[two_input.output] = input_len + index;
            },

            .and3 => {
                const three_input = circuit_data[index].three_input;
                wire_source_map[three_input.output] = input_len + index;
            },

            .and4 => {
                const four_input = circuit_data[index].four_input;
                wire_source_map[four_input.output] = input_len + index;
            },

            .lut => {
                const lut = circuit_data[index].lut;
                wire_source_map[lut.output] = input_len + index;
            },
        }
    }

    // stage 2: build forward graph
    for (circuit_tags) |tag, node_index| {
        switch (tag) {
            .zero, .one => continue,

            .inv => {
                const one_input = circuit_data[node_index].one_input;

                for ([_]Circuit.Node.Index{
                    one_input.input,
                }) |source| {
                    try connect(
                        gpa,
                        wire_source_map[source],
                        node_index,
                        input_len,
                        input_out_edges,
                        node_out_edges,
                    );
                }
            },

            .@"and", .xor => {
                const two_input = circuit_data[node_index].two_input;

                for ([_]Circuit.Node.Index{
                    two_input.input_a,
                    two_input.input_b,
                }) |source| {
                    try connect(
                        gpa,
                        wire_source_map[source],
                        node_index,
                        input_len,
                        input_out_edges,
                        node_out_edges,
                    );
                }
            },

            .and3 => {
                const three_input = circuit_data[node_index].three_input;

                for ([_]Circuit.Node.Index{
                    three_input.input_a,
                    three_input.input_b,
                    three_input.input_c,
                }) |source| {
                    try connect(
                        gpa,
                        wire_source_map[source],
                        node_index,
                        input_len,
                        input_out_edges,
                        node_out_edges,
                    );
                }
            },

            .and4 => {
                const four_input = circuit_data[node_index].four_input;

                for ([_]Circuit.Node.Index{
                    four_input.input_a,
                    four_input.input_b,
                    four_input.input_c,
                    four_input.input_d,
                }) |source| {
                    try connect(
                        gpa,
                        wire_source_map[source],
                        node_index,
                        input_len,
                        input_out_edges,
                        node_out_edges,
                    );
                }
            },

            .lut => {
                const lut = circuit_data[node_index].lut;
                const input_wires = circuit.luts[lut.offset..][0..lut.arity];

                for (input_wires) |source| {
                    try connect(
                        gpa,
                        wire_source_map[source],
                        node_index,
                        input_len,
                        input_out_edges,
                        node_out_edges,
                    );
                }
            },
        }
    }

    for (circuit.outputs) |output_wire, i| {
        const source = wire_source_map[output_wire];
        if (source < input_len) {
            try input_out_edges[source].append(gpa, node_len + i);
        } else {
            try node_out_edges[source - input_len].append(gpa, node_len + i);
        }
    }

    return .{
        .input_out_edges = input_out_edges,
        .node_out_edges = node_out_edges,
    };
}
