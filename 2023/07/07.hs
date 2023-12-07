import Data.List.Split (splitOn)
import Data.List (group, sort, elemIndex)

data Strength = HighC | OneP | TwoP | Three | FH | Four | Five  deriving (Enum, Show, Eq, Ord)
data Hand = Hand Strength [Char] Int deriving (Show)

instance Eq Hand where
    (==) (Hand _ t1 _) (Hand _ t2 _) = t1 == t2

instance Ord Hand where
    compare (Hand t1 h1 _) (Hand t2 h2 _)
        | t1 == t2  = compareCards h1 h2
        | otherwise = compare t1 t2

compareCards :: [Char] -> [Char] -> Ordering
compareCards h1 h2 = compare (cardRanks h1) (cardRanks h2)
  where
    cardRanks = map (`elemIndex` reverse "AKQJT987654321")

applyJokers :: Strength -> Int -> Strength
applyJokers t 0 = t
applyJokers t n
    | t == Five = Five
    | t == Four = Five
    | t == FH = applyJokers Four (n-1)
    | t == Three = applyJokers Four (n-1)
    | t == TwoP = applyJokers FH (n-1)
    | t == OneP = applyJokers Three (n-1)
    | t == HighC = applyJokers OneP (n-1)

convertToJoker :: Hand -> Hand
convertToJoker (Hand _ h bid) = Hand jokerStrength replacedCards bid
    where nonJokerCards = filter (/='J') h
          numJokers = length h - length nonJokerCards
          replacedCards = map (\x -> if x == 'J' then '1' else x) h
          jokerStrength = applyJokers (handStrength nonJokerCards) numJokers

handStrength :: [Char] -> Strength
handStrength h = case repeatedGroups of
    (5:_) -> Five
    (3:2:_) -> FH
    (4:_) -> Four
    (3:_) -> Three
    (2:2:_)-> TwoP
    (2:_) -> OneP
    (1:_) -> HighC
    _ -> HighC
    where repeatedGroups = reverse . sort $ map length $ group $ sort h

parseLine :: String -> Hand
parseLine line = case splitOn " " line of
    (x : y : _) -> Hand (handStrength x) x (read y)

parseProblem :: String -> [Hand]
parseProblem = map parseLine . lines

main :: IO ()
main = do
    content <- readFile "input.txt"
    let hands = parseProblem content
    print $ sum $ zipWith (*) [1 .. ] [bid | Hand _ _ bid <- sort hands]
    print $ sum $ zipWith (*) [1 .. ] [bid | Hand _ _ bid <- sort (map convertToJoker hands)]


