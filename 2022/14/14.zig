const std = @import("std");
const print = std.debug.print;


// const M = 169;
// const N = 85;

const M = 10;
const N = 10;

var map: [M][N]bool = [_][N]bool { [_]bool{false} ** N } ** M;



const Point = struct {
    const Self = @This();
    x: u32,
    y: u32,

    fn init(s: []const u8) !Self {
        var coords = std.mem.tokenize(u8, s, ",");
        var x = try std.fmt.parseInt(u32, coords.next().?, 10);
        var y = try std.fmt.parseInt(u32, coords.next().?, 10);
        return Self{ .x=x, .y=y };
    }
    fn init_normalized(s: []const u8, x_min: u32) !Self {
        var p = try Self.init(s);
        return Self{ .x=p.x-x_min, .y=p.y };
    }     
};

fn solve(input: []const u8) !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();

    var iter = std.mem.split(u8, input, "\n");
    var x_max: u32 = 0;
    var y_max: u32 = 0;
    var x_min: u32 = 9999999;
    while (iter.next()) |line| {
        var coords = std.mem.tokenize(u8, line, " -> ");
        while (coords.next()) |xy| {
            var p = try Point.init(xy);
            x_max = @max(x_max, p.x);
            x_min = @min(x_min, p.x);
            y_max = @max(y_max, p.y);
        }
    }

    iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        var coords = std.mem.tokenize(u8, line, " -> ");
        var start = try Point.init_normalized(coords.next().?, x_min);
        while (coords.next()) |xy| {
            var end = try Point.init_normalized(xy, x_min);

            map[start.x][start.y] = true;
            while (start.x != end.x and start.y != end.y) {
                print( "{any}\n", .{start});
                print( "{any}\n", .{end});
                if (end.x != start.x) { start.x = if(start.x < end.x) start.x+1 else start.x-1; }
                if (end.y != start.y) { start.y = if(start.y < end.y) start.y+1 else start.y-1; }
                map[start.x][start.y] = true;
            }
        }
    }

    for (map) |row| {
        print("\n", .{});
        for (row) |c| {
            if(c) {
                print(".", .{});
            } else {
                print("*", .{});
            }
        }
    }

    // print("\n{any}\n", .{map});
    print("\nx: ({d},{d}), y-max: (0,{d})\n", .{x_min, x_max, y_max});

}

// test "input 1" {
//     try solve(@embedFile("input.txt"));
// }

// test "input 2" {
//     try p2(@embedFile("input.txt"));
// }

test "ex 1" {
    try solve(@embedFile("ex.txt"));
}

// test "ex 2" {
//     try p2(@embedFile("ex.txt"));
// }