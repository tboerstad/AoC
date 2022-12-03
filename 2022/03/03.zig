const std = @import("std");

fn pri(x: u8) u6 {
    var y = if (x >= 'a') x - 'a' else x - 'A' + 26;
    return @truncate(u6, y);
}


fn p1(input: []const u8) !void {
    var iter = std.mem.split(u8, input, "\n");
    var sum: u32 = 0;
    while (iter.next()) |line| {
        var left: u52 = 0;
        for (line[0..line.len/2]) |item| {
            left |= @as(u52, 1) << pri(item);
        }

        var right: u52 = 0;
        for (line[line.len/2..line.len]) |item| {
            right |= @as(u52, 1) << pri(item);
        }

        var result = @ctz( left & right ) + 1;
        sum += result;
    }
    std.debug.print("{d}\n", .{sum});
}


fn p2(input: []const u8) !void {
    var iter = std.mem.split(u8, input, "\n");
    var sum: usize = 0;

    while (iter.next()) |line| {
        var elf1: u52 = 0;
        for (line) |item| {
            elf1 |= @as(u52, 1) << pri(item);
        }

        var elf2: u52 = 0;
        for (iter.next().?) |item| {
            elf2 |= @as(u52, 1) << pri(item);
        }

        var elf3: u52 = 0;
        for (iter.next().?) |item| {
            elf3 |= @as(u52, 1) << pri(item);
        }

        var result = @ctz( elf1 & elf2 & elf3 ) + 1;
        sum += result;
    }
    std.debug.print("{d}\n", .{sum});
}


test "input 1" {
    try p1(@embedFile("input.txt"));
}

test "input 2 " {
    try p2(@embedFile("input.txt"));
}

test "ex 1" {
    try p1(@embedFile("ex.txt"));
}

test "ex 2" {
    try p2(@embedFile("ex.txt"));
}