
fn convertToDigits(x: String) -> String:
    ans = String()
    writtenDigits = List[String, 0]("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
    for i in range(len(x)):
        if x[i].isdigit():
            ans += x[i]
            continue
        for writtenDigitIdx in range(len(writtenDigits)):
            curr = writtenDigits[writtenDigitIdx]
            if x[i:].startswith(curr):
                ans += str(writtenDigitIdx+1)
    return ans


fn findDigits(x: String) -> String:
    digits = String()
    for char in x:
        if char in String("0123456789"):
            digits += char
    return digits

fn main() raises:
    with open("input.txt", "r") as f:
        lines = f.read().splitlines()
    
    sum = 0
    for line in lines:
        digits = findDigits(line[])
        sum += int(digits[0] + digits[-1])
    print(sum)

    sum = 0
    for line in lines:
        digits = findDigits(convertToDigits(line[]))
        sum += int(digits[0] + digits[-1])
    print(sum)