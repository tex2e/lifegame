
import java.util.Random;
import java.util.Arrays;
import java.util.stream.Stream;
import java.util.stream.IntStream;
import java.util.stream.Collectors;

public class Lifegame {
    public int width;
    public int height;
    public int[][] field = new int[height][width];

    public Lifegame(int height, int width) {
        this.height = height;
        this.width = width;
        this.field = initField(height, width);
    }

    public int[][] initField(int height, int width) {
        Random randomGen = new Random();
        int[][] field = new int[height][width];
        IntStream.range(0, height).forEach(y ->
            IntStream.range(0, width).forEach(x ->
                field[y][x] = randomGen.nextInt(2)));
        return field;
    }

    public void loop() {
        try {
            while (true) {
                clearScreen();
                dumpField();
                Thread.sleep(100);
                this.field = evolve(this.field);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    public int[][] evolve(int[][] field) {
        int[][] newField = new int[this.height][this.width];
        IntStream.range(0, this.height).forEach(y ->
            IntStream.range(0, this.width).forEach(x ->
                newField[y][x] = deadOrAlive(field, y, x)));
        return newField;
    }

    public int deadOrAlive(int[][] field, int y, int x) {
        int aliveNeighbours = countAliveNeighbours(field, y, x);
        if (aliveNeighbours <= 1) return 0;
        if (aliveNeighbours == 2) return field[y][x];
        if (aliveNeighbours == 3) return 1;
        if (aliveNeighbours >= 4) return 0;
        return 0;
    }

    public int countAliveNeighbours(int[][] field, int y, int x) {
        return Stream.of(new Point(-1, -1), new Point(-1, 0), new Point(-1, 1),
                         new Point( 0, -1),                   new Point( 0, 1),
                         new Point( 1, -1), new Point( 1, 0), new Point( 1, 1))
                     .mapToInt(point -> field[mod(y + point.y, height)][mod(x + point.x, width)])
                     .sum();
    }

    private int mod(int a, int b) {
        if (a > 0) return a % b;
        if (a < 0) return (a + b) % b;
        return 0;
    }

    public void dumpField() {
        Arrays.stream(this.field)
              .map(line -> Arrays.stream(line)
                                 .mapToObj(cell -> (cell == 0) ? " " : "o")
                                 .collect(Collectors.joining("")))
              .forEach(System.out::println);
    }

    public void clearScreen() {
        System.out.print("\033[;H\033[2J");
    }
}

class Point {
    public int x;
    public int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
}
