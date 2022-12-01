from collections import deque, namedtuple
import copy

instr = open("input.txt").read().splitlines()
BIN_STR = deque( ''.join(f"{int(x,16):04b}" for x in instr[0]) ) 
PACKET = namedtuple("packet", ["header","val","subpackets"])
PACKET_HEADER = namedtuple("Packetheader", ["version","packet_type_id","packet_length_id"])

BITS_READ = 0

def pop_n(n):
    global BITS_READ
    BITS_READ += n
    ans = ""
    for i in range(n): ans += BIN_STR.popleft()
    return ans

def literal_packet(packet_header):
    return packet_header.packet_type_id == 4

def read_literal_value():
    val = ""
    while True:
        t = pop_n(5)
        val += t[1:]
        if t[0]=='0':
            break
    return int(val,2)

def read_length_type_id():
    return int(pop_n(1))

def parse_packet():
    header = read_header()
    subpackets = []
    val = None
    if literal_packet(header):
        val = read_literal_value()
    else:
        if header.packet_length_id == 0:
            bit_length = int(pop_n(15),2)
            target = BITS_READ + bit_length
            subpackets = []
            while BITS_READ < target:
                subpackets.append(parse_packet())
        else:
            packet_length = int(pop_n(11),2)
            subpackets = [parse_packet() for _ in range(packet_length)]

    return PACKET(header, val, subpackets)

def read_header():
    version = int(pop_n(3),2)
    packet_type_id = int(pop_n(3),2)
    packet_length_id = None
    if packet_type_id not in [4]:
        packet_length_id = int(pop_n(1),2)
    return PACKET_HEADER(version, packet_type_id, packet_length_id)

def visit(p, f):
    f(p)
    for subpacket in p.subpackets:
        visit(subpacket, f)



packet = parse_packet()

sum_version_numbers = 0
def count_version_numbers(packet):
    global sum_version_numbers
    sum_version_numbers += packet.header.version

visit( packet, count_version_numbers ) 
print(sum_version_numbers)

OP = { \
    0: 'sum',
    1: 'prod',
    2: 'min',
    3: 'max',
    5: 'gt',
    6: 'lt',
    7: 'eq'
}

STACK = []
def visitv2(p):
    global STACK
    match p.header.packet_type_id:
        case 4:
            STACK.append(p.val)
        case _:
            STACK.append( (OP[p.header.packet_type_id], len(p.subpackets)) )
            for sp in p.subpackets:
                visitv2(sp)

visitv2(packet)

def s(a,n):
    s = 0
    for _ in range(n):
        s += a.pop()
    return s

def p(a,n):
    p = 1
    for _ in range(n):
        p *= a.pop()
    return p

def mi(a,n):
    p = a[-1]
    for _ in range(n):
        p = min(a.pop(),p)
    return p

def ma(a,n):
    p = a[-1]
    for _ in range(n):
        p = max(a.pop(),p)
    return p


OP_IMPL = {
    'sum': s,
    'prod': p,
    'min': mi,
    'max': ma,
    'gt': lambda a,_: 1 if a.pop() > a.pop() else 0,
    'lt': lambda a,_: 1 if a.pop() < a.pop() else 0,
    'eq': lambda a,_: 1 if a.pop() == a.pop() else 0
}

args = deque()
while len(STACK) > 0:
    v = STACK.pop()
    if isinstance(v,tuple):
        tmp_a = copy.copy(args)
        ans = OP_IMPL[v[0]](args,v[1])
        STACK.append(ans)
    else:
        args.append(v)


print(args[0])

    



