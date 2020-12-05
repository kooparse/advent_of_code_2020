const std = @import("std");
const panic = std.debug.panic;
const print = std.debug.print;
const alloc = std.heap.page_allocator;
const HashMap = std.AutoHashMap;

pub fn main() !void {
    var it = std.mem.tokenize(@embedFile("../inputs/day_05"), "\n");

    var ids = HashMap(i32, bool).init(alloc);
    var max_seat_id: i32 = 0;

    while (it.next()) |line| {
        var min_r: i32 = 0;
        var max_r: i32 = 127;

        var min_c: i32 = 0;
        var max_c: i32 = 7;

        for (line[0..7]) |c, i| {
            var halt = min_r + @divTrunc(max_r - min_r, 2);

            switch (c) {
                'F' => {
                    max_r = halt;
                },
                'B' => {
                    min_r = halt + 1;
                },
                else => {
                    panic("Boarding pass not valid.\n", .{});
                },
            }
        }

        for (line[7..]) |c, i| {
            var half = min_c + @divTrunc(max_c - min_c, 2);

            switch (c) {
                'R' => {
                    min_c = half + 1;
                },
                'L' => {
                    max_c = half;
                },
                else => {
                    panic("Boarding pass not valid.\n", .{});
                },
            }
        }

        const seat_id = min_r * 8 + min_c;

        if (seat_id > max_seat_id) {
            max_seat_id = seat_id;
        }

        try ids.put(seat_id, true);
    }

    var i: i32 = max_seat_id;
    const my_seat_id = while (i > 0) : (i -= 1) {
        if (ids.get(i) == null) {
            break i;
        }
    } else panic("You don't have any seat id.\n", .{});

    print("ANSWER PART 1: {}\n", .{max_seat_id});
    print("ANSWER PART 2: {}\n", .{my_seat_id});
}
