const std = @import("std");
const panic = std.debug.panic;
const print = std.debug.print;
const ascii = std.ascii;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

pub fn main() !void {
    var total_any_count: u32 = 0;
    var total_every_count: u32 = 0;

    var it = std.mem.split(@embedFile("../inputs/day_06"), "\n\n");

    while (it.next()) |group| {
        var person_count: u32 = 0;
        var f = std.mem.tokenize(group, "\n");

        var reminder = HashMap(u8, i32).init(alloc);
        defer reminder.deinit();

        while (f.next()) |answer| {
            person_count += 1;

            for (answer) |c| {
                const result = try reminder.getOrPut(c);

                if (!result.found_existing) {
                    result.entry.*.value = 1;
                    continue;
                }

                result.entry.*.value += 1;
            }
        }

        const every_count = blk: {
            var count: u32 = 0;
            var iter = reminder.iterator();
            while (iter.next()) |entry| {
                if (entry.value == person_count) {
                    count += 1;
                }
            }

            break :blk count;
        };

        total_any_count += reminder.count();
        total_every_count += every_count;
    }

    print("ANSWER PART 1: {}\n", .{total_any_count});
    print("ANSWER PART 2: {}\n", .{total_every_count});
}
