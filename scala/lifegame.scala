
object Main {
  def main(args: Array[String]): Unit = {
    var lifegame = new Lifegame(20, 40)
    lifegame.loop()
  }
}

class Lifegame(height: Int, width: Int) {
  val rand = scala.util.Random
  var field = Array.ofDim[Int](height, width)
  for (y <- 0 to height-1; x <- 0 to width-1) {
    field(y)(x) = rand.nextInt(2)
  }

  def loop() = {
    while (true) {
      this.clearScreen
      this.dumpField
      Thread.sleep(100) // 100[ms]
      field = this.evolve
    }
  }

  def evolve(): Array[Array[Int]] = {
    var newField = Array.ofDim[Int](height, width)
    for (y <- 0 to height-1; x <- 0 to width-1) {
      newField(y)(x) =
        countAliveNeighbours(y, x) match {
          case 2 => field(y)(x)
          case 3 => 1
          case _ => 0
        }
    }
    return newField
  }

  def countAliveNeighbours(y: Int, x: Int): Int = {
    val neighbours =
      for {
        yi <- -1 to 1
        xi <- -1 to 1
        if !(yi == 0 && xi == 0)
        y_i = mod(y + yi, height)
        x_i = mod(x + xi, width)
      } yield field(y_i)(x_i)
    return neighbours.sum
  }

  def mod(a: Int, b: Int): Int = {
    if (a > 0) return a % b
    if (a < 0) return (a + b) % b
    return 0
  }

  def dumpField() = {
    for (y <- 0 to height-1) {
      for (x <- 0 to width-1) {
        print(if (field(y)(x) == 0) " " else "o" )
      }
      println()
    }
  }

  def clearScreen() = {
    print("\u001b[;H\u001b[2J")
  }
}
