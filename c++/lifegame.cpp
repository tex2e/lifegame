
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#define WIDTH  40
#define HEIGHT 20

class Lifegame {
    int field[HEIGHT][WIDTH];
    int new_field[HEIGHT][WIDTH];
public:
    Lifegame();
    void prepare_next();
    void loop();
    void evolve();
    int count_alive_neighbours(int, int);
    void dump_field();
    void clear_screen();
private:
    int mod(int, int);
};

Lifegame::Lifegame() {
    for (size_t y = 0; y < HEIGHT; y++) {
        for (size_t x = 0; x < WIDTH; x++) {
            field[y][x] = random() % 2;
        }
    }
}

void Lifegame::prepare_next() {
    memcpy(&field, &new_field, sizeof(field));
}

void Lifegame::loop() {
    while (1) {
        clear_screen();
        dump_field();
        usleep(100000);
        evolve();
        prepare_next();
    }
}

void Lifegame::evolve() {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            switch (count_alive_neighbours(y, x)) {
                case 2:  new_field[y][x] = field[y][x]; break;
                case 3:  new_field[y][x] = 1;           break;
                default: new_field[y][x] = 0;
            }
        }
    }
}

int Lifegame::count_alive_neighbours(int y, int x) {
    int count = 0;
    for (int yi = -1; yi <= 1; yi++) {
        for (int xi = -1; xi <= 1; xi++) {
            if (xi == 0 && yi == 0) continue;
            if (field[mod(y + yi, HEIGHT)][mod(x + xi, WIDTH)] == 1) {
                count++;
            }
        }
    }
    return count;
}

int Lifegame::mod(int a, int b) {
    return (a + b) % b;
}

void Lifegame::dump_field() {
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            printf("%c", (field[y][x] == 0) ? ' ' : 'o');
        }
        printf("\n");
    }
}

void Lifegame::clear_screen() {
    printf("\033[;H\033[2J");
}

int main(int argc, char const *argv[]) {
    srandom(time(NULL));
    Lifegame lifegame;
    lifegame.loop();
    return 0;
}
