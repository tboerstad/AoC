
import numpy as np
from scipy import signal

lines = open("input.txt")
points = []
folds = []
x_max, y_max = 0,0
for line in lines:
    if line == '\n': continue
    if "fold" in line:
        axis, val = line[11:].split("=")
        folds.append( (axis=='x', int(val)))
        continue

    x,y = map(int,line.split(','))
    x_max, y_max = max(x,x_max), max(y,y_max)
    points.append([x,y])


X = np.zeros((y_max+1,x_max+1),dtype=int)
for p in points:
    X[p[1],p[0]] = 1

def fold(X, instructions):
    for i in instructions:
        fold_x = i[0]
        val = i[1]
        if fold_x:
            X[:,0:val] += np.fliplr(X[:,val+1:])
            X = X[:,0:val]
        else:
            X[0:val,:] += np.flipud(X[val+1:,:])
            X = X[0:val,:]
    if len(instructions) == 1:
        print(np.sum(X>0))
    else:
        X[X>1]=1
        print(X)

fold(X, folds[0:1])
fold(X, folds)
