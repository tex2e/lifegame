
class Lifegame
  def initialize(height:, width:)
    @height = height
    @width = width
    @field = init_field(height: height, width: width)
  end

  def init_field(height:, width:)
    Array.new(height) { Array.new(width) { rand(2) } }
  end

  def loop
    while true
      clear_screen
      dump_field(@field)
      sleep 0.1 # 100[ms]
      @field = evolve(@field)
    end
  rescue Interrupt => e
    return
  end

  def evolve(field)
    height, width = field.length, field[0].length
    Array.new(height) { |y| Array.new(width) { |x| dead_or_alive(field, y, x) } }
  end

  def dead_or_alive(field, y, x)
    case count_alive_neighbours(field, y, x)
    when 0..1 then 0
    when 2    then field[y][x]
    when 3    then 1
    when 4..9 then 0
    end
  end

  def count_alive_neighbours(field, y, x)
    height, width = field.length, field[0].length
    [-1,0,1].product([-1,0,1])
      .reject { |xi, yi| xi == 0 and yi == 0 }
      .map { |xi, yi| field[(y + yi) % height][(x + xi) % width] }
      .inject(:+)
  end

  def dump_field(field)
    char_field = field.map { |line| line.map { |cell| (cell == 0) ? ' ' : 'o' } }
    lines = char_field.map { |line| line.join }
    puts lines.join("\n")
  end

  def clear_screen
    puts "\033[;H\033[2J"
  end
end


if __FILE__ == $0
  lifegame = Lifegame.new(height: 20, width: 40)
  lifegame.loop
end
