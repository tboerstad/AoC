const std = @import("std");
const list = std.ArrayList;
const print = std.debug.print;

fn solve(input: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var accum: i64 = 1;
    var cycle: u32 = 1;
    var p1: i64 = 0;
    var instr = list([]const u8).init(alloc);
    
    var iter = std.mem.split(u8, input, "\n");
    while(iter.next()) |line| {
        if (line[0] == 'a') {
            try instr.append("noop");
        }
        try instr.append(line);
    }

    print("\nPart 2: \n", .{});
    for( instr.items ) |i| {
        if (cycle%40 == 20) { p1 += cycle*accum; }

        var c: u8 = if ( (cycle-1)%40 == accum-1 or (cycle-1)%40 == accum or (cycle-1)%40 == accum+1 ) '#' else ' ';
        print("{c}", .{c});
        if (cycle%40 == 0) { print("\n", .{}); } 
       
        switch(i[0]) {
            'a' => {
                accum += try std.fmt.parseInt(i32, i[5..], 10);
            },
            else => {},
        }
        cycle += 1;
    }
    
    print("\nPart 1: {d}\n", .{p1});

  
}

test "input 1" {
    try solve(@embedFile("input.txt"));
}

test "ex 2" {
    try solve(@embedFile("ex.txt"));
}