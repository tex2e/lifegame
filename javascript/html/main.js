
// JavaScriptでライフゲームを作成する - Qiita (by @gushwell)
// https://qiita.com/gushwell/items/ed7f4039e5c240a387ff


class MyCanvas {
  constructor(id, width, height) {
    this.cellsize = 4;
    this.canvas = document.getElementById(id);
    this.ctx = this.canvas.getContext('2d');
    if (width) {
      this.ctx.canvas.width = width * this.cellsize;
    }
    if (height) {
      this.ctx.canvas.height = height * this.cellsize;
    }
    this.width = this.ctx.canvas.width;
    this.height = this.ctx.canvas.height;
    this.clearAll();

    this.onClick = function (x, y) { };
    this.onMouseDown = function (x, y) { };
    this.onMouseMove = function (x, y) { };
    this.onMouseUp = function (x, y) { };

    this.canvas.onclick = (e) => {
      var pt = this.getPoint(e)
      this.onClick(pt.x, pt.y);
    };

    this.canvas.onmousedown = (e) => {
      var pt = this.getPoint(e)
      this.onMouseDown(pt.x, pt.y, e.shiftKey);
    };

    this.canvas.onmousemove = (e) => {
      var pt = this.getPoint(e)
      this.onMouseMove(pt.x, pt.y, e.shiftKey);
    };

    this.canvas.onmouseup = (e) => {
      var pt = this.getPoint(e)
      this.onMouseUp(pt.x, pt.y, e.shiftKey);
    };
  }

  getPoint(e) {
    var rect = e.target.getBoundingClientRect();
    var x = e.clientX - Math.floor(rect.left);
    var y = e.clientY - Math.floor(rect.top);
    x = Math.floor(x / this.cellsize);
    y = Math.floor(y / this.cellsize);
    return { x: x, y: y };
  }

  // 点を打つ
  drawPoint(x, y, color) {
    this.ctx.fillStyle = color;
    this.ctx.fillRect(x * this.cellsize + 1, y * this.cellsize + 1, 
                      this.cellsize - 1, this.cellsize - 1);
  }

  // 縦罫線
  drawVRuleLine(x) {
    this.ctx.strokeStyle = '#aaaaaa';
    this.ctx.lineWidth = 0.1;
    this.ctx.beginPath();
    this.ctx.moveTo(x + 0.5, 0);
    this.ctx.lineTo(x + 0.5, this.height);
    this.ctx.closePath();
    this.ctx.stroke();
  }

  // 横罫線
  drawHRuleLine(y) {
    this.ctx.strokeStyle = '#aaa';
    this.ctx.lineWidth = 0.1;
    this.ctx.beginPath();
    this.ctx.moveTo(0, y + 0.5);
    this.ctx.lineTo(this.width, y + 0.5);
    this.ctx.closePath();
    this.ctx.stroke();
  }

  // 指定場所の色を取得
  getColor(x, y) {
    var pixel = this.ctx.getImageData(x * this.cellsize, y * this.cellsize, 1, 1);
    var data = pixel.data;
    return Canvas.toRgbaStr(data[0], data[1], data[2], data[3]);
  }

  // 指定位置をクリア
  clearPoint(x, y) {
    this.ctx.clearRect(x * this.cellsize, y * this.cellsize, 
                       this.cellsize, this.cellsize);
  }

  // すべてをクリア
  clearAll() {
    this.ctx.clearRect(0, 0, this.width, this.height);
    for (var x = 0; x < this.width; x += this.cellsize) {
      this.drawVRuleLine(x);
    }
    for (var y = 0; y < this.height; y += this.cellsize) {
      this.drawHRuleLine(y);
    }
  }

  // ひとつのセルをその状態によって描画
  drawPiece(loc, piece) {
    var cell = piece;
    if (cell.IsAlive) {
      this.DrawLife(loc, '#666666');
    } else {
      this.clearPoint(loc.x, loc.y);
    }
  }

  // 四角形を生成する
  drawLife(loc, color) {
    this.drawPoint(loc.x, loc.y, color);
  }

  static toRgbaStr(r, g, b, a) {
    return 'rgba(' + r + ',' + g + ',' + b + ',' + a + ')';
  };
}


class Cell {
  constructor() {
    this.IsAlive = false;
    this._nextStatus = false;
  }

  // 生死を反転する
  toggle() {
    this.IsAlive = !this.IsAlive;
  };

  // trueならば生、falseならば死
  judge(count) {
    if (this.IsAlive) {
      return (count === 2 || count === 3);
    } else {
      return (count === 3);
    }
  };

  // 次の世代の状態を決める。変化があるとtrueが返る。
  survive(around) {
    this._nextStatus = this.judge(around);
    return this._nextStatus !== this.IsAlive;
  };

  // 次の状態にする
  nextStage() {
    var old = this.IsAlive;
    this.IsAlive = this._nextStatus;
    return this.IsAlive !== old;
  };
}


class Board {
  constructor(w, h) {
    this.width = w;
    this.height = h;
    this.map = new Array((this.width) * (this.height));
    this.clearAll();
    this.onChange = {};
  }

