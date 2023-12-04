import Text.Parsec
import Data.List (nub)

data Card = Card { cid :: Int, winningTickets :: Tickets, myTickets :: Tickets } deriving Show
newtype Tickets = Tickets { numbers :: [Int] } deriving Show

instance Semigroup Tickets where
  (Tickets a) <> (Tickets b) = Tickets [ x | x <- a, x `elem` b ]

instance Monoid Tickets where
  mempty = Tickets []

parseCard :: String -> Card
parseCard s = case parse card "" s of
    Left err -> error (show err)
    Right g -> g
  where
    card = do
        _ <- string "Card" <* spaces
        cid <- read <$> many1 digit
        _ <- spaces >> char ':' >> spaces
        winning <- many1 (read <$> many1 digit <* spaces)
        _ <- spaces >> char '|' >> spaces
        mine <- many1 (read <$> many1 digit <* spaces)   
        return $ Card cid (Tickets $ nub winning) (Tickets $ nub mine)


combinedTickets :: Card -> Tickets
combinedTickets card = winningTickets card <> myTickets card

score :: Tickets -> Int
score tickets
  | n == 0    = 0
  | otherwise = 2 ^ (n-1)
  where n = length . numbers $ tickets

main :: IO ()
main = do
  input <- readFile "input.txt"
  let cards = map parseCard $ lines input
  print $ sum $ map (score . combinedTickets) cards
