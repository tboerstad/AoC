from parse import search
import numpy as np

instr = open("input.txt").read()
x_min, x_max, y_min, y_max = search("x={:d}..{:d}, y={:d}..{:d}",instr)

all = set()
global_y_max = 0
for dx0 in range (0, 2*x_max):
    for dy0 in range(-80,2000):
        local_y_max = 0
        y = 0
        x = 0
        dx = dx0
        dy = dy0
        for n in range(1,200):
            x = x + dx
            y = y + dy
            local_y_max = max(local_y_max,y)
            dx = dx-np.sign(dx) if dx != 0 else 0
            dy = dy -1
            if y < y_min: 
                break
            if y <= y_max and y >= y_min and x <= x_max and x >= x_min:
                all.add( (dx0,dy0) )
                global_y_max = max(global_y_max, local_y_max)
                break

print(global_y_max)
print(len(all))
