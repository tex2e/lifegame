
import System.Random
import System.Posix.Unistd (usleep)
import Data.Array
import Data.List.Split (chunksOf)

type Field = Array (Int, Int) Int

main :: IO ()
main = do
  g <- getStdGen -- Gets the global random number generator.
  let height = 20
      width = 40
  lifegame $ initField height width g

lifegame :: Field -> IO ()
lifegame field = do
  clearScreen
  dumpField field
  usleep 100000
  lifegame $ evolve field

initField :: RandomGen g => Int -> Int -> g -> Field
initField height width g = field
  where randomListElem = take (width * height) $ randomRs (0::Int, 1::Int) g
        randomListIndices = [(y,x) | y<-[0..height-1], x<-[0..width-1]]
        randomList = zip randomListIndices randomListElem
        field = array ((0,0),(height-1, width-1)) randomList

evolve :: Field -> Field
evolve field = newField
  where width  = (snd $ snd $ bounds field) + 1
        height = (fst $ snd $ bounds field) + 1
        deadOrAlive field (y,x)
          | aliveNeighbours <= 1 = 0
          | aliveNeighbours == 2 = field ! (y,x)
          | aliveNeighbours == 3 = 1
          | aliveNeighbours >= 4 = 0
          where aliveNeighbours = countAliveNeighbours field (y,x)
        newField = array ((0,0),(height-1, width-1))
                         [((y,x), deadOrAlive field (y,x)) | y<-[0..height-1], x<-[0..width-1]]

countAliveNeighbours :: Field -> (Int, Int) -> Int
countAliveNeighbours field (y,x) = sum neighbours
  where width  = (snd $ snd $ bounds field) + 1
        height = (fst $ snd $ bounds field) + 1
        neighbours = [field ! (mod (y + yi) height, mod (x + xi) width) | yi<-[-1..1], xi<-[-1..1], not (xi == 0 && yi == 0)]

dumpField :: Field -> IO ()
dumpField field = putStrLn $ foldl1 join eachLines
  where width  = (snd $ snd $ bounds field) + 1
        toChar ch = if ch == 0 then ' ' else 'o'
        join a b = a ++ "\n" ++ b
        eachLines = chunksOf width $ map toChar $ elems field

clearScreen :: IO ()
clearScreen = putStrLn "\ESC[;H\ESC[2J"
