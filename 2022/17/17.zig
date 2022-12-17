const std = @import("std");
const print = std.debug.print;
const Pos = @Vector(2, usize);
const Delta = @Vector(2, isize);

const Node = [2]u8; 
var node_indices: std.StringHashMap(u32) = undefined;

const M: usize = 4000;
var dist: [M][M]u32 = undefined;
var reward: [M]u32 = undefined;

const Board = struct {
    map: [M][9]u8,
    y_max: usize,

    fn step(self: *Board, p: *Piece, dir: u8 ) bool {
        var testPiece = p.*;
        var dx = if (dir == '>') Delta{1, 0} else Delta{-1, 0};
        testPiece.update( dx );
        if (self.intersects(testPiece)) {
            testPiece.update( -dx );
        }        

        var dy = Delta{ 0, -1};
        testPiece.update( dy );
        var finished = false;
        if (self.intersects(testPiece)) {
            testPiece.update( -dy );
            for (testPiece.shape) |pos| {
                self.map[M - 1 - pos[1]][pos[0]] = 1;
            }
            self.y_max = @max(self.y_max,testPiece.y_max());
            finished = true;
        }

        p.* = testPiece;
        return !finished;
    }

    fn start_y(self: *const Board) isize {
        return @bitCast(isize, self.y_max);
    }

    fn init() Board {
        var map: [M][9]u8 = undefined;
        for (map) |*row, y| {
            for (row) |*c,x| {
                if (y==M-1 or x==0 or x==8){
                    c.*=1;
                }
                else {
                    c.*=0;
                }
            }
        }
        return Board{
            .map = map,
            .y_max = 0
        };
    }

    fn intersects(b: *const Board, p: Piece) bool {
        for (p.shape) |pos| {
            if(b.map[M - 1 - pos[1]][pos[0]] != 0) {
                return true;
            }
        }
        return false;
    }

};

const Piece = struct {
    shape: [5]Pos,

    fn update(self: *Piece, delta: Delta) void {
        for (self.shape) |*pos| {
            var posI32 = @bitCast(Delta, pos.*);
            posI32 += delta;
            pos.* = @bitCast(Pos, posI32);
        }
    }

    fn y_max(self: *const Piece) usize {
        var res: usize = 0;
        for (self.shape) |pos| {
            res = @max(pos[1],res);
        }
        return res;
    }
    
};

const pieceSource = [_]Piece{
    Piece{ .shape = .{.{0,0}, .{1,0}, .{2,0}, .{3,0}, .{3,0} }},
    Piece{ .shape = .{.{1,0}, .{0,1}, .{1,1}, .{2,1}, .{1,2} }},
    Piece{ .shape = .{.{0,0}, .{1,0}, .{2,0}, .{2,1}, .{2,2} }},
    Piece{ .shape = .{.{0,0}, .{0,1}, .{0,2}, .{0,3}, .{0,3} }},
    Piece{ .shape = .{.{0,0}, .{0,1}, .{1,0}, .{1,1}, .{1,1} }},
};


fn solve(input: []const u8) !void {
    var board = Board.init();

    var pieceNum: usize = 1;
    var pieceIdx: usize = 0;
    var windIdx: usize = 0;
    while (pieceNum < 2023) : (pieceNum += 1) {
        var currentPiece = pieceSource[pieceIdx]; 
        currentPiece.update( .{ 3, board.start_y()+4} ); 
        while (board.step(&currentPiece, input[windIdx])) {
            windIdx = (windIdx+1) % input.len;
        }
        windIdx = (windIdx+1) % input.len;
        pieceIdx = (pieceIdx+1) % 5;
    }

    print("{d}\n", .{board.start_y()});
}

test "input 1" {
    try solve(@embedFile("input.txt"));
}

test "ex 1" {
    try solve(@embedFile("ex.txt"));
}