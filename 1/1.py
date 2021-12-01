import numpy as np

vals = [int(x) for x in open("input.txt")]

print(np.sum(np.convolve(vals,[1,-1],mode='valid') > 0))
print(np.sum(np.convolve(vals,[1,0,0,-1],mode='valid') > 0))
