import Data.Matrix
import Data.Char (isDigit)
import Data.Maybe (catMaybes)
import Data.List (mapAccumL)

extractNumbers :: String -> [(Int, Int, Int)]
extractNumbers str = catMaybes $ snd $ mapAccumL processChar (Nothing, 0) (zip (str ++ " ") [1..])
  where
    processChar (mStart, len) (c, idx) 
      | isDigit c = case mStart of
                     Just start -> ((Just start, len + 1), Nothing)
                     Nothing    -> ((Just idx, 1), Nothing)
      | otherwise = case mStart of
                     Just start -> ((Nothing, 0), Just (start, start + len - 1, readNumber start len))
                     Nothing    -> ((Nothing, 0), Nothing)
    
    readNumber start len = read (take len $ drop (start - 1) str) :: Int

data PartNumber = Range {
    row :: Int,
    startCol :: Int,
    endCol :: Int,
    number :: Int
} deriving (Show)

extractPartNumbers :: String -> Int -> [PartNumber]
extractPartNumbers line rowNum = map toPartNumber $ extractNumbers line
  where
    toPartNumber (start, end, num) = Range rowNum start end num

extractGearPositions :: String -> Int -> [PartNumber]
extractGearPositions line rowNum = 
    [Range rowNum col col 0 | (char, col) <- zip line [1..], char == '*']

gearRatio :: PartNumber -> [PartNumber] -> Int
gearRatio gearPosition partNumbers =
    case filter isNeighbour partNumbers of
        n1:n2:_ -> number n1 * number n2
        _       -> 0
  where
    isNeighbour partNumber =
        let rowInRange = abs (row partNumber - row gearPosition) <= 1
            colInRange = any (\col -> abs (col - startCol gearPosition) <= 1) [startCol partNumber .. endCol partNumber]
        in rowInRange && colInRange

isValidPartNumber :: PartNumber -> Matrix Char -> Bool
isValidPartNumber partNumber mat =
    any (isSymbolAtPos mat) adjacentPositions
  where
    adjacentPositions = [(r, c) | r <- [row partNumber - 1, row partNumber, row partNumber + 1],
                                  c <- [startCol partNumber - 1 .. endCol partNumber + 1]]

validSymbol :: Char -> Bool
validSymbol c = not (isDigit c || c == '.')

isSymbolAtPos :: Matrix Char -> (Int, Int) -> Bool
isSymbolAtPos mat (row, col)
    | outOfBounds = False
    | otherwise   = validSymbol charAtPosition
    where
      rows = nrows mat
      cols = ncols mat
      outOfBounds = row < 1 || row > rows || col < 1 || col > cols
      charAtPosition = getElem row col mat

main :: IO ()
main = do
    input <- readFile "input.txt"
    let inputList = lines input

    let mat = fromLists $ map (concatMap (:[])) inputList

    let partNumbers = concat $ zipWith extractPartNumbers inputList [1..]
    let validPartNumbers = filter (`isValidPartNumber` mat) partNumbers
    print $ sum $ map number validPartNumbers

    let gears = concat $ zipWith extractGearPositions inputList [1..]
    let sumGearRatioValues = sum $ map (`gearRatio` validPartNumbers) gears
    print sumGearRatioValues
