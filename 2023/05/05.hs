-- Credit Hungry_Mix_4263 reddit

import Data.List.Split (splitOn)
import Data.List (sortBy)

data MapItem = MapItem {dest :: Int, src :: Int, len :: Int} deriving (Show)

parseMapItem :: String -> MapItem
parseMapItem line = case map read $ words line of
    [d, s, l] -> MapItem d s l
    _ -> error "Invalid input"

parseMap :: String -> [MapItem]
parseMap = map parseMapItem . tail . lines

parseMaps :: String -> ([Int], [[MapItem]])
parseMaps input = case splitOn "\n\n" input of
    (x : ls) -> (map read $ tail $ words x, map parseMap ls)
    _ -> error "Invalid input"

passSeed :: Int -> [MapItem] -> Int
passSeed x [] = x
passSeed x (MapItem d s l : xs)
    | x < s+l && x >= s =  x - s + d
    | otherwise = passSeed x xs

createPairs :: [a] -> [(a, a)]
createPairs [] = []
createPairs (x : y : xs) = (x, y) : createPairs xs

passRange :: (Int, Int) -> [MapItem] -> [(Int, Int)]
passRange (rs, rl) [] = [(rs, rl)]
passRange (rs, rl) (MapItem d s l : xs)
    | rs <= s + l && rs + rl > s = pre ++ mid ++ post
    | otherwise = passRange (rs, rl) xs
    where
        pre = if rs < s then passRange (rs, s - rs) xs else []
        mid = [(d + max 0 (rs - s), min rl (l - max 0 (rs - s)))]
        post = if rs + rl > s + l then passRange (s + l, rs + rl - s - l) xs else []

passRanges :: [(Int, Int)] -> [MapItem] -> [(Int, Int)]
passRanges ranges maps = concatMap (`passRange` maps) ranges


main :: IO ()
main = do
    content <- readFile "input.txt"
    let (seeds, maps) =  parseMaps content
    let sortedMaps = map (sortBy (\a b -> compare (src a) (src b))) maps
    let tuples = createPairs seeds
    print $ fst $ minimum $ concatMap (\seed -> foldl passRanges [seed] sortedMaps) tuples
