
library(methods)

lifegame <- setRefClass(
  "lifegame",
  fields = list(field = "matrix", height = "numeric", width = "numeric"),
  methods = list(
    evolve = function() {
      new_field <- array(0, dim = c(height, width))
      for (y in 1:height) {
        for (x in 1:width) {
          count <- count_alive_neighbours(y, x)
          if (count == 2) {
            new_field[[y, x]] <- field[[y, x]]
          } else if (count == 3) {
            new_field[[y, x]] <- 1
          } else {
            new_field[[y, x]] <- 0
          }
        }
      }
      new_field
    },
    count_alive_neighbours = function(y, x) {
      count <- 0
      for (yi in -1:1) {
        for (xi in -1:1) {
          if (xi == 0 && yi == 0) next;
          x_i <- (x-1 + xi) %% width  + 1
          y_i <- (y-1 + yi) %% height + 1
          if (field[y_i, x_i] == 1) {
            count <- count + 1
          }
        }
      }
      return(count)
    },
    dump_field = function() {
      for (y in 1:height) {
        for (x in 1:width) {
          cat(if (field[y,x] != 0) "o" else " ")
        }
        cat("\n")
      }
    },
    clear_screen = function() {
      cat("\033[;H\033[2J")
    }
  ),
)

init_field <- function(height, width) {
  random_numbers <- sample(0:1, height * width, replace=T)
  field <- array(random_numbers, dim = c(height, width))
  return(field)
}

width = 40
height = 20
game <- lifegame(field = init_field(height, width), height = height, width = width)

repeat {
  game$clear_screen()
  game$dump_field()
  game$field <- game$evolve()
  Sys.sleep(0.1)
}
