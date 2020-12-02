const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;

pub fn main() !void {
    var it = mem.tokenize(@embedFile("../inputs/day_02"), "\n");

    var valid_count_part_1: i32 = 0;
    var valid_count_part_2: i32 = 0;

    while (it.next()) |line| {
        var min: usize= 0;
        var max: usize= 0;

        var current_count: i32 = 0;
        var char_to_match: u8 = undefined;
        var password: []const u8 = undefined;

        var cursor: usize = 0;

        for (line) |c, i| {
            if (c == '-') {
                min = try fmt.parseInt(usize, line[0..i], 0);
                cursor = i;
                continue;
            }

            if (c == ':') {
                max = try fmt.parseInt(usize, line[cursor+1..i - 2], 0);
                char_to_match = line[i - 1];
                password = line[i..];
                break;
            }
        }

        for (password) |c| {
            if (c == char_to_match) {
                current_count += 1;
            }
        }

        if (current_count >= min and current_count <= max) {
            valid_count_part_1 += 1;
        }

        const part_2_min = password[min+1] == char_to_match;
        const part_2_max = password[max+1] == char_to_match;

        if ((part_2_min and !part_2_max) or (!part_2_min and part_2_max)) {
            valid_count_part_2 += 1;
        }
    }

    print("ANSWER PART 1: {}\n", .{valid_count_part_1});
    print("ANSWER PART 2: {}\n", .{valid_count_part_2});
}
