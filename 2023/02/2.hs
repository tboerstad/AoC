import Data.List.Split (splitOn)

parseGame :: String -> [String]
parseGame input = splitOn "; " (head $ tail $ splitOn ": " input)

updateSet :: String -> [Int] -> [Int]
updateSet str [a, b, c] =
    let [numStr, color] = splitOn " " str
        num = read numStr :: Int
    in case color of
        "blue" -> [max a num, b, c]
        "red" -> [a, max b num, c]
        "green" -> [a, b, max c num]

minimalSetForSubGame :: [Int] -> String -> [Int]
minimalSetForSubGame [a, b, c] str =
    let cubes = splitOn ", " str
    in foldl (flip updateSet) [a, b, c] cubes

isLegalGame :: [String] -> Int
isLegalGame = product
            . map isLegalSubGame
            . concatMap (splitOn ", ")

isLegalSubGame :: String -> Int
isLegalSubGame str =
    let [numStr, color] = splitOn " " str
        num = read numStr :: Int
    in case color of
        "blue" -> if num > 14 then 0 else 1
        "red" -> if num > 12 then 0 else 1
        "green" -> if num > 13 then 0 else 1

part1 :: String -> Int
part1 = sum
      . zipWith (*) [1..]
      . map (isLegalGame . parseGame)
      . lines

part2 :: String -> Int
part2 = sum
      . map ( (product . foldl minimalSetForSubGame [0, 0, 0]) . parseGame)
      . lines

main :: IO ()
main = do
    input <- readFile "input.txt"
    print (part1 input)
    print (part2 input)
