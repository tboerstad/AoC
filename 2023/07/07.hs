import Data.List.Split (splitOn)
import Data.List (group, sort, sortBy, maximumBy, elemIndex)
import Data.Function (on)

data Type = HighC | OneP | TwoP | Three | FH | Four | Five  deriving (Enum, Show, Eq, Ord)
data Hand = Hand Type [Char] Int deriving (Show)

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

upgradeType :: Type -> Int -> Type
upgradeType t 0 = t
upgradeType t n
    | t == Five = Five
    | t == Four = Five
    | t == FH = upgradeType Four (n-1)
    | t == Three = upgradeType Four (n-1)
    | t == TwoP = upgradeType FH (n-1)
    | t == OneP = upgradeType Three (n-1)
    | t == HighC = upgradeType OneP (n-1)

convertToJoker :: Hand -> Hand
convertToJoker (Hand t h bid) = Hand (upgradeType (handType nonJokerCards) numJokers) replacedCards bid
    where nonJokerCards = filter (/='J') h
          numJokers = length h - length nonJokerCards
          replacedCards = map (\x -> if x == 'J' then '1' else x) h

handType :: [Char] -> Type
handType h = case repeatedGroups of
    [5] -> Five
    [3, 2] -> FH
    (4:_) -> Four
    (3:_) -> Three
    (2:2:_)-> TwoP
    (2:_) -> OneP
    (1:_) -> HighC
    where repeatedGroups = reverse . sort $ map length $ group $ sort h

parseLine :: String -> Hand
parseLine line = case splitOn " " line of
    (x : y : _) -> Hand (handType x) x (read y)

parseProblem :: String -> [Hand]
parseProblem = map parseLine . lines

main :: IO ()
main = do
    content <- readFile "input.txt"
    let hands = parseProblem content
    print $ sum $ zipWith (*) [1 .. ] [bid | Hand _ _ bid <- sort hands]
    print $ sum $ zipWith (*) [1 .. ] [bid | Hand _ _ bid <- sort (map convertToJoker hands)]


