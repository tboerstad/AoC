lines = open("input.txt").read().splitlines()

openers = ['(','[','{','<']
closers = [')',']','}','>']
points = {'(':3,'[':57,'{':1197,'<':25137}
illegals = []
legal_lines = []
for currLine in lines:
    line_is_legal = True
    line = list(currLine)
    states = []
    while len(line) != 0:
        while len(line) and line[0] in openers:
            states.append(line.pop(0))
        while len(line) and line[0] in closers:
            correct_opener = openers[closers.index(line.pop(0))]
            if states[-1] != correct_opener:
                illegals.append(points[correct_opener])
                line = []
                line_is_legal = False
                break
            states.pop()
    if line_is_legal:
        legal_lines.append(list(currLine))

scores = []
for line in legal_lines:
    states = []
    while len(line) != 0:
        while len(line) and line[0] in openers:
            states.append(line.pop(0))
        while len(line) and line[0] in closers:
            correct_opener = openers[closers.index(line.pop(0))]
            if states[-1] != correct_opener:
                illegals.append(points[correct_opener])
            states.pop()
    score = 0
    for s in reversed(states):
        score = score*5+openers.index(s)+1
    scores.append(score)
score = sorted(scores)[len(scores)//2]

print(sum(illegals))
print(score)