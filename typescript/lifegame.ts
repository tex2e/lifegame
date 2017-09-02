
class Lifegame {
  field: number[][];
  constructor(private height: number, private width: number) {
    this.field = this.initField(height, width);
  }

  initField(height: number, width: number): number[][] {
    let field: number[][] = [];
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        if (!field[y]) field[y] = [];
        field[y][x] = this.getRandomInt(1);
      }
    }
    return field;
  }

  getRandomInt(max: number): number {
    return Math.floor(Math.random() * (max + 1));
  }

  loop() {
    this.clearScreen();
    this.dumpField();
    this.field = this.evolve();
    setTimeout(this.loop.bind(this), 100); // 100ms
  }

  evolve(): number[][] {
    let field   : number[][] = this.field;
    let newField: number[][] = [];
    for (let y = 0; y < this.height; y++) {
      for (let x = 0; x < this.width; x++) {
        if (!newField[y]) newField[y] = [];
        let aliveNeighbours = this.countAliveNeighbours(field, y, x);
        if (aliveNeighbours <= 1) newField[y][x] = 0;
        if (aliveNeighbours == 2) newField[y][x] = field[y][x];
        if (aliveNeighbours == 3) newField[y][x] = 1;
        if (aliveNeighbours >= 4) newField[y][x] = 0;
      }
    }
    return newField;
  }

  countAliveNeighbours(field, y, x) {
    let count = 0;
    for (let yi = -1; yi <= 1; yi++) {
      for (let xi = -1; xi <= 1; xi++) {
        if (yi === 0 && xi === 0) continue;
        if (field[this.mod(y + yi, this.height)][this.mod(x + xi, this.width)] === 1) {
          count++;
        }
      }
    }
    return count;
  }

  mod(a: number, b: number): number {
    if (a > 0) return a % b;
    if (a < 0) return (a + b) % b;
    return 0;
  }

  dumpField() {
    let field = this.field;
    let lines = field.map(function (line) {
      return line.map(function (cell) {
        return (cell === 0) ? ' ' : 'o';
      }).join('');
    });
    console.log(lines.join("\n"));
  }

  clearScreen() {
    // console.log('\033[;H\033[2J');
    console.log('\x1B[2J\x1B[0f\u001b[0;0H');
  }
}


let lifegame = new Lifegame(20, 40)
lifegame.loop()
