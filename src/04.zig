const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;
const eql = std.ascii.eqlIgnoreCase;
const ascii = std.ascii;

pub fn main() !void {
    const file = @embedFile("../inputs/day_04");
    var passports = ArrayList([]const u8).init(alloc);

    var valid_passport_count: i32 = 0;
    var valid_passport_count_2: i32 = 0;

    const required = "byr iyr eyr hgt hcl ecl pid";

    {
        var cursor: usize = 0;
        for (file) |c, i| {
            if (c == '\n' and file[i + 1] == '\n') {
                try passports.append(file[cursor..i]);
                cursor = i;
            }
        }
    }

    for (passports.items) |passport| {
        var fields_count: u32 = 0;
        var is_valid = true;

        for (passport) |fields, i| {
            if (fields == ':') {
                const field = passport[i - 3 .. i];
                const value = blk: {
                    const slice = passport[i + 1 ..];
                    var len: usize = slice.len;

                    for (slice) |c, l| {
                        if (c == ' ' or c == '\n') {
                            len = l;
                            break;
                        }
                    }

                    break :blk slice[0..len];
                };

                if (mem.indexOf(u8, required, field) != null) {
                    fields_count += 1;
                }

                if (is_valid and eql(field, "byr")) {
                    const year = try fmt.parseInt(i32, value, 0);
                    is_valid = year >= 1920 and year <= 2002;
                }

                if (is_valid and eql(field, "iyr")) {
                    const year = try fmt.parseInt(i32, value, 0);
                    is_valid = year >= 2010 and year <= 2020;
                }

                if (is_valid and eql(field, "eyr")) {
                    const year = try fmt.parseInt(i32, value, 0);
                    is_valid = year >= 2020 and year <= 2030;
                }

                if (is_valid and eql(field, "hgt")) {
                    is_valid = blk: {
                        const size_i = value.len - 2;
                        if (value[value.len - 2] == 'c') {
                            const size = try fmt.parseInt(i32, value[0..size_i], 0);
                            break :blk size >= 150 and size <= 193;
                        }

                        if (value[value.len - 2] == 'i') {
                            const size = try fmt.parseInt(i32, value[0..size_i], 0);
                            break :blk size >= 59 and size <= 76;
                        }

                        break :blk false;
                    };
                }

                if (is_valid and eql(field, "hcl")) {
                    if (value.len != 7) {
                        is_valid = false;
                        continue;
                    }

                    for (value) |c, idx| {
                        is_valid = switch (c) {
                            '#', '0'...'9', 'a'...'f' => true,
                            else => false,
                        };
                    }
                }

                if (is_valid and eql(field, "ecl")) {
                    const v = value;
                    is_valid = eql(v, "amb") or eql(v, "blu") or eql(v, "brn") or eql(v, "gry") or eql(v, "grn") or eql(v, "hzl") or eql(v, "oth");
                }

                if (is_valid and eql(field, "pid")) {
                    if (value.len != 9) {
                        is_valid = false;
                        continue;
                    }

                    for (value) |c| {
                        is_valid = switch (c) {
                            '0'...'9' => true,
                            else => false,
                        };
                    }
                }
            }
        }

        if (fields_count == 7) {
            valid_passport_count += 1;

            if (is_valid) {
                valid_passport_count_2 += 1;
            }
        }
    }

    print("ANSWER PART 1: {}\n", .{valid_passport_count});
    print("ANSWER PART 2: {}\n", .{valid_passport_count_2});
}
