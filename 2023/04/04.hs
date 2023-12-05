-- credit niccolomarcon reddit

import Control.Arrow (second, (&&&))
import Data.List (intersect)
import Data.Tuple.Extra (both)

main :: IO ()
main = do
  input <- readFile "ex.txt"
  print $ map parse . lines $ input

part1 :: [([Int], [Int])] -> Int
part1 = sum . map ((\n -> if n >= 1 then 2 ^ (n - 1) else 0) . countMatches)

part2 :: [([Int], [Int])] -> [Int]
part2 = foldr (\c l -> 1 + sum (take (countMatches c) l) : l) []

countMatches :: ([Int], [Int]) -> Int
countMatches = length . uncurry intersect

parse :: String -> ([Int], [Int])
parse = both (map read) . second tail . span (/= "|") . drop 2 . words
