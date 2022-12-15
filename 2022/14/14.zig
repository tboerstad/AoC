const std = @import("std");
const print = std.debug.print;

const M = 1000;
const N = 1000;

var map: [M][N]bool = [_][N]bool{[_]bool{false} ** N} ** M;

const Point = struct {
    const Self = @This();
    x: u32,
    y: u32,

    fn init(s: []const u8) !Self {
        var coords = std.mem.tokenize(u8, s, ",");
        var x = try std.fmt.parseInt(u32, coords.next().?, 10);
        var y = try std.fmt.parseInt(u32, coords.next().?, 10);
        return Self{ .x = x, .y = y };
    }
};
fn printMap(m: [M][N]bool) void {
    print("\n", .{});
    for (m) |row| {
        print("\n", .{});
        for (row) |c| {
            if(c) {
                print("#", .{});
            } else {
                print(".", .{});
            }
        }
    }
}
fn solve(input: []const u8) !void {
    for (map) |*row| {
        for (row) |*c| {
            c.* = false;
        }
    }
    var y_max: u32 = 0;

    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        var coords = std.mem.tokenize(u8, line, " -> ");
        var start = try Point.init(coords.next().?);
        y_max = @max(y_max, start.y);
        while (coords.next()) |xy| {
            var end = try Point.init(xy);
            y_max = @max(y_max, end.y);
            map[start.y][start.x] = true;
            while (start.x != end.x or start.y != end.y) {
                if (end.x != start.x) {
                    start.x = if (start.x < end.x) start.x + 1 else start.x - 1;
                }
                if (end.y != start.y) {
                    start.y = if (start.y < end.y) start.y + 1 else start.y - 1;
                }
                map[start.y][start.x] = true;
            }
        }
    }

    for (map[y_max+2]) |*c| { c.* =true; }

    var cnt: usize = 0;
    var p1: usize = std.math.maxInt(usize);
    var p2: usize = 0;
    outer: while (true) {
        var sand = try Point.init("500,0");
        while (true) {
            if (map[sand.y + 1][sand.x] == false) {
                sand.y += 1;
            } else if (map[sand.y + 1][sand.x - 1] == false) {
                sand.y += 1;
                sand.x -= 1;
            } else if (map[sand.y + 1][sand.x + 1] == false) {
                sand.y += 1;
                sand.x += 1;
            } else {
                map[sand.y][sand.x] = true;
                if (sand.y == 0) {
                    p2 = cnt+1;
                    break :outer;
                }
            }

            if (sand.y == y_max) {
                p1 = @min(p1,cnt);
            }
            if (sand.y > y_max+2) {
                break;
            }
        }
        cnt += 1;
    }

    print("\nP1: {d}\n", .{p1});
    print("P2: {d}\n", .{p2});

}

test "input 1" {
    try solve(@embedFile("input.txt"));
}

test "ex 1" {
    try solve(@embedFile("ex.txt"));
}
