
import random
import time

def main():
    field = init_field(width=40, height=20)
    while True:
        clear_screen()
        dump_field(field)
        time.sleep(0.1) # 100[ms]
        field = evolve(field)

def init_field(height, width):
    return [ [ random.randint(0, 1) for x in range(width) ] for y in range(height) ]

def evolve(field):
    height, width = len(field), len(field[0])
    new_field = [ [ dead_or_alive(field, y, x) for x in range(width) ] for y in range(height) ]
    return new_field

def dead_or_alive(field, y, x):
    alive_neighbours = count_alive_neighbours(field, y, x)
    if alive_neighbours <= 1: return 0
    if alive_neighbours == 2: return field[y][x]
    if alive_neighbours == 3: return 1
    if alive_neighbours >= 4: return 0

def count_alive_neighbours(field, y, x):
    height, width = len(field), len(field[0])
    neighbours = [ field[(y + yi) % height][(x + xi) % width]
                   for yi in [-1,0,1] for xi in [-1,0,1] if not (yi == 0 and xi == 0) ]
    return sum(neighbours)

def dump_field(field):
    height, width = len(field), len(field[0])
    char_field = [ [ ' ' if field[y][x] == 0 else 'o' for x in range(width) ] for y in range(height) ]
    lines = [ ''.join(char_field[y]) for y in range(height) ]
    print("\n".join(lines))

def clear_screen():
    print("\033[;H\033[2J")

if __name__ == '__main__':
    main()
