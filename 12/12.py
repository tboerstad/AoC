from collections import defaultdict

caves = set(["start","end"])
neighbours = defaultdict(set)

def big_cave(cave):
    return cave.upper() == cave

def can_visit_p1(cave, current_path):
    return big_cave(cave) or cave not in current_path

def small_cave_visited_twice(current_path):
    for idx, current_node in enumerate(current_path):
        if not big_cave(current_node):
            if current_node in current_path[idx+1:]:
                return True
    return False

def can_visit_p2(cave, current_path):
    if cave in ['start', 'finish']:
        return False
    if small_cave_visited_twice(tuple(current_path)):
        return can_visit_p1(cave, current_path)
    return big_cave(cave) or current_path.count(cave) < 2

def collect_paths(current_path, pred):
    if current_path[-1] == 'end':
        return 1
    caves_to_visit = [x for x in neighbours[current_path[-1]] if pred(x,tuple(current_path))]
    return sum([collect_paths(current_path+[n], pred) for n in caves_to_visit])

for line in open("input.txt").read().splitlines():
    a, b = line.split('-')
    caves.add(a)
    caves.add(b)
    neighbours[a].add(b)
    neighbours[b].add(a)

print(collect_paths(['start'],can_visit_p1))
print(collect_paths(['start'],can_visit_p2))