from functools import reduce, partial

input_data = [*open("input.txt")]

def one_is_most_common(x, tie):
    if len(x) == 1:
        return x[0]==tie
    return sum(x) >= len(x)/2

def append_most_common_digit(ans, bit_index, digit):
    bit_list = [int(input_line[bit_index]) for input_line in input_data]
    return ans + (str(digit) if one_is_most_common(bit_list, digit) else str(1-digit))

def append_most_common_subdigit(ans, bit_index, digit):
    bit_list = [int(input_line[bit_index]) for input_line in input_data if input_line[:len(ans)]==ans]
    return ans + (str(digit) if one_is_most_common(bit_list, digit) else str(1-digit))

N=range(len(input_data[0])-1)
gamma = reduce(partial(append_most_common_digit,digit=1),N,"")
epsilon = reduce(partial(append_most_common_digit,digit=0),N,"")
print(int(gamma,2)*int(epsilon,2))

oxygen = reduce(partial(append_most_common_subdigit,digit=1),N,"")
co2 = reduce(partial(append_most_common_subdigit,digit=0),N,"")
print(int(oxygen,2)*int(co2,2))
