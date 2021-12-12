
s = 0
for x, y in [x.split('|') for x in open("input.txt")]:
    c = { x: 0 for x in 'abcdefg'}
    for d in x.split():
        for a in d:
            c[a] += 1
    cnts = []
    m = {'467889': 0, '89': 1, '47788': 2, '77889': 3, '6789': 4, '67789': 5, '467789': 6, '889': 7, '4677889': 8, '677889': 9}
    n = ''
    for d in y.split():
        n=n+str(m[''.join(map(str,sorted([c[a] for a in d])))])
    s = s+int(n)

print(s)