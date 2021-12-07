from functools import reduce

D = list(map(int,open("input.txt").read().split(',')))
n = range(min(D),max(D)+1)
C = { v:0 for v in D }

def cnt(c,v):
    cost = sum(map(lambda s: abs(s-v)*(abs(s-v)+1)//2,D))
    c[v] = cost
    return c

print( sum( abs(d - sorted(D)[len(D)//2]) for d in D ))
cost = reduce(cnt, n, C)
print(min(cost.values()))