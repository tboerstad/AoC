
from functools import reduce
d = list(map(int,open('input.txt').read().split(',')))

def a(s,i):
    s[i] = d.count(i)
    return s

s = reduce(a, range(9), {})

def iterate_state(state):
    new_state = { i:0 for i in range(9 ) }
    for day, num in state.items():
        if day == 0:
            new_state[8] = num
            new_state[6] = num
        else:
            new_state[day-1] = num + new_state[day-1]
    return new_state

for i in range(256):
    s = iterate_state(s)
    if i == 79:
        print(sum(s.values()))
print(sum(s.values()))