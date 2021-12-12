from collections import defaultdict
from functools import cache

neighbours = defaultdict(set)

@cache
def small_cave_visited_twice(current_path):
    for idx, current_node in enumerate(current_path):
        if current_node.islower() and current_node in current_path[idx+1:]:
                return True
    return False

for line in open("input.txt").read().splitlines():
    a, b = line.split('-')
    neighbours[a].add(b)
    neighbours[b].add(a)

@cache
def count(cave='start', seen=tuple()):
    if cave == 'end': return 1
    if cave in seen:
        if cave.islower(): return 0
    if cave.islower():
        seen = (*seen,cave)
    
    return sum(count(n, seen) for n in neighbours[cave])

@cache
def count2(cave='start', seen=tuple()):
    if cave == 'end': return 1
    if cave in seen:
        if cave.islower():
            if cave == 'start': return 0
            if small_cave_visited_twice(seen): return 0
    if cave.islower():
        seen = (*seen,cave)
    
    return sum(count2(n, seen) for n in neighbours[cave])

print(count())
print(count2())