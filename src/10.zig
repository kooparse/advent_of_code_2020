const std = @import("std");
const panic = std.debug.panic;
const print = std.debug.print;
const fmt = std.fmt;
const ascii = std.ascii;
const math = std.math;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

var orders = ArrayList(i32).init(alloc);

var device_joltage: i32 = math.minInt(i32);
var nb_of_1_diff: i32 = 0;
var nb_of_3_diff: i32 = 0;
var nb_of_uniq_way: i128 = 0;

pub fn main() !void {
    var adapters = HashMap(i32, bool).init(alloc);
    defer adapters.deinit();
    try orders.append(0);
    defer orders.deinit();

    var it = std.mem.tokenize(@embedFile("../inputs/day_10"), "\n");
    while (it.next()) |line| {
        const adapter = try fmt.parseInt(i32, line, 0);
        device_joltage = math.max(device_joltage, adapter);
        try adapters.put(adapter, false);
    }

    device_joltage += 3;

    _ = find_chain(&adapters, 0);

    var pairs = HashMap(i32, i128).init(alloc);
    defer pairs.deinit();

    for (orders.items) |n, i| {
        const diff = n - 3;
        var acc: i128 = 0;

        if (i == 0 or i == 1) {
            try pairs.put(n, 1);
            continue;
        }

        if (i != 2) {
            var key = orders.items[i - 3];
            if (key >= diff) {
                if (pairs.get(key)) |v| {
                    acc += v;
                }
            }
        }

        {
            var key = orders.items[i - 2];
            if (key >= diff) {
                if (pairs.get(key)) |v| {
                    acc += v;
                }
            }
        }

        {
            var key = orders.items[i - 1];
            if (key >= diff) {
                if (pairs.get(key)) |v| {
                    acc += v;
                }
            }
        }

        try pairs.put(n, acc);

        if (i == orders.items.len - 1) {
            nb_of_uniq_way = acc;
        }
    }

    print("ANSWER PART 1: {}\n", .{nb_of_1_diff * nb_of_3_diff});
    print("ANSWER PART 2: {}\n", .{nb_of_uniq_way});
}

fn find_chain(adapters: *HashMap(i32, bool), current: i32) bool {
    var iter = adapters.iterator();

    if (current >= device_joltage - 3) {
        nb_of_3_diff += 1;
        return true;
    }

    var min_key: ?i32 = null;
    while (iter.next()) |n| {
        if (n.key > current and n.key <= current + 3 and !n.value) {
            if (min_key) |min| {
                min_key = math.min(min, n.key);
            } else {
                min_key = n.key;
            }
        }
    }

    if (min_key == null) {
        return false;
    }

    if (adapters.getEntry(min_key.?)) |entry| {
        if (entry.*.key == current + 1) {
            nb_of_1_diff += 1;
        }

        if (entry.*.key == current + 3) {
            nb_of_3_diff += 1;
        }

        orders.append(entry.*.key) catch unreachable;

        entry.*.value = true;
    }

    return find_chain(adapters, min_key.?);
}
