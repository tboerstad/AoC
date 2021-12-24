import json

def leaf(x):
    return isinstance(x, int)

def addr(x, b):
    if b is None:
        return x
    if leaf(x):
        return x + b
    return [ x[0], addr(x[1], b) ]

def addl(x, a):
    if a is None:
        return x
    if leaf(x):
        return x + a
    return [ addl(x[0], a), x[1] ]

def explode(x, n):
    if leaf(x):
        return False, None, x, None
    if n == 0:
        return True, x[0], 0, x[1]
    a, b = x
    ex, left, a, right = explode(a, n - 1)
    if ex:
        return True, left, [a, addl(b, right)], None
    ex, left, b, right = explode(b, n-1)
    if ex:
        return True, None, [addr(a, left), b], right
    return False, None, x, None

def split(x):
    if leaf(x): 
        if x > 9:
            return True, [ x//2, (x+1)//2]
        return False, x
    a, b = x
    sp, a = split(a)
    if sp:
        return True, [a, b]
    sp, b = split(b)
    return sp, [a,b]

def add(a,b):
    x = [a, b]
    while True:
     ex, _, x, _ = explode(x, 4)
     if ex: continue
     spl, x = split(x)
     if spl: continue
     break
    return x

def magnitude(x):
    a, b = x
    if leaf(a) and leaf(b):
        return 3*a + 2*b
    if leaf(a):
        return 3*a + 2*magnitude(b)
    if leaf(b):
        return 3*magnitude(a) + 2*b
    return 3*magnitude(a) + 2*magnitude(b)

inputs = [json.loads(line) for line in open('input.txt')]
s = inputs[0]
for l in inputs[1:]:
    s = add(s,l)
print(magnitude(s))

max_mag = 0
for i in range(len(inputs)):
    for j in range(len(inputs)):
        if i==j:
            continue
        max_mag = max(max_mag, magnitude(add(inputs[i],inputs[j])))
print(max_mag)