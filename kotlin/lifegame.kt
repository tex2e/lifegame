
import java.util.Random

fun main(args: Array<String>) {
    val height = 20
    val width  = 40
    var field  = initField(height, width)
    while (true) {
        clearScreen()
        dumpField(field)
        Thread.sleep(100)
        field = evolve(field)
    }
}

fun initField(height: Int, width: Int): Array<Array<Int>> {
    val random = Random()
    return Array(height) { Array(width) { random.nextInt(2) } }
}

fun evolve(field: Array<Array<Int>>): Array<Array<Int>> {
    val height = field.size
    val width  = field[0].size
    var newField = Array(height) { Array(width) { 0 } }
    for (y in 0 until height) {
        for (x in 0 until width) {
            val aliveNeighbours = countAliveNeighbours(field, y, x)
            newField[y][x] = when (aliveNeighbours) {
                2 -> field[y][x]
                3 -> 1
                else -> 0
            }
        }
    }
    return newField
}

fun countAliveNeighbours(field: Array<Array<Int>>, y: Int, x: Int): Int {
    var count = 0
    val height = field.size
    val width  = field[0].size
    for (yi in -1..1) {
        for (xi in -1..1) {
            if (yi == 0 && xi == 0) continue
            if (field[mod(y + yi, height)][mod(x + xi, width)] == 1) {
                count += 1
            }
        }
    }
    return count
}

fun mod(a: Int, b: Int): Int {
    if (a > 0) return a % b
    if (a < 0) return (a + b) % b
    return 0
}

fun dumpField(field: Array<Array<Int>>) {
    for (line in field) {
        for (element in line) {
            if (element == 0) {
                print(" ")
            } else {
                print("o")
            }
        }
        print("\n")
    }
}

fun clearScreen() {
    print("\u001Bc")
}
