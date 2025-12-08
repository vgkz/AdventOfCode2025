module Main (main) where
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- convert string to int
strToInt :: String -> Int
strToInt = read

-- rotate dial to the left
left :: Int -> Int -> Int
left 0 y = y
left x 0 = left (x-1) 99
left x y = left (x-1) (y-1)

-- rotate dial to the right
right :: Int -> Int -> Int
right 0 y = y
right x 99 = right (x-1) 0
right x y = right (x-1) (y+1)

-- move dial either left or right and return new position
move :: String -> Int -> Int
move (x:xs) y | x == 'L' = left (read xs) y 
              | x == 'R' = right (read xs) y

-- walk through rotations in list of rotations
walker :: [String] -> Int -> Int -> Int
walker [] y c = c 
walker (x:xs) y c = walker xs y2 c2
                    where y2 = move x y
                          c2 = if y2 == 0
                               then c+1
                               else c

main :: IO ()
main = do
    lines <- fmap T.lines (TIO.readFile "data.txt")
    let z = map T.unpack lines
    print $ walker z 50 0

