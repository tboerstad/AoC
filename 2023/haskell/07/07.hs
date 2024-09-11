import Control.Arrow
import Data.List
import Data.Maybe

data HandType
    = FiveKind
    | FourKind
    | FullHouse
    | ThreeKind
    | TwoPair
    | OnePair
    | HighCard
    deriving (Ord, Eq, Show)

cards = "AKQT98765432J"

cardSort = second $ mapMaybe (`elemIndex` cards) . fst

parse = map ((head &&& read . head . tail) . words) . lines

part2 = sum . mapToValue . sortAndRank . map (handType . groupHand . fst &&& id)
    where sortAndRank = reverse . sortOn cardSort
          mapToValue = zipWith (*) [1..] . map (snd . snd)

groupHand = jokerCount &&& groups
    where groups = (++ repeat 0) . reverse . sort . map length . group . filter (/= 'J') . sort
          jokerCount = length . filter (=='J')

handType (jokers, firstGroup:secondGroup:_) =
    case jokers + firstGroup of
        5 -> FiveKind
        4 -> FourKind
        3 -> if secondGroup == 2 then FullHouse else ThreeKind
        2 -> if secondGroup == 2 then TwoPair else OnePair
        _ -> HighCard

main = readFile "ex.txt" >>= print . part2 . parse
