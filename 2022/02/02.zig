const std = @import("std");
const input = @embedFile("input.txt");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn computeMove(me: u8, them: u8) u8 {
    switch (me) {
        'X' => {
            switch (them) {
                'A' => { return 'Z'; },
                'B' => { return 'X'; },
                'C' => { return 'Y'; },
                 else => unreachable,
            }
        },
        'Y' => {
            switch (them) {
                'A' => { return 'X'; },
                'B' => { return 'Y'; },
                'C' => { return 'Z'; },
                 else => unreachable,
            }
        },
        'Z' => {
            switch (them) {
                'A' => { return 'Y'; },
                'B' => { return 'Z'; },
                'C' => { return 'X'; },
                 else => unreachable,
            }
        },
        else => unreachable,
    }
    unreachable;
}

fn computeScore(me: u8, them: u8) u32 {
    var score: u32 = 0;
    switch (me) {
        'X' => {
            score += 1;
            switch (them) {
                'A' => { score += 3; },
                'B' => { score += 0; },
                'C' => { score += 6; },
                 else => unreachable,
            }
        },
        'Y' => {
            score += 2;
            switch (them) {
                'A' => { score += 6; },
                'B' => { score += 3; },
                'C' => { score += 0; },
                 else => unreachable,
            }
        },
        'Z' => {
            score += 3;
            switch (them) {
                'A' => { score += 0; },
                'B' => { score += 6; },
                'C' => { score += 3; },
                 else => unreachable,
            }
        },
        else => unreachable,
    }
    return score;
}

pub fn main() !void {
    var scoreP1: u32 = 0;
    var scoreP2: u32 = 0;
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        scoreP1 += computeScore(line[2], line[0]);
        scoreP2 += computeScore(computeMove(line[2], line[0]), line[0]);
    }

    // P1
    std.debug.print("{d}\n", .{scoreP1});

    // P2
    std.debug.print("{d}\n", .{scoreP2});
}
