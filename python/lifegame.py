
import random
import time

class Lifegame:
    def __init__(self, height, width):
        self.height = height
        self.width = width
        self.field = self.init_field(height=height, width=width)

    def init_field(self, height, width):
        return [ [ random.randint(0, 1) for x in range(width) ] for y in range(height) ]

    def loop(self):
        try:
            while True:
                self.clear_screen()
                self.dump_field()
                time.sleep(0.1) # 100[ms]
                self.field = self.evolve(self.field)
        except KeyboardInterrupt as e:
            return

    @classmethod
    def evolve(cls, field):
        height, width = len(field), len(field[0])
        new_field = [ [ cls.dead_or_alive(field, y, x) for x in range(width) ]
                      for y in range(height) ]
        return new_field

    @classmethod
    def dead_or_alive(cls, field, y, x):
        alive_neighbours = cls.count_alive_neighbours(field, y, x)
        if alive_neighbours <= 1: return 0
        if alive_neighbours == 2: return field[y][x]
        if alive_neighbours == 3: return 1
        if alive_neighbours >= 4: return 0

    @classmethod
    def count_alive_neighbours(cls, field, y, x):
        height, width = len(field), len(field[0])
        neighbours = [ field[(y + yi) % height][(x + xi) % width]
                       for yi in [-1,0,1] for xi in [-1,0,1] if not (yi == 0 and xi == 0) ]
        return sum(neighbours)

    def dump_field(self):
        char_field = [ [ ' ' if self.field[y][x] == 0 else 'o' for x in range(self.width) ]
                       for y in range(self.height) ]
        lines = [ ''.join(char_field[y]) for y in range(self.height) ]
        print("\n".join(lines))

    @classmethod
    def clear_screen(cls):
        print("\033[;H\033[2J")


if __name__ == '__main__':
    lifegame = Lifegame(height=20, width=40)
    lifegame.loop()
