const std = @import("std");
const ArrayList = std.ArrayList;
const Str = []const u8;

const File = struct {
    name: Str,
    size: u32,
};

const Dir = struct { 
    name: Str,
    files: ArrayList(File),
    dirs: ArrayList(Dir),
    size: u32 ,
    parent: ?*Dir, 
    alloc: std.mem.Allocator,

    const Self = @This();
    pub fn init(alloc: std.mem.Allocator, name: Str, parent: ?*Dir) Self {
        return Self{
            .size = 0,
            .name = name,
            .dirs = ArrayList(Dir).init(alloc),
            .files = ArrayList(File).init(alloc),
            .parent = parent,
            .alloc = alloc,
        };
    }

    pub fn addSubdirectory(self: *Self, name: Str) !*Self {
        for (self.dirs.items) |*subdir| {
            if (std.mem.eql(u8, subdir.name, name)) {
                return subdir;
            } 
        }

        try self.dirs.append( Dir.init(self.alloc, name, self) );
        return &self.dirs.items[self.dirs.items.len-1];
    }

    pub fn addFile(self: *Self, name: Str, size: u32) !void {
        for (self.files.items) |*file| {
            if (std.mem.eql(u8, file.name, name)) {
                return;
            } 
        }

        try self.files.append( File{ .name = name, .size = size } );
    }

 };

fn resolveSize(dir: *Dir) u32 {
    var dirSize: u32 = 0;
    for (dir.files.items) |file| { dirSize += file.size; }
    for (dir.dirs.items) |*subdir| { dirSize += resolveSize(subdir); }
    dir.size = dirSize;
    return dirSize;
}

fn calculateP1(dir: *Dir) u32 {
    var sum: u32 = 0;
    if (dir.size <= 100000) { sum += dir.size; }
    for (dir.dirs.items) |*subdir| { sum += calculateP1(subdir); }
    return sum;
}

fn solve(input: Str) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var root = Dir.init(allocator, "/", null);
    var current_dir = &root;

    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        switch(line[0]) {
             '$' => {
                if (line[2] == 'c' and line[5] == '.') {
                    current_dir = current_dir.parent.?;
                }
                else if (line[2] == 'c') {
                    var new_dir_name = line[5..];
                    current_dir = try current_dir.addSubdirectory(new_dir_name);
                }

             },
             'd' => {},
             '0'...'9' => {
                var name_size = std.mem.split(u8, line, " ");
                const file_size = try std.fmt.parseInt(u32, name_size.next().?, 10);
                const file_name = name_size.next().?;
                try current_dir.addFile(file_name, file_size);
             },
             else => unreachable,
        }
    }

    var root_size = resolveSize(&root);
    std.debug.print("P1: {d}\n", .{calculateP1(&root)});

    var freeSpace: u32 = 30000000 - (70000000 - root_size);

    var bestDir = &root;
    var toVisit = std.ArrayList(*Dir).init(allocator);
    try toVisit.append(&root);
    while (true) {
        if (toVisit.items.len == 0) { break; }
        var dir = toVisit.pop();

        if (dir.size > freeSpace and dir.size < bestDir.size) {
            bestDir = dir;
        }
        for (dir.dirs.items) |*subdirs| {
            try toVisit.append(subdirs);
        }
    }
    std.debug.print("P2 {d}\n", .{bestDir.size});
}

test "input 1" {
    try solve(@embedFile("input.txt"));
}

// test "input 2 " {
//     try solve(@embedFile("input.txt"));
// }

test "ex 1" {
    try solve(@embedFile("ex.txt"));
}

// test "ex 2" {
//     try solve(@embedFile("ex.txt"));
// }
