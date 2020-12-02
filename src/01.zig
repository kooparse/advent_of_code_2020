const std = @import("std");
const mem = std.mem;
const print = std.debug.print;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var inputs = ArrayList(i32).init(alloc);

    var it = mem.tokenize(@embedFile("../inputs/day_01"), "\n");
    while (it.next()) |str| {
        const integer = try std.fmt.parseInt(i32, str, 0);
        try inputs.append(integer);
    }

    var val_1: i32 = undefined;
    var val_2: i32 = undefined;
    var val_3: i32 = undefined;

    for (inputs.items) |a| {
        for (inputs.items) |b| {
            if ((a + b) == 2020) {
                val_1 = a;
                val_2 = b;
            }
        }
    }

    print("ANSWER PART_1: {}\n", .{ val_1 * val_2});

    for (inputs.items) |a| {
        for (inputs.items) |b| {
            for (inputs.items) |c| {
                if ((a + b + c) == 2020) {
                    val_1 = a;
                    val_2 = b;
                    val_3 = c;
                }
            }
        }
    }

    print("ANSWER PART_2: {}\n", .{ val_1 * val_2 * val_3});
}

