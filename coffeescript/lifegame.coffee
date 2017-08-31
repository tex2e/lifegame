
class Lifegame
  constructor: (@height, @width) ->
    @field = this.initField(@height, @width)

  initField: (height, width) ->
    @field = for y in [0..@height-1]
      for x in [0..@width-1]
        this.getRandomInt(1)

  getRandomInt: (max) ->
    Math.floor(Math.random() * (max + 1))

  loop: () ->
    this.clearScreen()
    this.dumpField()
    @field = this.evolve()
    setTimeout(this.loop.bind(this), 100) # 100ms

  evolve: () ->
    for y in [0..@height-1]
      for x in [0..@width-1]
        aliveNeighbours = this.countAliveNeighbours(y, x)
        switch
          when aliveNeighbours <= 1 then 0
          when aliveNeighbours == 2 then @field[y][x]
          when aliveNeighbours == 3 then 1
          when aliveNeighbours >= 4 then 0

  countAliveNeighbours: (y, x) ->
    count = 0
    for yi in [-1,0,1]
      for xi in [-1,0,1]
        if yi == 0 and xi == 0
          continue
        if @field[(y + yi) %% @height][(x + xi) %% @width] == 1
          count += 1
    count

  dumpField: () ->
    lines = for y in [0..@height-1]
      ( this.toChar(@field[y][x]) for x in [0..@width-1] ).join("")
    console.log lines.join("\n")

  toChar: (cell) ->
    if cell == 0 then " " else "o"

  clearScreen: () ->
    console.log '\x1B[2J\x1B[0f\u001b[0;0H'


lifegame = new Lifegame(20, 40)
lifegame.loop()
