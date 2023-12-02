import Data.List (isPrefixOf, isSuffixOf)
import Data.Char (isDigit)


firstDigitWord :: String -> Char
firstDigitWord str
    | "one" `isPrefixOf` str = '1'
    | "two" `isPrefixOf` str = '2'
    | "three" `isPrefixOf` str = '3'
    | "four" `isPrefixOf` str = '4'
    | "five" `isPrefixOf` str = '5'
    | "six" `isPrefixOf` str = '6'
    | "seven" `isPrefixOf` str = '7'
    | "eight" `isPrefixOf` str = '8'
    | "nine" `isPrefixOf` str = '9'
    | isDigit (head str) = head str
    | otherwise = firstDigitWord (tail str)

lastDigitWord :: String -> Char
lastDigitWord str
    | "one" `isSuffixOf` str = '1'
    | "two" `isSuffixOf` str = '2'
    | "three" `isSuffixOf` str = '3'
    | "four" `isSuffixOf` str = '4'
    | "five" `isSuffixOf` str = '5'
    | "six" `isSuffixOf` str = '6'
    | "seven" `isSuffixOf` str = '7'
    | "eight" `isSuffixOf` str = '8'
    | "nine" `isSuffixOf` str = '9'
    | isDigit (last str) = last str
    | otherwise = lastDigitWord (init str)

firstDigit :: String -> Char
firstDigit = head . filter isDigit

lastDigit :: String -> Char
lastDigit = last . filter isDigit

processPartTwo :: String -> [(Char, Char)]
processPartTwo content =
  map (\line -> (firstDigitWord line, lastDigitWord line)) (lines content)

processPartOne :: String -> [(Char, Char)]
processPartOne content =
  map (\line -> (firstDigit line, lastDigit line)) (lines content)

processAndPrint :: (String -> [(Char, Char)]) -> String -> IO ()
processAndPrint processFunc content = do
  let digits = processFunc content
  let sumOfDigits = sum [read [a, b] :: Int | (a, b) <- digits]
  print sumOfDigits

main :: IO ()
main = do
  content <- readFile "input.txt"
  putStrLn "Part one: "
  processAndPrint processPartOne content
  putStrLn "Part Two: "
  processAndPrint processPartTwo content