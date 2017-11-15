
using System;
using System.Linq;
using System.Threading;

public class Program
{
    static public void Main()
    {
        int height = 20;
        int width  = 40;
        Lifegame lifegame = new Lifegame(height, width);
        lifegame.Loop();
    }
}


public class Lifegame
{
    public int height;
    public int width;
    public int[,] field;

    public Lifegame(int height, int width)
    {
        this.height = height;
        this.width = width;
        this.field = InitField(height, width);
    }

    public int[,] InitField(int height, int width)
    {
        int[,] field = new int[height, width];
        Random randomGen = new Random();

        foreach (int y in Enumerable.Range(0, height))
        {
            foreach (int x in Enumerable.Range(0, width))
            {
                field[y, x] = randomGen.Next(2);
            }
        }
        return field;
    }

    public void Loop()
    {
        while (true)
        {
            ClearScreen();
            DumpField();
            Thread.Sleep(100); // 100[ms]
            this.field = Evolve(this.field);
        }
    }

    public int[,] Evolve(int[,] field)
    {
        int[,] newField = new int[this.height, this.width];
        foreach (int y in Enumerable.Range(0, height))
        {
            foreach (int x in Enumerable.Range(0, width))
            {
                switch (CountAliveNeighbours(field, y, x)) {
                    case 2:  newField[y, x] = field[y, x]; break;
                    case 3:  newField[y, x] = 1;           break;
                    default: newField[y, x] = 0;           break;
                }
            }
        }
        return newField;
    }

    public int CountAliveNeighbours(int[,] field, int y, int x)
    {
        var aliveNeighbours =
            from y_i in new int[] {-1, 0, 1}
            from x_i in new int[] {-1, 0, 1}
            where !(y_i == 0 && x_i == 0)
            let yi = Mod(y + y_i, this.height)
            let xi = Mod(x + x_i, this.width)
            select new { cell = field[yi, xi] };
        return aliveNeighbours.Sum(neighbour => neighbour.cell);
    }

    private int Mod(int a, int b)
    {
        return (a + b) % b;
    }

    public void DumpField()
    {
        foreach (int y in Enumerable.Range(0, this.height))
        {
            foreach (int x in Enumerable.Range(0, this.width))
            {
                Console.Write((field[y, x] == 0) ? " " : "o");
            }
            Console.Write("\n");
        }
    }

    public void ClearScreen()
    {
        Console.Clear();
    }
}
