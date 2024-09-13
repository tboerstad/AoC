
alias Color = SIMD[DType.int32, 4]

fn fromString(colorString: String) raises -> Color:
    c = Color()
    for substr in colorString.split(", "):
        amountAndColor = substr[].split(" ")
        if amountAndColor[1] == "red":
            c[0]= int(amountAndColor[0])
        elif amountAndColor[1] == "green":
            c[1] = int(amountAndColor[0])
        elif amountAndColor[1] == "blue":
            c[2] = int(amountAndColor[0])
    return c

@always_inline("nodebug")
fn maxsimd(lhs: Color, rhs: Color) -> Color:
    return __mlir_op.`pop.max`(lhs.value, rhs.value)

fn parseGame(game: String) raises -> List[Color]:
    colors = List[Color]()
    for colorString in game.split("; "):
        colors.append(fromString(colorString[]))
    return colors

fn validGame(game: (Int, Int, Int)) -> Bool:
    return game[0] <= 12 and game[1] <= 13 and game[2] <= 14

fn main() raises:
    with open("input.txt", "r") as f:
        lines = f.read().splitlines()
    
    sum = 0

    parsedGames = List[List[Color]]()
    for line in lines:
        gameString = line[].split(": ")[1]
        currGame = parseGame(gameString)
        parsedGames.append(currGame)


    
    # Part 1
    referenceColor = Color(12,13,14)
    gameId = 1
    for game in parsedGames:
        currMax = Color(0,0,0,0)
        for subGame in game[]:
            currMax = maxsimd(currMax, subGame[])
        if not (currMax > referenceColor).reduce_or():
            sum += gameId
        gameId += 1

    # Part 2
    power = 0
    for game in parsedGames:
        highestColor = Color(0,0,0,1)
        for subGame in game[]:
            highestColor = maxsimd(highestColor, subGame[])
        power += highestColor.reduce_mul().value
                

    print(sum)
    print(power)
