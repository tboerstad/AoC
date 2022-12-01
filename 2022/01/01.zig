const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var list = std.ArrayList(i32).init(gpa.allocator());

    var sum: i32 = 0;
    var buf: [10]u8 = undefined;
    while (try reader.reader().readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        if (line.len == 0) {
            list.append(sum) catch unreachable;
            sum = 0;
        } else {
            const n = try std.fmt.parseInt(i32, line, 10);
            sum += n;
        }
    }
    list.append(sum) catch unreachable;

    std.sort.sort(i32, list.items, {}, comptime std.sort.desc(i32));

    // P1
    std.debug.print("{}\n", .{list.items[0]});

    // P2
    sum = 0;
    for (list.items[0..3]) |i| {
        sum += i;
    }
    std.debug.print("{}\n", .{sum});

}