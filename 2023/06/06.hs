import Data.List.Split (splitOn)

parseProblem :: String -> ([Int], [Int])
parseProblem input = case splitOn "\n" input of
    (x : y : _) -> (parseLine x, parseLine y)
    where
        parseLine = map read . tail . words

computeAllSolutions :: Int -> Int -> [Int]
computeAllSolutions 0 _ = [0]
computeAllSolutions time speed =  time*speed : computeAllSolutions (time-1) (speed+1)

part1 :: ([Int], [Int]) -> Int
part1 = product . map length . uncurry (zipWith (\time dist -> filter (>dist) (computeAllSolutions time 0)))

fixKerning :: [Int] -> Int
fixKerning = read . concatMap show

main :: IO ()
main = do
    content <- readFile "input.txt"
    let (times, dists) = parseProblem content
    print $ part1 (times, dists)
    print $ part1 ([fixKerning times],[fixKerning dists])

