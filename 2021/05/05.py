import numpy as np

def strparse(l):
    ans = []
    for x in l.split(' -> '):
        for y in x.split(','):
            ans.append(int(y))
    return ans

data = open("input.txt").read().splitlines()
lines = []
max_x, max_y = 0, 0
for x in data:
    d = strparse(x)
    max_x = max(max_x, max(d[::2]))
    max_y = max(max_y, max(d[1::2]))

for i in range(2):
    X = np.zeros((max_y+1, max_x+1))
    for x in data:
        d = strparse(x)
        a=np.linspace(d[1],d[3],np.abs(d[3]-d[1])+1,dtype='int')
        b=np.linspace(d[0],d[2],np.abs(d[2]-d[0])+1,dtype='int')
        if i==0 and not any(len(x) == 1 for x in [a,b]):
            continue
        X[(a,b)]+=1
    print(np.sum(X>1))
