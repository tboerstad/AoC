const std = @import("std");

const M = 10;
const Stack = std.atomic.Stack(u8);
var crates: [M]Stack = undefined; 

fn solve(input: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    for (crates) |*c| {
        c.* = Stack.init(); 
    }

    var iter = std.mem.split(u8, input, "\n\n");
    var crates_iter = std.mem.split(u8, iter.next().?, "\n");
    var cmd_iter = std.mem.split(u8, iter.next().?, "\n");

    outer: 
    while (crates_iter.next()) |line| {
        var index: usize = 1;
        while (index < line.len) : (index += 4) {
            if (line[index] == ' ') { continue; }
            if (line[index] == '1') { break :outer; }
            const node = try allocator.create(Stack.Node);
            node.* = Stack.Node{ .data = line[index], .next = undefined };
            crates[(index-1)/4 + 1].push(node);
        }
    }

    for (crates[0..M-1]) |*c, index| {
        while (crates[index+1].pop()) |node| {
            c.push(node);
        }
    }

    while (cmd_iter.next()) |line| {
        var instr = std.mem.tokenize(u8, line, "from to move");
        var amount: u32 = try std.fmt.parseInt(u32, instr.next().?, 10);
        var   from: u32 = try std.fmt.parseInt(u32, instr.next().?, 10);
        var     to: u32 = try std.fmt.parseInt(u32, instr.next().?, 10);

        var j: u32 = amount;
        while (j > 0) : (j -= 1) {
            crates[M-1].push(crates[from - 1].pop().?);
        }
        j = amount;
        while (j > 0) : (j -= 1) {
            crates[to-1].push(crates[M-1].pop().?);
        }
    }

    for (crates[0..M-1]) |*c| {
        if (!c.isEmpty()) {
            std.debug.print("{c}", .{c.pop().?.data});
        }
    }
    std.debug.print("\n", .{});
}

test "input 1" {
    try solve(@embedFile("input.txt"));
}

// test "input 2 " {
//     try solve(@embedFile("input.txt"), intersects);
// }

test "ex 1" {
    try solve(@embedFile("ex.txt"));
}

// test "ex 2" {
//     try solve(@embedFile("ex.txt"), intersects);
// }