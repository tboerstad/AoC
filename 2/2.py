from functools import reduce

def step1(state, line):
    command, value = line.split(' ')
    value = int(value)
    match(command):
        case 'up': state[1] -= value
        case 'down': state[1] += value
        case 'forward': state[0] += value
    return state

def step2(state, line):
    command, value = line.split(' ')
    value = int(value)
    match(command):
        case 'up': state[2] -= value
        case 'down': state[2] += value
        case 'forward': state[0] += value; state[1] += value * state[2]
    return state

input = open("input.txt").readlines()
pos, depth = reduce( step1, input, [0,0] )
print(pos*depth)
pos, depth, aim = reduce( step2, input, [0,0,0] )
print(pos*depth)

