from collections import defaultdict
from parse import findall
from functools import cache

instr = open("input.txt").read()

rules = {x[0]: x[1] for x in findall("{:S} -> {:S}", instr)}
template = instr.partition("\n")[0]
chars = set("".join(template + k + v for k, v in rules))

@cache
def recursive_count(pair, steps):
    ans = defaultdict(int)
    if steps == 0:
        ans[pair[0]] += 1
        ans[pair[1]] += 1
        return ans
    a = recursive_count(pair[0] + rules[pair], steps - 1)
    b = recursive_count(rules[pair] + pair[1], steps - 1)
    for k, v in a.items():
        ans[k] += v
    for k, v in b.items():
        ans[k] += v
    ans[rules[pair]] -= 1
    return ans


def count(template, steps):
    char_count = defaultdict(int)

    for c in template[1:-1]:
        char_count[c] -= 1

    for i in range(len(template) - 1):
        sub_count = recursive_count(template[i : i + 2], steps)
        for pair, cnt in sub_count.items():
            char_count[pair] += cnt

    char_freq = sorted(char_count, key=char_count.get)
    return char_count[char_freq[-1]] - char_count[char_freq[0]]


print(count(template, 10))
print(count(template, 40))
