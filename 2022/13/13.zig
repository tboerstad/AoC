const std = @import("std");
const print = std.debug.print;
var buffer = [_]u8{undefined} ** 5;


const SubPacket = struct {
    const Self = @This();
    s: [] const u8,

    fn init(line: []const u8) Self {
        return Self{.s = line};
    }

    fn isList(self: *const Self) bool {
        return self.s[0] == '[';
    }

    fn num(self: *const Self) u32 {
        return std.fmt.parseInt(u32, self.s, 10) catch unreachable;
    }

    fn isNum(self: *const Self) bool {
        return !self.isList();
    }

    fn len(self: *const Self) usize {
        if (self.s.len == 2) { return 0; }
        var l: usize = 1;
        var d: usize = 0;
        for (self.s) |c| {
            switch (c) {
                '[' => d+=1,
                ']' => d-=1,
                ',' => l += if(d==1) 1 else 0,
                else => {},
            }
        }
        return l;
    }

    fn at(self: *const Self, i: usize) Self {
        var start: usize = 1;
        var l: usize = 0;
        var d: usize = 0;
        for (self.s) |c,j| {
            switch (c) {
                '[' => d+=1,
                ']' => d-=1,
                ',' => {
                    if (d==1) {
                        if (l==i) { return Self.init(self.s[start..j]); }
                        l += 1;
                        start = j+1;
                    }
                },
                else => {},
            }
        }
        return Self.init(self.s[start..self.s.len-1]);
    }
};

pub fn compare(l: SubPacket, r: SubPacket) i32 {
    if (l.isNum() and r.isNum()) {
        if (l.num()>r.num()) { return 1; }
        if (l.num()<r.num()) { return -1; }
        return 0;
    }
    if (l.isNum() and r.isList()) {
        var temp = SubPacket.init( std.fmt.bufPrint(&buffer, "[{s}]", .{l.s}) catch unreachable ); 
        return compare(temp, r);
    }
    if (l.isList() and r.isNum()) {
        var temp = SubPacket.init( std.fmt.bufPrint(&buffer, "[{s}]", .{r.s}) catch unreachable ); 
        return compare(l, temp);
    }
    else {
        var len = @min(l.len(), r.len());
        var i: usize = 0;
        while (i<len) : (i += 1) {
            var result = compare(l.at(i), r.at(i));
            if ( result != 0 ) {
                return result;
            }
        }
        if (l.len()>r.len()) { return 1; }
        if (l.len()<r.len()) { return -1; }
        return 0;
    }
    unreachable;
}

pub fn lessThan(context: void, l: SubPacket, r: SubPacket) bool {
    _ = context;
    return compare(l, r) == -1;
}

fn p1(input: []const u8) !void {
    var packet_iter = std.mem.split(u8, input, "\n\n");
    var cnt: usize = 1;
    var ans: usize = 0;
    while (packet_iter.next()) |packet| {
        var subpacket_iter = std.mem.split(u8, packet, "\n");
        var left = SubPacket.init( subpacket_iter.next().? );
        var right = SubPacket.init( subpacket_iter.next().? );
        if (compare(left, right) == -1) {
            ans += cnt;
        }
        cnt+=1;
    }
    print("P1: {d}\n", .{ans});
}

fn p2(input: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var list = std.ArrayList(SubPacket).init(alloc);
    try list.append( SubPacket.init("[[2]]"));
    try list.append( SubPacket.init("[[6]]"));
    var packet_iter = std.mem.split(u8, input, "\n");
    while (packet_iter.next()) |packet| {
        if (packet.len == 0) { continue; }
        try list.append(SubPacket.init( packet ));
    }
    std.sort.sort( SubPacket, list.items, {}, lessThan);

    var sum: usize = 1;
    for (list.items) |p, i| {
        if (std.mem.eql(u8, p.s, "[[2]]") or std.mem.eql(u8, p.s, "[[6]]")) {
            sum *= (i+1);
        }
    }

    print("P2: {d}\n", .{sum});
}

test "input 1" {
    try p1(@embedFile("input.txt"));
}

test "input 2" {
    try p2(@embedFile("input.txt"));
}

test "ex 1" {
    try p1(@embedFile("ex.txt"));
}

test "ex 2" {
    try p2(@embedFile("ex.txt"));
}