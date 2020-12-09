const std = @import("std");
const panic = std.debug.panic;
const print = std.debug.print;
const fmt = std.fmt;
const ascii = std.ascii;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

const PREAMBLE_SIZE: usize = 25;

pub fn main() !void {
    var numbers = ArrayList(i64).init(alloc);

    var it = std.mem.tokenize(@embedFile("../inputs/day_09"), "\n");
    while (it.next()) |line| {
        const number = try fmt.parseInt(i64, line, 0);
        try numbers.append(number);
    }

    var bad_number: i64 = 0;
    var weakness: ?i64 = null;

    for (numbers.items) |current_number, i| {
        var pairs = HashMap(i64, bool).init(alloc);
        defer pairs.deinit();

        if (i < PREAMBLE_SIZE) {
            continue;
        }

        var slice = numbers.items[i - PREAMBLE_SIZE .. i];
        try fill_data(&pairs, slice);

        if (pairs.get(current_number) == null) {
            bad_number = current_number;
            weakness = find_weakness(numbers.items[0..i], bad_number);
            break;
        }
    }

    print("ANSWER PART 1: {}\n", .{bad_number});
    print("ANSWER PART 2: {}\n", .{weakness.?});
}

fn fill_data(pairs: *HashMap(i64, bool), data: []const i64) !void {
    for (data) |a, i| {
        for (data) |b, j| {
            if (i == j) continue;
            try pairs.put(a + b, true);
        }
    }
}

fn find_weakness(data: []const i64, number: i64) ?i64 {
    var acc: i64 = 0;
    var begin: ?usize = null;
    var end: ?usize = null;

    for (data) |starter, i| {
        if ((begin != null and end != null) or starter >= number) break;

        acc = 0;
        begin = i;

        for (data[i..]) |current, j| {
            acc += current;

            if (acc == number) {
                end = i + j + 1;
                break;
            }
        }
    }

    if (begin != null and end != null) {
        var min: i64 = std.math.maxInt(i64);
        var max: i64 = std.math.minInt(i64);

        for (data[begin.?..end.?]) |n| {
            min = std.math.min(min, n);
            max = std.math.max(max, n);
        }

        return (max + min);
    }

    return null;
}
