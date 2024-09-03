const std = @import("std");

const Torder = @This();

modules: std.StringHashMap(CellList),

const CellList = []const []const u8;

const expected_debug_line = "Executing TORDER pass (print cells in topological order).";
const module_prefix = "module ";
const cell_prefix = "  cell ";

pub fn parse(
    allocator: std.mem.Allocator,
    working_dir: std.fs.Dir,
    file_path: []const u8,
) !Torder {
    var torder_file = try working_dir.openFile(file_path, .{});
    defer torder_file.close();

    var buffered_reader = std.io.bufferedReader(torder_file.reader());
    const reader = buffered_reader.reader();

    var buf: [4096]u8 = undefined;

    // First line should be empty
    const empty_line = (try reader.readUntilDelimiterOrEof(&buf, '\n')).?;
    if (empty_line.len > 0) return error.TorderParseError;

    // Second line should always contain the same message
    const debug_line = (try reader.readUntilDelimiterOrEof(&buf, '\n')).?;
    if (!std.mem.endsWith(u8, debug_line, expected_debug_line)) return error.TorderParseError;

    // Third line contains the first module name
    var current_module_name = blk: {
        const line = (try reader.readUntilDelimiterOrEof(&buf, '\n')).?;
        if (!std.mem.startsWith(u8, line, module_prefix)) return error.TorderParseError;
        break :blk try allocator.dupe(u8, line[module_prefix.len..]);
    };

    var modules = std.StringHashMap(CellList).init(allocator);
    var current_cell_list = std.ArrayList([]const u8).init(allocator);

    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (std.mem.startsWith(u8, line, module_prefix)) {
            // Finish current module
            try modules.put(current_module_name, current_cell_list.toOwnedSlice());

            const module_name = try allocator.dupe(u8, line[module_prefix.len..]);
            current_module_name = module_name;
        } else if (std.mem.startsWith(u8, line, cell_prefix)) {
            const cell_name = try allocator.dupe(u8, line[cell_prefix.len..]);
            try current_cell_list.append(cell_name);
        } else return error.TorderParseError;
    }

    // Finish current module
    try modules.put(current_module_name, current_cell_list.toOwnedSlice());

    return Torder{
        .modules = modules,
    };
}
