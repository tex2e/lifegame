
import Foundation

class Lifegame {
    let height: Int
    let width: Int
    var field: Array<Array<Int>>

    init(height: Int, width: Int) {
        self.height = height
        self.width  = width
        self.field = Array(repeating: Array(repeating: 0, count: width), count: height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                self.field[y][x] = self.random(max: 2)
            }
        }
    }

    func random(max maxNumber: Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxNumber)))
    }

    func loop() {
        while true {
            clearScreen()
            dumpField()
            usleep(100000)
            self.field = evolve()
        }
    }

    func evolve() -> Array<Array<Int>> {
        var newField: Array<Array<Int>> =
            Array(repeating: Array(repeating: 0, count: width), count: height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let aliveNeighbours = countAliveNeighbours(y: y, x: x)
                if aliveNeighbours <= 1 { newField[y][x] = 0 }
                if aliveNeighbours == 2 { newField[y][x] = field[y][x] }
                if aliveNeighbours == 3 { newField[y][x] = 1 }
                if aliveNeighbours >= 4 { newField[y][x] = 0 }
            }
        }
        return newField
    }

    func countAliveNeighbours(y: Int, x: Int) -> Int {
        var count = 0
        for yi in -1 ... 1 {
            for xi in -1 ... 1 {
                if yi == 0 && xi == 0 { continue }
                if field[mod(y + yi, divBy: height)][mod(x + xi, divBy: width)] == 1 {
                    count += 1
                }
            }
        }
        return count
    }

    func mod(_ a: Int, divBy b: Int) -> Int {
        if a > 0 { return a % b }
        if a < 0 { return (a + b) % b }
        return 0
    }

    func dumpField() {
        for y in 0 ..< height {
            for x in 0 ..< width {
                print((field[y][x] == 0) ? " " : "o", terminator: "")
            }
            print() // puts new line
        }
    }

    func clearScreen() {
        print("\u{001B}[;H\u{001B}[2J")
    }
}

var lifegame = Lifegame(height: 20, width: 40)
lifegame.loop()
