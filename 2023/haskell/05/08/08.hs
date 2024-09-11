import Data.List.Split (splitOn)

parseMaps :: String -> (String, [(String, (String, String))])
parseMaps input = case splitOn "\n\n" input of
    (x : ls) ->
        let parseMapping = map (splitOn " = ") $ lines $ head ls
            srcDest = map (\[x, y] -> (x, let [a,b] = splitOn ", " y in (tail a, init b))) parseMapping
        in (x, srcDest)
    _ -> error "Invalid input"

findMapping :: String -> String -> [(String, (String, String))] -> Int -> Int
findMapping "ZZZ" _ _ steps = steps
findMapping curr instr mapping steps =
    let (src, (dest1, dest2)) = head $ filter ((== curr) . fst) mapping
        nextDest = if ( instr !! (steps `mod` length instr)) == 'L' then dest1 else dest2
    in findMapping nextDest instr mapping (steps + 1)

main :: IO ()
main = do
    content <- readFile "input.txt"
    let (instr, mapping) = parseMaps content
    print $ findMapping "AAA" instr mapping 0
