const std = @import("std");
const input = @embedFile("input.txt");

const scores = [3][3]u32{
    [_]u32 { 4, 1, 7 },
    [_]u32 { 8, 5, 2 },
    [_]u32 { 3, 9, 6 }
};

const computeMoves = [3][3]u8{
    [_]u8 { 2, 0, 1 },
    [_]u8 { 0, 1, 2 },
    [_]u8 { 1, 2, 0 }
};

pub fn main() !void {
    var scoreP1: u32 = 0;
    var scoreP2: u32 = 0;
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        const me = line[2]-'X';
        const them = line[0]-'A';
        scoreP1 += scores[me][them];
        scoreP2 += scores[computeMoves[me][them]][them];
    }

    // P1
    std.debug.print("{d}\n", .{scoreP1});

    // P2
    std.debug.print("{d}\n", .{scoreP2});
}
