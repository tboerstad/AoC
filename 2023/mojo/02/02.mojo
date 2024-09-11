
@value
struct Color:
    # TODO: Convert to SIMD?
    var red: Int
    var green: Int
    var blue: Int

    fn setColor(inout self, colorRepr: String) raises:
        amountAndColor = colorRepr.split(" ")
        if amountAndColor[1] == "red":
            self.red = int(amountAndColor[0])
        elif amountAndColor[1] == "green":
            self.green = int(amountAndColor[0])
        elif amountAndColor[1] == "blue":
            self.blue = int(amountAndColor[0])

    fn __gt__(self, other: Color) -> Bool:
        return self.red > other.red or self.green > other.green or self.blue > other.blue

fn fromString(colorString: String) raises -> Color:
    c = Color(0,0,0)
    for color in colorString.split(", "):
        c.setColor(color[])
    return c

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
        valid = True
        for subGame in game[]:
            if subGame[] > referenceColor:
                valid = False
        if valid:
            sum += gameId
        gameId += 1

    # Part 2
    gameId = 1
    power = 0
    for game in parsedGames:
        minColor = Color(0,0,0)
        for subGame in game[]:
            minColor.red = max(minColor.red, subGame[].red)
            minColor.green = max(minColor.green, subGame[].green)
            minColor.blue = max(minColor.blue, subGame[].blue)
        power += minColor.red * minColor.green * minColor.blue
                
 
    print(sum)
    print(power)
