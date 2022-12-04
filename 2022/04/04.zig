const std = @import("std");

fn fully_contains( l1: u32, r1: u32, l2: u32, r2: u32) bool {
    return (l1 <= l2 and r1 >= r2) or (l2 <= l1 and r2 <= r1);
}

fn intersects( l1: u32, r1: u32, l2: u32, r2: u32 ) bool {
    return (l1 <= r2 and r1 >= l2);
}

fn solve(input: []const u8, decided: *const fn( u32, u32, u32, u32 ) bool) !void {
    var iter = std.mem.split(u8, input, "\n");

    var cnt: u32 = 0;
    while (iter.next()) |line| {
        var elf_iter = std.mem.tokenize(u8, line, "-,");
        var l1 = try std.fmt.parseInt(u32, elf_iter.next().?, 10);
        var r1 = try std.fmt.parseInt(u32, elf_iter.next().?, 10);
        var l2 = try std.fmt.parseInt(u32, elf_iter.next().?, 10);
        var r2 = try std.fmt.parseInt(u32, elf_iter.next().?, 10);

        cnt += @boolToInt(decided(l1, r1, l2, r2));
    }
    std.debug.print("{d}\n", .{cnt});
}

test "input 1" {
    try solve(@embedFile("input.txt"), fully_contains);
}

test "input 2 " {
    try solve(@embedFile("input.txt"), intersects);
}

test "ex 1" {
    try solve(@embedFile("ex.txt"), fully_contains);
}

test "ex 2" {
    try solve(@embedFile("ex.txt"), intersects);
}