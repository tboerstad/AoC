from collections import defaultdict

neighbours = defaultdict(set)

def small_cave_visited_twice(current_path):
    for idx, current_node in enumerate(current_path):
        if current_node.islower() and current_node in current_path[idx+1:]:
                return True
    return False

for line in open("input.txt").read().splitlines():
    a, b = line.split('-')
    neighbours[a].add(b)
    neighbours[b].add(a)

def count(cave='start', seen=[]):
    if cave == 'end': return 1
    if cave in seen:
        if cave.islower(): return 0
    
    return sum(count(n, seen+[cave]) for n in neighbours[cave])

def count2(cave='start', seen=[]):
    if cave == 'end': return 1
    if cave in seen:
        if cave.islower():
            if cave == 'start': return 0
            if small_cave_visited_twice(seen): return 0
    
    return sum(count2(n, seen+[cave]) for n in neighbours[cave])

print(count())
print(count2())