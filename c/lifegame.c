#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#define WIDTH  40
#define HEIGHT 20

int field[HEIGHT][WIDTH];
int new_field[HEIGHT][WIDTH];

void init_field();
void prepare_next();
void evolve();
int count_alive_neighbours(int, int);
int mod(int, int);
void dump_field();
void clear_screen();

int main(int argc, char const *argv[]) {
    srandom(time(NULL));
    init_field();
    while (1) {
        clear_screen();
        dump_field();
        usleep(100000);
        evolve();
        prepare_next();
    }
    return 0;
}

void init_field() {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            field[y][x] = random() % 2;
        }
    }
}

void prepare_next() {
    memcpy(&field, &new_field, sizeof(field));
}

void evolve() {
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

int count_alive_neighbours(int y, int x) {
    int count = 0;
    int xi, yi;
    for (yi = -1; yi <= 1; yi++) {
        for (xi = -1; xi <= 1; xi++) {
            if (xi == 0 && yi == 0) continue;
            if (field[mod(y + yi, HEIGHT)][mod(x + xi, WIDTH)] == 1) {
                count++;
            }
        }
    }
    return count;
}

int mod(int a, int b) {
    if (a > 0) return a % b;
    if (a < 0) return (a + b) % b;
    return 0;
}

void dump_field() {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            printf("%c", (field[y][x] == 0) ? ' ' : 'o');
        }
        printf("\n");
    }
}

void clear_screen() {
    printf("\033[;H\033[2J");
}
