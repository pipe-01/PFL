import Data.Char
import Distribution.Simple.Command (commandParseArgs)
import Text.XHtml (clear)

--2.1
data BigNumber = Pos [Int]
                |Neg [Int]
                deriving (Eq, Show)

--2.2
isNeg :: String -> String
isNeg xs = if head xs == '-' then drop 1 xs else xs

checkSignal :: String -> Bool
checkSignal xs = if head xs == '-' then True else False

scanner :: String -> BigNumber
scanner xs = if checkSignal xs then Neg (reverse (map digitToInt (isNeg xs))) else Pos (reverse (map digitToInt (isNeg xs)))

--2.3
output :: BigNumber -> String 
output (Pos x) = map intToDigit (reverse x)
output (Neg x) =  "-" ++ map intToDigit (reverse x)


--2.4
auxSoma :: Int -> [Int] -> [Int] -> [Int]
auxSoma 0 [] [] = []
auxSoma n [] [] = [n]
auxSoma n xs [] = auxSoma n xs [0]
auxSoma n [] xs = auxSoma n [0] xs
auxSoma n (x:xs) (y:ys) = r : auxSoma q xs ys
    where (q,r) = quotRem (x+y+n) 10

-- change Num to Integral because we need to work with integers
sub :: (Integral a) => [a] -> [a] -> a -> [a]
--        we need to sub a carry now ^
-- these base cases break down if carry is non-zero
sub [] x c
    -- if carry is zero we're fine
    | c == 0    = x
    -- just sub the carry in as a digit
    | otherwise = sub [c] x 0
-- same applies here
sub x [] c
    | c == 0    = x
    | otherwise = sub x [c] 0
sub (x:xs) (y:ys) c = dig : sub xs ys rst
    where sum = if x >= y then x - y - c else (x+10) - y - c --x + y + c    -- find the sum of the digits plus the carry
          -- these two lines can also be written as (rst, dig) = sum `divMod` 10
          dig = sum `mod` 10 -- get the last digit
          rst = if x >= y then 0 else 1 -- get the rest of the digits (the new carry)

sumList :: [Int] -> [Int] -> [Int]
sumList = auxSoma 0

subList :: [Int] -> [Int] -> [Int]
subList x y = sub x y 0

compareList :: [Int] -> [Int] -> Bool 
compareList (x:xs) (y:ys) | x == y = compareList xs ys 
                          | x > y = True 
                          |otherwise = False

clearZero :: [Int] -> [Int]
clearZero xs = if last xs == 0 then take (length xs - 1) xs else xs 

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN (Neg x) (Neg y) = Neg (sumList (reverse x) (reverse y))
somaBN (Neg x) (Pos y) = if length x > length y || length x == length y && compareList x y then Neg (clearZero (subList (reverse x) (reverse y))) else Pos (clearZero(sumList (reverse x) (reverse y)))
somaBN (Pos x) (Neg y) = if length x > length y || length x == length y && compareList x y then Pos (clearZero(subList (reverse x) (reverse y))) else Neg (clearZero(sumList (reverse x) (reverse y)))
somaBN (Pos x) (Pos y) = Pos (sumList (reverse x) (reverse y))



--2.5
subBN :: BigNumber -> BigNumber -> BigNumber
subBN (Neg x) (Neg y) = if length x > length y || length x == length y && compareList x y then Neg (clearZero (sumList (reverse x) (reverse y))) else Pos (clearZero(subList (reverse x) (reverse y)))
subBN (Neg x) (Pos y) =  Neg (sumList (reverse x) (reverse y))
subBN (Pos x) (Neg y) = Pos (sumList (reverse x) (reverse y))
subBN (Pos x) (Pos y) = if length x > length y || length x == length y && compareList x y then Pos (clearZero(subList (reverse x) (reverse y))) else Neg (clearZero(sumList (reverse x) (reverse y)))