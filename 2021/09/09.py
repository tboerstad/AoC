
import numpy as np
from scipy import signal

lines = open("input.txt",encoding='ascii').read().splitlines()

X = np.ndarray((len(lines),len(lines[0])),dtype=int)
for idx, line in enumerate(lines):
    X[idx] = np.array([int(x) for x in line])

X_PAD = np.pad(X, 1, constant_values=9)

MASK = \
(X < X_PAD[ 2 :   ,  1  : -1]) & \
(X < X_PAD[   : -2,  1  : -1]) & \
(X < X_PAD[ 1 : -1,  2  :   ]) & \
(X < X_PAD[ 1 : -1,     : -2])

print(np.sum(X[MASK]+1))

from scipy.ndimage.measurements import label

Y = X+1
Y[Y==10]=0

structure = np.array([[0,1,0],[1,0,1],[0,1,0]], dtype=int)
labeled, ncomponents = label(Y, structure)

sizes = []
for c in range(ncomponents):
    sizes.append(np.sum(labeled==c+1))
sizes = sorted(sizes)
print(sizes[-1]*sizes[-2]*sizes[-3])
