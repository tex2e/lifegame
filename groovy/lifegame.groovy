
import java.util.Random
import java.util.Arrays
import java.util.stream.Stream
import java.util.stream.IntStream
import java.util.stream.Collectors

public class Lifegame {
    public int width
    public int height
    public int[][] field = new int[height][width]

    public Lifegame(int height, int width) {
        this.height = height
        this.width = width
        this.field = initField(height, width)
    }

    public int[][] initField(int height, int width) {
        Random randomGen = new Random()
        int[][] field = new int[height][width]
        IntStream.range(0, height).forEach({y ->
            IntStream.range(0, width).forEach({x ->
                field[y][x] = randomGen.nextInt(2) }) })
        return field
    }

    public void loop() {
        try {
            while (true) {
                clearScreen()
                dumpField()
                Thread.sleep(100)
                this.field = evolve(this.field)
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt()
        }
    }

    public int[][] evolve(int[][] field) {
        int[][] newField = new int[this.height][this.width]
        IntStream.range(0, this.height).forEach({y ->
            IntStream.range(0, this.width).forEach({x ->
                newField[y][x] = deadOrAlive(field, y, x) }) })
        return newField
    }

    public int deadOrAlive(int[][] field, int y, int x) {
        switch (countAliveNeighbours(field, y, x)) {
            case 2:  return field[y][x]
            case 3:  return 1
            default: return 0
        }
    }

    public int countAliveNeighbours(int[][] field, int y, int x) {
        return Stream.of(new Point(-1, -1), new Point(-1, 0), new Point(-1, 1),
                         new Point( 0, -1),                   new Point( 0, 1),
                         new Point( 1, -1), new Point( 1, 0), new Point( 1, 1))
                     .mapToInt({ point -> field[mod(y + point.y, height)][mod(x + point.x, width)] })
                     .sum()
    }

    private int mod(int a, int b) {
        return (a + b) % b
    }

    public void dumpField() {
        Arrays.stream(this.field)
              .map({line -> Arrays.stream(line)
                                  .mapToObj({ cell -> (cell == 0) ? " " : "o" })
                                  .collect(Collectors.joining("")) })
              .forEach({ println it })
    }

    public void clearScreen() {
        print("\033[H\033[2J")
    }

    class Point {
        public int x
        public int y

        public Point(int x, int y) {
            this.x = x
            this.y = y
        }
    }
}

int height = 20
int width  = 40
def lifegame = new Lifegame(height, width)
lifegame.loop()
