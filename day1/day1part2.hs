module Main (main) where
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- convert string to int
strToInt :: String -> Int
strToInt = read

-- f increments by 1, if 100 cycle back to 0, if -1 cycle back to 99
turn :: (Int -> Int) -> Int -> Int
turn f x | f x == 100 = 0
         | f x == -1 = 99
         | otherwise = f x

-- return 1 if 0, else 0
detect0 :: Int -> Int
detect0 x = if x == 0
            then 1
            else 0

-- turn dial in direction determined by f
turnCycle :: (Int -> Int) -> Int -> Int -> (Int, Int)
turnCycle f nturns pos = turnHelper (turn f) nturns pos 0
                         where turnHelper :: (Int -> Int) -> Int -> Int -> Int -> (Int, Int)
                               turnHelper g 0 pos count = (pos, count)
                               turnHelper g nturns pos count = turnHelper g (nturns-1) (g pos) (count + detect0 pos) 

-- move dial either left or right and return new position
move :: String -> Int -> (Int, Int)
move (x:xs) y | x == 'L' = turnCycle (subtract 1) (read xs) y 
              | x == 'R' = turnCycle (+1) (read xs) y

-- walk through rotations in list of rotations
walker :: [String] -> Int -> Int -> Int
walker [] y c = c + detect0 y 
walker (x:xs) y c = walker xs y2 (c+c2)
                    where (y2, c2) = move x y

main :: IO ()
main = do
    lines <- fmap T.lines (TIO.readFile "data.txt")
    let z = map T.unpack lines
    print $ walker z 50 0
