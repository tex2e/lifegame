
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <unistd.h>
#import <time.h>
#import <Foundation/Foundation.h>

#define WIDTH  40
#define HEIGHT 20

@interface Lifegame: NSObject
{
    int field[HEIGHT][WIDTH];
    int new_field[HEIGHT][WIDTH];
}
- (void)init_field;
- (void)prepare_next;
- (void)evolve;
- (int)count_alive_neighbours:(int)y x:(int)x;
- (int)mod:(int)a b:(int)b;
- (void)dump_field;
- (void)clear_screen;
@end

@implementation Lifegame
- (void)init_field {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            self->field[y][x] = random() % 2;
        }
    }
}
- (void)prepare_next {
    memcpy(&self->field, &self->new_field, sizeof(self->field));
}
- (void)evolve {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            int alive_neighbours = [self count_alive_neighbours:y x:x];
            if (alive_neighbours <= 1) self->new_field[y][x] = 0;
            if (alive_neighbours == 2) self->new_field[y][x] = self->field[y][x];
            if (alive_neighbours == 3) self->new_field[y][x] = 1;
            if (alive_neighbours >= 4) self->new_field[y][x] = 0;
        }
    }
}
- (int)count_alive_neighbours:(int)y x:(int)x {
    int count = 0;
    int xi, yi;
    for (yi = -1; yi <= 1; yi++) {
        for (xi = -1; xi <= 1; xi++) {
            if (xi == 0 && yi == 0) continue;
            if (self->field[ [self mod:(y + yi) b:HEIGHT] ][ [self mod:(x + xi) b:WIDTH] ] == 1) {
                count++;
            }
        }
    }
    return count;
}
- (int)mod:(int)a b:(int)b {
    if (a > 0) return a % b;
    if (a < 0) return (a + b) % b;
    return 0;
}
- (void)dump_field {
    int x, y;
    for (y = 0; y < HEIGHT; y++) {
        for (x = 0; x < WIDTH; x++) {
            printf("%c", (self->field[y][x] == 0) ? ' ' : 'o');
        }
        printf("\n");
    }
}
- (void)clear_screen {
    printf("\033[;H\033[2J");
}
@end

int main(int argc, const char *argv[]) {
    srandom(time(NULL));
    id lifegame = [Lifegame alloc];
    [lifegame init_field];
    while (1) {
        [lifegame clear_screen];
        [lifegame dump_field];
        usleep(100000);
        [lifegame evolve];
        [lifegame prepare_next];
    }
    return 0;
}