  // Location から _coinのIndexを求める
  toIndex(x, y) {
    return x + y * (this.width);
  };

  // IndexからLocationを求める
  toLocation(index) {
    return { x: index % (this.width), y: Math.floor(index / (this.width)) };
  };

  // 盤上のすべての位置(index)を列挙する
  getAllIndexes() {
    var list = [];
    for (var y = 0; y < this.height; y++) {
      for (var x = 0; x < this.width; x++) {
        list.push(this.toIndex(x, y));
      }
    }
    return list;
  };

  // 全てのPieceをクリアする
  clearAll() {
    this.getAllIndexes().forEach(ix => {
      this.map[ix] = new Cell();
    });
  };

  // 反転する
  reverse(index) {
    var cell = this.map[index];
    cell.toggle();
    this.onChange(index, cell);
  };

  // 生成する
  set(index) {
    var cell = this.map[index];
    cell.IsAlive = true;
    this.onChange(index, cell);
  };

  // 消滅させる
  clear(index) {
    var cell = this.map[index];
    cell.IsAlive = false;
    this.onChange(index, cell);
  };

  // 位置の補正: はみ出たらぐるっと回る
  corectIndex(x, y) {
    x = (x + this.width) % this.width;
    y = (y + this.height) % this.height;
    return this.toIndex(x, y);
  };

  // 周りの生存者の数を数える
  countAround(index) {
    var loc = this.toLocation(index);
    var arounds = [
      { x: loc.x - 1, y: loc.y - 1 },
      { x: loc.x - 1, y: loc.y     },
      { x: loc.x - 1, y: loc.y + 1 },
      { x: loc.x,     y: loc.y - 1 },
      { x: loc.x,     y: loc.y + 1 },
      { x: loc.x + 1, y: loc.y - 1 },
      { x: loc.x + 1, y: loc.y     },
      { x: loc.x + 1, y: loc.y + 1 },
    ];
    return arounds
      .map(loc => this.corectIndex(loc.x, loc.y))
      .filter(ix => this.map[ix].IsAlive)
      .length;
  };

  // 生死を決める
  survive() {
    var count = 0;
    this.getAllIndexes().forEach(ix => {
      var cell = this.map[ix];
      if (cell.survive(this.countAround(ix))) {
        count++;
      }
    });
    if (count > 0) {
      this.getAllIndexes().forEach(ix => {
        var cell = this.map[ix];
        if (cell.nextStage()) {
          this.onChange(ix, cell);
        }
      });
    }
    return count;
  };
}

var random = function (max) {
  return Math.floor(Math.random() * max) + 1;
};


class LifeWorld {
  constructor(board, canvas) {
    this._canvas = canvas;
    this._board = board;

    this.timer = {};

    // 状態が変化した時の処理: Boardオブジェクトが呼び出す
    this._board.onChange = (index, cell) => {
      var loc = this._board.toLocation(index);
      var color = cell.IsAlive ? '#508030' : '#FFFFFF';
      this._canvas.drawPoint(loc.x, loc.y, color);
    };
  }

  // 開始
  start() {
    var interval = 50; // 200
    this.timer = setInterval(() => {
      var count = this._board.survive();
      if (count == 0) {
        this.stop();
      }
    }, interval);
  };

  // 停止
  stop() {
    clearInterval(this.timer);
  };

  // クリア
  clear() {
    this._canvas.clearAll();
    this._board.clearAll();
  };

  // ランダムに点を打つ
  random() {
    this.clear();
    var count = random(this._board.width*20) + this._board.height*20;
    for (var i = 0; i < count; i++) {
      var x = random(this._board.width - 1);
      var y = random(this._board.height - 1);
      var ix = this._board.toIndex(x, y);
      this._board.reverse(ix);
    }
  };
}


class Program {
  constructor(width, height) {
    var board = new Board(width, height);
    var canvas = new MyCanvas('mycanvas', width, height);
    this.world = new LifeWorld(board, canvas);
    this.dragState = 0;

    canvas.onMouseDown = (x, y, shiftKey) => {
      this.dragState = 1;
    };

    canvas.onMouseMove = (x, y, shiftKey) => {
      if (this.dragState >= 1) {
        if (shiftKey) {
          board.clear(board.toIndex(x, y));
        } else {
          board.set(board.toIndex(x, y));
        }
        this.dragState = 2;
      }
    };

    canvas.onMouseUp = (x, y, shiftKey) => {
      if (this.dragState === 1) {
        board.reverse(board.toIndex(x, y));
      }
      this.dragState = 0;
    };

  }

  run() {
    document.getElementById('startButton')
      .addEventListener('click', () => this.start(), false);
    document.getElementById('stopButton')
      .addEventListener('click', () => this.stop(), false);
    document.getElementById('clearButton')
      .addEventListener('click', () => this.clear(), false);
    document.getElementById('randomButton')
      .addEventListener('click', () => this.random(), false);
  };

  start() {
    this.world.start();
  };

  stop() {
    this.world.stop();
  };

  clear() {
    this.world.stop();
    this.world.clear();
  };

  random() {
    this.world.random();
  };
}

function main() {
  window.onload = function () {
    var program = new Program(200, 160);
    program.run();
  };
}
