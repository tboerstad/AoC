input_data = open("input.txt").read().splitlines()

NUMBERS = list(map(int,input_data[0].split(',')))
BOARDS = [int(x) for line in input_data[2:] if line != '' for x in line.split(' ') if x != '' ]
BOARDS = [BOARDS[x:x+25] for x in range(0,len(BOARDS),25)]

def check_bingo(board, numbers):
    rows = [board[x:x+5] for x in range(0, len(board),5)]
    columns = [board[x::5] for x in range(0, len(board)//5)]
    for candidate in rows+columns:
        if all(c in numbers for c in candidate):
            return True
    return False

def umarked_sum(board, numbers):
    for n in numbers:
        if n in board:
            board.remove(n)
    return sum(board)

first_bingo = True
for i in range(len(NUMBERS)):
    for board in BOARDS:
        if check_bingo(board,NUMBERS[0:i+1]):
            if first_bingo:
                print(umarked_sum(board,NUMBERS[0:i+1])*NUMBERS[i])
                first_bingo = False
            BOARDS.remove(board)
            if len(BOARDS)==0:
                print(umarked_sum(board,NUMBERS[0:i+1])*NUMBERS[i])




