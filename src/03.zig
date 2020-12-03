const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;

// [0] = right
// [1] = down
// [2] = col pos
// [3] = row count 
// [4] = tree count
var slopes = [_][5]usize {
    .{1, 1, 0, 0, 0},
    .{3, 1, 0, 0, 0},
    .{5, 1, 0, 0, 0},
    .{7, 1, 0, 0, 0},
    .{1, 2, 0, 0, 0},
};

pub fn main() !void {
    var it = mem.tokenize(@embedFile("../inputs/day_03"), "\n");

    var our_map = ArrayList([]const u8).init(alloc);
    var max_row: usize = 0;
    var max_col: usize = 0;

    while(it.next()) |line| {
        try our_map.append(line);
        if (max_row == 0) max_col = line.len;
        max_row += 1;
    }

    for (our_map.items) |row, i| {
        for (slopes) |*slope| {
            slope[2] += slope[0];
            slope[3] += slope[1];

            if (slope[3] >= max_row) continue;

            const current_col = slope[2] % max_col;
            if (our_map.items[slope[3]][current_col] == '#') {
                slope[4] += 1;
            }
        }
    }

    var results: usize = 1;
    for (slopes) |slope| results *= slope[4];

    print("\n\nRESULT FOR PART 1: {}\n", .{slopes[1][4]});
    print("\n\nRESULT FOR PART 2: {}\n", .{results});
}
