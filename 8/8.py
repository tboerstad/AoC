p1 = 0
p2 = 0
for x, y in [x.split('|') for x in open("input.txt")]:
    l = { len(s): set(s) for s in x.split()}
    n = ''
    s = ''
    for o in map(set, y.split()):
        match len(o), len(o&l[4]), len(o&l[2]):  # mask with known digits
            case 2,_,_: n += '1'; p1 += 1
            case 7,_,_: n += '8'; p1 += 1
            case 3,_,_: n += '7'; p1 += 1
            case 4,_,_: n += '4'; p1 += 1
            case 6,4,_: n += '9'
            case 6,_,2: n += '0'
            case 6,_,_: n += '6'
            case 5,_,2: n += '3'
            case 5,3,_: n += '5'
            case 5,_,_: n += '2'
    p2 += int(n)

print(p1)
print(p2)
