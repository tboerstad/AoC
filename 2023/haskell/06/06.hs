import Data.List.Split (splitOn)

parseProblem :: String -> ([Int], [Int])
parseProblem input = case splitOn "\n" input of
    (x : y : _) -> (parseLine x, parseLine y)
    where
        parseLine = map read . tail . words

allWinningWays :: Int -> Int -> Int
allWinningWays time dist = length $ filter (>dist) [ x*(time-x) | x <- [1..time] ]

fixKerning :: [Int] -> Int
fixKerning = read . concatMap show

main :: IO ()
main = do
    content <- readFile "input.txt"
    let (times, dists) = parseProblem content
    print $ product $ zipWith allWinningWays times dists
    print $ allWinningWays (fixKerning times) (fixKerning dists)

