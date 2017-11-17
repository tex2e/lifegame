#!/usr/bin/env awk -f

BEGIN {
  srand()

  width = 40
  height = 20
  init_field(field, height, width)

  while (1) {
    clear_screen()
    dump_field(field)
    evolve(field, new_field)
    copy_2d_array(new_field, field)
    if (system("trap 'exit 1' 2; sleep 0.1") != 0) {
      exit
    }
  }
}

function init_field(field, height, width) {
  for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
      field[y][x] = int(101 * rand()) % 2
    }
  }
}

function copy_2d_array(from, to) {
  for (y in field) {
    for (x in field[y]) {
      to[y][x] = from[y][x]
    }
  }
}

function evolve(field, new_field) {
  for (y in field) {
    for (x in field[y]) {
      switch (count_alive_neighbours(field, y, x)) {
      case 2:
        new_field[y][x] = field[y][x]
        break
      case 3:
        new_field[y][x] = 1
        break
      default:
        new_field[y][x] = 0
        break
      }
    }
  }
}

function count_alive_neighbours(field, y, x) {
  height = length(field)
  width = length(field[0])
  count = 0
  for (yi = -1; yi <= 1; yi++) {
    for (xi = -1; xi <= 1; xi++) {
      if (yi == 0 && xi == 0) continue
      if (field[mod(y + yi, height)][mod(x + xi, width)] == 1) count += 1
    }
  }
  return count
}

function mod(a, b) {
  return (a + b) % b
}

function dump_field(field) {
  for (y in field) {
    for (x in field[y]) {
      printf "%s", (field[y][x] == 1) ? "o" : " "
    }
    printf "\n"
  }
}

function clear_screen() {
  printf "\033[;H\033[2J"
}
