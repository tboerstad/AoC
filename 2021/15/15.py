import numpy as np
from functools import cache
import heapq

instr = open("input.txt").read().splitlines()


COST = {}
M = len(instr)
N = len(instr[0])
for row_idx, col in enumerate(instr):
    for col_idx, val in enumerate(col):
        COST[(row_idx,col_idx)] = int(val)
@cache
def compute_cost(r,c):
    if (r,c) in COST:
        return COST[r,c]
    if (r,0) in COST:
        return (compute_cost(r, c-N) % 9) + 1
    if (0,c) in COST:
        return (compute_cost(r-M, c) % 9) + 1
    return (compute_cost(r-M,c) % 9) + 1

DIST = {}
Q = []
Q_SORTED = []

def neighbours(n):
    return [ (n[0]+0,n[1]+1), \
             (n[0]+1,n[1]+0), \
             (n[0]+0,n[1]-1), \
             (n[0]-1,n[1]+0) ]

for x in range(5*M):
    for y in range(5*N):
        DIST[(x,y)] = np.inf
        Q.append((x,y))
DIST[(0,0)] = 0
heapq.heappush(Q_SORTED, (0, (0,0)))

while len(Q) > 0:

    candidates = heapq.nsmallest(len(Q_SORTED), Q_SORTED)
    for d, u in candidates:
        if u in Q:
            break
    Q.remove(u)
    Q_SORTED.remove((d,u))
    heapq.heapify(Q_SORTED)

    found_better = False
    for n in neighbours(u):
        if n not in Q:
            continue
        new_dist = DIST[u] + compute_cost(n[0],n[1])
        if new_dist < DIST[n]:
            DIST[n] = new_dist
            heapq.heappush(Q_SORTED, (new_dist, n))

print(DIST[M-1,N-1])
print(DIST[5*M-1,5*N-1])
    

