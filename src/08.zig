const std = @import("std");
const panic = std.debug.panic;
const print = std.debug.print;
const fmt = std.fmt;
const ascii = std.ascii;
const alloc = std.heap.page_allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

const Error = error{InfiteLoop};

const Kind = enum {
    Jmp,
    Acc,
    Nop,

    pub fn from_slice(slice: []const u8) @This() {
        if (ascii.eqlIgnoreCase(slice, "jmp")) {
            return .Jmp;
        } else if (ascii.eqlIgnoreCase(slice, "acc")) {
            return .Acc;
        } else if (ascii.eqlIgnoreCase(slice, "nop")) {
            return .Nop;
        }

        panic("Operation unvalid.\n", .{});
    }
};

const Operation = struct {
    kind: Kind,
    value: i32,
    done: bool = false,

    const Self = @This();

    pub fn try_run(self: *Self, list: *ArrayList(Self), idx: i32, acc: *i32) Error!void {
        if (self.done) {
            return Error.InfiteLoop;
        }

        var next_op_index = idx + 1;

        switch (self.kind) {
            .Acc => {
                acc.* += self.value;
            },
            .Jmp => {
                next_op_index = idx + self.value;
            },
            else => {},
        }

        self.done = true;

        if (next_op_index >= list.items.len - 1) {
            return;
        }

        var next_op = &list.items[@intCast(usize, next_op_index)];
        try next_op.try_run(list, next_op_index, acc);

        return;
    }

    pub fn fix(self: *Self, list: *ArrayList(Self), idx: i32) void {
        if (idx >= list.items.len - 1) {
            return;
        }

        if (self.kind == .Jmp or self.kind == .Nop) {
            var try_list = ArrayList(Operation).init(alloc);
            defer try_list.deinit();
            try_list.appendSlice(list.items) catch unreachable;

            var current_index = @intCast(usize, idx);
            var node = &try_list.items[current_index];
            // swap.
            if (node.kind == .Jmp) node.kind = .Nop else node.kind = .Jmp;

            var acc: i32 = 0;
            var fixed_found = true;
            try_list.items[0].try_run(&try_list, 0, &acc) catch {
                fixed_found = false;
            };

            if (fixed_found) {
                if (self.kind == .Jmp) self.kind = .Nop else self.kind = .Jmp;
                return;
            }
        }

        var next_op_index = idx + 1;

        switch (self.kind) {
            .Jmp => {
                next_op_index = idx + self.value;
            },
            else => {},
        }

        var n = &list.items[@intCast(usize, next_op_index)];
        n.fix(list, next_op_index);
    }
};

pub fn main() !void {
    var bootcode = ArrayList(Operation).init(alloc);
    defer bootcode.deinit();

    var it = std.mem.tokenize(@embedFile("../inputs/day_08"), "\n");
    while (it.next()) |line| {
        for (line) |c, i| {
            if (ascii.isSpace(c)) {
                var kind = Kind.from_slice(line[0..i]);
                var value = try fmt.parseInt(i32, line[i + 1 ..], 0);
                try bootcode.append(.{ .kind = kind, .value = value });
            }
        }
    }

    var bootcode_copy = ArrayList(Operation).init(alloc);
    try bootcode_copy.appendSlice(bootcode.items);
    defer bootcode_copy.deinit();

    var acc: i32 = 0;
    bootcode.items[0].try_run(&bootcode, 0, &acc) catch {
        print("ANSWER PART 1: {}\n", .{acc});
    };


    acc = 0;
    bootcode_copy.items[0].fix(&bootcode_copy, 0);
    bootcode_copy.items[0].try_run(&bootcode_copy, 0, &acc) catch unreachable;

    print("ANSWER PART 2: {}\n", .{acc});
}
