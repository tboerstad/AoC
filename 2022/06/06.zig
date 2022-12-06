const std = @import("std");

fn solve(input: []const u8, M: usize) !void {
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        for (line[0..line.len-M+1]) |_, index| {
            var bitPattern: u26 = 0;
            
            var cnt: usize = 0;
            while ( cnt < M ) : ( cnt += 1 ) {
                bitPattern |= @as(u26, 1) << @truncate(u5, line[index+cnt] - 'a');
            }

            if (@popCount(bitPattern) == M) {
                std.debug.print("{d}\n", .{index + M});
                break;
            }
        }
    }
}

test "input 1" {
    try solve(@embedFile("input.txt"), 4);
}

test "input 2 " {
    try solve(@embedFile("input.txt"), 14);
}

test "ex 1" {
    try solve(@embedFile("ex.txt"), 4);
}

test "ex 2" {
    try solve(@embedFile("ex.txt"), 14);
}