// const std = @import("std");
// const panic = std.debug.panic;
// const print = std.debug.print;
// const fmt = std.fmt;
// const ascii = std.ascii;
// const alloc = std.heap.page_allocator;
// const ArrayList = std.ArrayList;
// const HashMap = std.AutoHashMap;

// const Node = struct {
//     color: []const u8,
//     children: HashMap([]const u8, i32),
// };

// const Cursor = struct {
//     cursor: i32 = 0, pos: usize = 0, count: i32 = 0
// };

// pub fn main() !void {
//     var nodes = ArrayList(Node).init(alloc);

//     var it = std.mem.tokenize(@embedFile("../inputs/day_07"), "\n");
//     while (it.next()) |line| {
//         var words = std.mem.tokenize(line, " ");

//         var node = Node{
//             .color = "",
//             .children = HashMap([]const u8, i32).init(alloc),
//         };

//         var i: i32 = 0;
//         var cursor: ?Cursor = null;

//         while (words.next()) |word| {
//             if (i == 1) {
//                 node.color = line[0..words.index];
//             }

//             if (ascii.isDigit(word[0])) {
//                 cursor = .{
//                     .cursor = i,
//                     .pos = words.index,
//                     .count = try fmt.parseInt(i32, word, 0),
//                 };
//             }

//             if (cursor) |current| {
//                 if (current.cursor + 2 == i) {
//                     const color = line[current.pos..words.index];

//                     if (ascii.eqlIgnoreCase(color, "shiny gold")) {
//                         print("Hey!\n", .{});
//                     }

//                     try node.children.put(color, current.count);
//                     cursor = null;
//                 }
//             }

//             i += 1;
//         }

//         try nodes.append(node);
//     }
// }
