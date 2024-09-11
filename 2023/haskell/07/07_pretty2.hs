import Data.List
import Control.Arrow ((***), (&&&))

main = do
  txt <- readFile "ex.txt"
  putStrLn (" part 1 = " ++ show (solve1 txt))
  putStrLn (" part 2 = " ++ show (solve2 txt))

solve1 = sum . zipWith (*) [1..] . map snd . sortOn ((handValue &&& map (`elemIndex` "23456789TJQKA")) . fst) . parse
  where handValue = reverse . sort . map length . group . sort

solve2 = sum . zipWith (*) [1..] . map snd . sortOn ((handValue &&& map (`elemIndex` "J23456789TQKA")) . fst) . parse
  where handValue = (\(j,cs) -> case cs of [] -> [j]; c:cs -> c+j:cs)
                    . (length *** reverse . sort . map length . group . sort)
                    . partition (=='J')

parse :: String -> [([Char], Int)]
parse = map ((head &&& read . last) . words) . lines
