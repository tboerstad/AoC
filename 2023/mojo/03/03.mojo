from collections import Dict
from python import Python

@value
struct Point:
    var row: Int
    var col: Int

    fn __hash__(self) -> UInt:
        return UInt(self.row) * 1000000 + UInt(self.col)

    fn __eq__(self, other: Point) -> Bool:
        return self.row == other.row and self.col == other.col

    fn __ne__(self, other: Point) -> Bool:
        return not self == other

fn main() raises:
    with open("input.txt", "r") as f:
        lines = f.read().splitlines()
    
    symbols = Dict[Point, List[Int]]()

    row = 0
    for line in lines:
        var col = 0
        for char in line[]:
            if char not in String("0123456789."):
                symbols[Point(row, col)] = List[Int]()
            col += 1
        row += 1

    re = Python.import_module("re")
    row = 0
    for line in lines:
        for num in re.finditer(r'\d+', line[]):
            edges = List[Point]()
            for r in range(row-1, row+2):
                for c in range(num.span()[0]-1, num.span()[1]+1):
                    edges.append(Point(r, c))

            for edge in edges:
                if edge[] in symbols:
                    symbols[edge[]].append(atol(str(num.group())))
        row += 1
            
    sum = 0
    for symbol in symbols:
        for number in symbols[symbol[]]:
            sum += number[]
    print(sum)
    sum = 0
    for symbol in symbols:
        if len(symbols[symbol[]]) == 2:
            sum += symbols[symbol[]][0] * symbols[symbol[]][1]
    print(sum)
