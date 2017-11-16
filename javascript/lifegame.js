
class Lifegame {
  constructor(height, width) {
    this.height = height;
    this.width = width;
    this.field = this.initField(height, width);
  }

  initField(height, width) {
    var field = [];
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (!field[y]) field[y] = [];
        field[y][x] = this.getRandomInt(1);
      }
    }
    return field;
  }

  getRandomInt(max) {
    return Math.floor(Math.random() * (max + 1));
  }

  loop() {
    this.clearScreen();
    this.dumpField(this.field);
    this.field = this.evolve(this.field);
    setTimeout(this.loop.bind(this), 100); // 100ms
  }

  evolve() {
    var field = this.field;
    var newField = [];
    for (var y = 0; y < this.height; y++) {
      for (var x = 0; x < this.width; x++) {
        if (!newField[y]) newField[y] = [];
        var aliveNeighbours = this.countAliveNeighbours(field, y, x);
        switch (aliveNeighbours) {
          case 2:  newField[y][x] = field[y][x]; break;
          case 3:  newField[y][x] = 1;           break;
          default: newField[y][x] = 0;
        }
      }
    }
    return newField;
  }

  countAliveNeighbours(field, y, x) {
    var count = 0;
    for (var yi = -1; yi <= 1; yi++) {
      for (var xi = -1; xi <= 1; xi++) {
        if (yi === 0 && xi === 0) continue;
        if (field[this.mod(y + yi, this.height)][this.mod(x + xi, this.width)] === 1) {
          count++;
        }
      }
    }
    return count;
  }

  mod(a, b) {
    return (a + b) % b;
  }

  dumpField() {
    var field = this.field;
    var lines = field.map(function (line) {
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

(function main() {
  var height = 20;
  var width  = 40;
  var lifegame = new Lifegame(height, width);
  lifegame.loop();
})();
