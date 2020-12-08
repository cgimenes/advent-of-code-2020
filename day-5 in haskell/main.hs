import System.IO
import Data.List

main = do  
    handle <- openFile "input" ReadMode
    contents <- hGetContents handle
    print $ "Part 1: " ++ show (part1 $ lines contents)
    print $ "Part 2: " ++ show (part2 $ lines contents)
    hClose handle 

seatToId :: [Char] -> Int
seatToId s = seatCoordToSeatId (seatRow s) (seatColumn s)

seatRow :: [Char] -> Int
seatRow s = rowNumber 0 (take 7 s)
    where
        rowNumber n [] = n
        rowNumber n ('F':xs) = rowNumber n xs
        rowNumber n ('B':xs) = rowNumber (n + 2 ^ length xs) xs

seatColumn :: [Char] -> Int
seatColumn s = columnNumber 0 (drop 7 s)
    where
        columnNumber n [] = n
        columnNumber n ('L':xs) = columnNumber n xs
        columnNumber n ('R':xs) = columnNumber (n + 2 ^ length xs) xs

seatCoordToSeatId :: Int -> Int -> Int
seatCoordToSeatId r c = r * 8 + c

part1 :: [String] -> Int
part1 ls = maximum $ map seatToId ls

part2 :: [String] -> Int
part2 ls = findSeat $ sort $ map seatToId ls
    where
        findSeat (f:y@(s:xs))
            | f + 1 == s = findSeat y
            | f + 2 == s = f + 1
            | otherwise = error "Seat not found"