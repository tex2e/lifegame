
extern crate rand;

use std::{thread, time};
use rand::Rng;

const HEIGHT: usize = 20;
const WIDTH: usize = 40;

struct Lifegame {
    field: [[i32; WIDTH]; HEIGHT]
}

impl Lifegame {
    fn new() -> Lifegame {
        let mut new_field = [[0; WIDTH]; HEIGHT];
        for y in 0..HEIGHT {
            for x in 0..WIDTH {
                new_field[y][x] = rand::thread_rng().gen_range(0, 2);
            }
        }
        Lifegame { field: new_field }
    }

    fn dump_field(&self) {
        for y in 0..HEIGHT {
            for x in 0..WIDTH {
                if self.field[y][x] != 0 {
                    print!("o");
                } else {
                    print!(" ");
                }
            }
            print!("\n");
        }
    }

    fn evolve(&self) -> Lifegame {
        let mut new_field = [[0; WIDTH]; HEIGHT];
        for y in 0..HEIGHT {
            for x in 0..WIDTH {
                match Lifegame::count_alive_neighbours(&self, y, x) {
                    2 => new_field[y][x] = self.field[y][x],
                    3 => new_field[y][x] = 1,
                    _ => new_field[y][x] = 0,
                }
            }
        }
        Lifegame { field: new_field }
    }

    fn count_alive_neighbours(&self, uy: usize, ux: usize) -> i32 {
        fn modulo(a: i32, b: usize) -> usize {
            ((a + b as i32) % b as i32) as usize
        }
        let y = uy as i32;
        let x = ux as i32;
        let neighbours_pos = [
            (modulo(x-1, WIDTH), modulo(y-1, HEIGHT)),
            (modulo(x-1, WIDTH), modulo(y  , HEIGHT)),
            (modulo(x-1, WIDTH), modulo(y+1, HEIGHT)),
            (modulo(x  , WIDTH), modulo(y-1, HEIGHT)),
            (modulo(x  , WIDTH), modulo(y+1, HEIGHT)),
            (modulo(x+1, WIDTH), modulo(y-1, HEIGHT)),
            (modulo(x+1, WIDTH), modulo(y  , HEIGHT)),
            (modulo(x+1, WIDTH), modulo(y+1, HEIGHT)),
        ];
        let neighbours = neighbours_pos.iter().map(|&(x, y)| self.field[y][x]);
        neighbours.fold(0, |acc, x| acc + x)
    }
}

fn main() {
    let mut lifegame = Lifegame::new();
    loop {
        print!("{0}[;H{0}[2J", 27 as char);
        lifegame.dump_field();
        lifegame = lifegame.evolve();
        thread::sleep(time::Duration::from_millis(100));
    }
}
