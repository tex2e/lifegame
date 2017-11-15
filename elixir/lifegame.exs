
defmodule Lifegame do
  defstruct [:field, :height, :width]

  def init_field(height: height, width: width) do
    list = for y <- 0..height-1, x <- 0..width-1 do
      {index(y, x), :rand.uniform(2) - 1}
    end
    %Lifegame{field: Keyword.new(list), height: height, width: width}
  end

  def loop(lifegame) do
    clear_screen()
    dump_field(lifegame)
    :timer.sleep(100) # 100[ms]
    evolved = evolve(lifegame)
    loop(evolved)
  end

  def evolve(%Lifegame{height: height, width: width} = lifegame) do
    list = for y <- 0..height-1, x <- 0..width-1 do
      {index(y, x), dead_or_alive(lifegame, {y,x})}
    end
    %Lifegame{field: Keyword.new(list), height: height, width: width}
  end

  defp index(y, x) do
    String.to_atom("#{y},#{x}")
  end

  defp dead_or_alive(%Lifegame{field: field} = lifegame, {y,x}) do
    case count_alive_neighbours(lifegame, {y,x}) do
      2 -> Keyword.fetch!(field, index(y, x))
      3 -> 1
      _ -> 0
    end
  end

  defp count_alive_neighbours(
      %Lifegame{field: field, width: width, height: height}, {y,x}) do
    neighbours = for yi <- [-1,0,1], xi <- [-1,0,1], !(yi == 0 && xi == 0) do
      Keyword.fetch!(field, index(mod(y + yi, height), mod(x + xi, width)))
    end
    Enum.sum(neighbours)
  end

  defp mod(a, b) when a > 0, do: rem(a, b)
  defp mod(a, b) when a < 0, do: rem(a + b, b)
  defp mod(0, _), do: 0

  def dump_field(%Lifegame{field: field, width: width}) do
    field
    |> Enum.map(&to_char/1)
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
    |> IO.puts
  end

  defp to_char({_,ch}) do
    if ch == 0, do: ' ', else: 'o'
  end

  def clear_screen do
    IO.write("\e[;H\e[2J")
  end
end

defmodule Main do
  lifegame = Lifegame.init_field(height: 20, width: 40)
  Lifegame.loop(lifegame)
end
