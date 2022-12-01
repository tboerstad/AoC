from collections import deque

def inc(X,k):
    if k not in X or X[k]['flashed']:
        return False

    X[k]['energy'] = X[k]['energy']+1
    if X[k]['energy'] > 9:
        X[k]['flashed'] = True
        X[k]['energy'] = 0
        return True
    return False

lines = open("input.txt").read().splitlines()
X = {}

for row, line in enumerate(lines):
    for col, val in enumerate(line):
        X[(row,col)] = {'energy':int(val), 'flashed':False}

score = 0
for i in range(300):
    nodes = deque(X.keys())
    while len(nodes) != 0:
        k = nodes.popleft()
        if inc(X, k):
            nodes.append(k)
            for a in range(-1,2):
                for b in range(-1,2):
                    nodes.append( tuple([k[0]+a,k[1]+b]) )
    if all( v['flashed'] for v in X.values() ):
        print(i+1)
        break
    for v in X.values():
        if v['flashed']:
            score += 1
            v['flashed']=False

print(score)