import qualified Data.Text as Text
import qualified Data.Text.IO as Text

mapRead :: [String] -> [Int]
mapRead = map read

stripPos :: String -> String
stripPos x | '+' == head x = tail x
           | otherwise        = x

removePos :: [String] -> [String]
removePos = map stripPos

addem :: [Int] -> Int
addem = foldr (+) 0

main = do
  ls <- fmap Text.lines (Text.readFile "./inputs/day-one.txt")
  strings <- return $ removePos $ map Text.unpack ls
  nums <- return $ mapRead strings
  res <- return $ addem nums
  print res
