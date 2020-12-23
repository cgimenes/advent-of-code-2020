import System.IO
import Data.List

type Units = Int

data Turns = OneTurn | TwoTurns | ThreeTurns deriving (Show)

data Direction = North | South | East | West | Forward | Left | Right deriving (Show)

data Coordinates = Coordinates { x ::Units
                               , y :: Units
                               } deriving (Show)

data Ship = Ship { direction :: Direction
                 , shipCoordinates :: Coordinates
                 } deriving (Show)

data Waypoint = Waypoint { ship :: Ship
                         , waypointCoordinates :: Coordinates
                         } deriving (Show)

data Action = Move Direction Units | Rotate Direction Turns deriving (Show)

initialShip = Ship East (Coordinates 0 0)

initialWaypoint = Waypoint initialShip (Coordinates 10 1)

main = do  
    handle <- openFile "input" ReadMode
    contents <- hGetContents handle
    print $ "Part 1: " ++ show (part1 $ lines contents)
    print $ "Part 2: " ++ show (part2 $ lines contents)
    hClose handle 

turns :: Units -> Turns
turns 90 = OneTurn
turns 180 = TwoTurns
turns 270 = ThreeTurns
turns _ = error "Invalid turn"

rotate :: Direction -> Action -> Direction
rotate North (Rotate Main.Left OneTurn) = West
rotate North (Rotate Main.Right OneTurn) = rotate North (Rotate Main.Left ThreeTurns)

rotate South (Rotate Main.Left OneTurn) = East
rotate South (Rotate Main.Right OneTurn) = rotate South (Rotate Main.Left ThreeTurns)

rotate East (Rotate Main.Left OneTurn) = North
rotate East (Rotate Main.Right OneTurn) = rotate East (Rotate Main.Left ThreeTurns)

rotate West (Rotate Main.Left OneTurn) = South
rotate West (Rotate Main.Right OneTurn) = rotate West (Rotate Main.Left ThreeTurns) 

rotate d (Rotate rd TwoTurns) = iterate (\x -> rotate x (Rotate rd OneTurn)) d !! 2
rotate d (Rotate rd ThreeTurns) = iterate (\x -> rotate x (Rotate rd OneTurn)) d !! 3

rotate' :: Coordinates -> Action -> Coordinates
rotate' (Coordinates x y) (Rotate Main.Left OneTurn) = Coordinates (negate y) x
rotate' (Coordinates x y) (Rotate Main.Right OneTurn) = Coordinates y (negate x)
rotate' (Coordinates x y) (Rotate _ TwoTurns) = Coordinates (negate x) (negate y)
rotate' c@(Coordinates x y) (Rotate Main.Left ThreeTurns) = rotate' c (Rotate Main.Right OneTurn)
rotate' c@(Coordinates x y) (Rotate Main.Right ThreeTurns) = rotate' c (Rotate Main.Left OneTurn)

parseDirection :: Char -> Direction
parseDirection 'N' = North
parseDirection 'S' = South
parseDirection 'E' = East
parseDirection 'W' = West
parseDirection 'F' = Forward
parseDirection 'L' = Main.Left
parseDirection 'R' = Main.Right
parseDirection _ = error "Invalid direction"

move :: Ship -> Action -> Ship
move (Ship d c) a@(Rotate _ _) = Ship (rotate d a) c
move (Ship d (Coordinates x y)) (Move North u) = Ship d (Coordinates x (y + u))
move (Ship d (Coordinates x y)) (Move South u) = Ship d (Coordinates x (y - u))
move (Ship d (Coordinates x y)) (Move East u) = Ship d (Coordinates (x + u) y)
move (Ship d (Coordinates x y)) (Move West u) = Ship d (Coordinates (x - u) y)
move s@(Ship d _) (Move Forward u) = move s (Move d u)

move' :: Waypoint -> Action -> Waypoint
move' (Waypoint (Ship d (Coordinates sx sy)) wc@(Coordinates wx wy)) (Move Forward u) = Waypoint (Ship d (Coordinates (sx + (wx * u)) (sy + (wy * u)))) wc
move' (Waypoint s (Coordinates wx wy)) (Move North u) = Waypoint s (Coordinates wx (wy + u))
move' (Waypoint s (Coordinates wx wy)) (Move South u) = Waypoint s (Coordinates wx (wy - u))
move' (Waypoint s (Coordinates wx wy)) (Move East u) = Waypoint s (Coordinates (wx + u) wy)
move' (Waypoint s (Coordinates wx wy)) (Move West u) = Waypoint s (Coordinates (wx - u) wy)
move' (Waypoint s c) a@(Rotate _ _) = Waypoint s (rotate' c a)

manhattanDistance :: Coordinates -> Int
manhattanDistance (Coordinates x y) = abs x + abs y

parseActions :: [String] -> [Action]
parseActions = map parseAction
    where
        parseAction :: String -> Action
        parseAction (x:xs) = action (parseDirection x) (read xs :: Units)

        action :: Direction -> Units -> Action
        action North u = Move North u
        action South u = Move South u
        action East u = Move East u
        action West u = Move West u
        action Forward u = Move Forward u
        action Main.Left u = Rotate Main.Left (turns u)
        action Main.Right u = Rotate Main.Right (turns u)

part1 :: [String] -> Int
part1 ls = manhattanDistance $ shipCoordinates lastPos
    where
        actions = parseActions ls
        lastPos = foldl move initialShip actions

part2 :: [String] -> Int
part2 ls = manhattanDistance $ shipCoordinates $ ship lastPos
    where
        actions = parseActions ls
        lastPos = foldl move' initialWaypoint actions