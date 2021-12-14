from collections import Counter
from parse import findall
from functools import cache

instr = open("input.txt").read()
rules = {x[0]: x[1] for x in findall("{:S} -> {:S}", instr)}
template = instr.partition("\n")[0]

@cache
def recursive_count(pair, steps):
    if steps == 0:
        return Counter(pair)
    return recursive_count(pair[0] + rules[pair], steps - 1) + \
           recursive_count(rules[pair] + pair[1], steps - 1) - \
           Counter({rules[pair]: 1})

def count(template, steps):
    char_count = Counter()

    for i in range(len(template) - 1):
        char_count += recursive_count(template[i : i + 2], steps)

    char_count.subtract(Counter(template[1:-1]))
    char_frequencies = sorted(char_count.values())

    return char_frequencies[-1] - char_frequencies[0]

print(count(template, 10))
print(count(template, 40))
