
package main

import (
    "fmt"
    "time"
    "math/rand"
)

const height = 20
const width  = 40
var field    = [height][width]int{}
var newField = [height][width]int{}

func main() {
    rand.Seed(time.Now().UTC().UnixNano())
    initField()
    for {
        clearScreen()
        dumpField()
        time.Sleep(100 * time.Millisecond)
        evolve()
        prepareNext()
    }
}

func initField() {
    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            field[y][x] = rand.Intn(2)
        }
    }
}

func evolve() {
    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            aliveNeighbours := countAliveNeighbours(y, x)
            switch {
            case aliveNeighbours <= 1: newField[y][x] = 0
            case aliveNeighbours == 2: newField[y][x] = field[y][x]
            case aliveNeighbours == 3: newField[y][x] = 1
            case aliveNeighbours >= 4: newField[y][x] = 0
            }
        }
    }
}

func countAliveNeighbours(y int, x int) int {
    count := 0
    for yi := -1; yi <= 1; yi++ {
        for xi := -1; xi <= 1; xi++ {
            if yi == 0 && xi == 0 { continue }
            if field[mod(y + yi, height)][mod(x + xi, width)] == 1 {
                count += 1
            }
        }
    }
    return count
}

func mod(a int, b int) int {
    if a > 0 { return a % b }
    if a < 0 { return (a + b) % b }
    return 0
}

func prepareNext() {
    field = newField
}

func dumpField() {
    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            if field[y][x] == 0 {
                fmt.Print(" ")
            } else {
                fmt.Print("o")
            }
        }
        fmt.Print("\n")
    }
}

func clearScreen() {
    fmt.Print("\033[;H\033[2J")
}
