const std = @import("std");
const list = std.ArrayList;
const print = std.debug.print;
const inf = std.math.maxInt(u32);

const M: usize = 41;
const N: usize = 154;

var ELEV: [M][N]u8 = undefined;
var COST: [M][N]u32 = undefined;

const Point = struct {
    i: usize,
    j: usize
};

fn solve(input: []const u8, part2: bool) !void {
    for (COST) |*row| {
        for (row) |*c| c.*=inf;
    }
    var start = Point{ .i=0, .j=0 };
    var end = start;

    var iter = std.mem.split(u8, input, "\n");

    var ii: usize = 0;
    while(iter.next()) |line| {
        for (line) |c, jj| {
            switch(c) {
                'S' => {
                    start.i = ii;
                    start.j = jj;
                    ELEV[ii][jj] = 0;
                    COST[ii][jj] = 0;
                },
                'E' => {
                    end.i = ii;
                    end.j = jj;
                    ELEV[ii][jj] = 25;
                },
                else => { 
                    if (part2 and c=='a') { 
                        COST[ii][jj] = 0; 
                    }

                    ELEV[ii][jj] = c-'a';
                }
            }
        }
        ii +=1;
    }

    var curr_cost: u32 = 0;
    outer: while (true) : (curr_cost += 1) {
        for (ELEV) |row, i| {
            for (row) |c, j| {
                if (COST[i][j] == curr_cost) {
                    if (i < M-1  and ELEV[i+1][j+0] <= c+1) { COST[i+1][j+0] = @min(COST[i+1][j+0], curr_cost+1); }
                    if (i > 0    and ELEV[i-1][j+0] <= c+1) { COST[i-1][j+0] = @min(COST[i-1][j+0], curr_cost+1); }
                    if (j < N-1  and ELEV[i+0][j+1] <= c+1) { COST[i+0][j+1] = @min(COST[i+0][j+1], curr_cost+1); }
                    if (j > 0    and ELEV[i+0][j-1] <= c+1) { COST[i+0][j-1] = @min(COST[i+0][j-1], curr_cost+1); }
                    if (COST[end.i][end.j] < inf){
                        break :outer;
                    }
                }
            }
        }
    }

    print("{s}", .{ if(part2) "Part 2: " else "Part 1: " } );
    print("{d}\n", .{COST[end.i][end.j]});  
}

test "input 1" {
    try solve(@embedFile("input.txt"), false);
}

test "input 2" {
    try solve(@embedFile("input.txt"), true);
}

test "ex 1" {
    try solve(@embedFile("ex.txt"), false);
}

test "ex 2" {
    try solve(@embedFile("ex.txt"), true);
}