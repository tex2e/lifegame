
import std.stdio;
import std.random;
import core.thread;

void main() {
    auto lifegame = new Lifegame();
    lifegame.loop();
}

class Lifegame {
    immutable int width = 40;
    immutable int height = 20;
    int[][] field = new int[width][height];
    int[][] newField = new int[width][height];

    this() {
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                field[y][x] = cast(int) dice(0.5, 0.5);
            }
        }
    }

    void loop() {
        while (true) {
            this.clearScreen();
            this.dumpField();
            this.evolve();
            Thread.sleep( dur!"msecs"(100) );
            this.prepareNext();
        }
    }

    void evolve() {
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                int count = countAliveNeighbours(y, x);
                if (count == 2) {
                    newField[y][x] = field[y][x];
                } else if (count == 3) {
                    newField[y][x] = 1;
                } else {
                    newField[y][x] = 0;
                }
            }
        }
    }

    int countAliveNeighbours(int y, int x) const {
        int count = 0;
        for (int yi = -1; yi <= 1; yi++) {
            for (int xi = -1; xi <= 1; xi++) {
                if (xi == 0 && yi == 0) continue;
                if (field[mod(y + yi, height)][mod(x + xi, width)] != 0) count += 1;
            }
        }
        return count;
    }

    int mod(int a, int b) const {
        return (a + b) % b;
    }

    void prepareNext() {
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                field[y][x] = newField[y][x];
            }
        }
    }

    void dumpField() const {
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                write(field[y][x] == 1 ? "o" : " ");
            }
            write("\n");
        }
    }

    void clearScreen() const {
        write("\033[;H\033[2J");
    }
}
