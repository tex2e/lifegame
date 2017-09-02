
open System
open System.Threading

type Lifegame(height: int, width: int) =
    let randomGen = System.Random()
    let mutable field = Array2D.init height width (fun x y -> randomGen.Next(2))
    member this.Loop() =
        while true do
            this.ClearScreen()
            this.DumpField()
            Thread.Sleep(100); // 100[ms]
            field <- this.Evolve(field)
    member this.Evolve(field: int[,]) =
        Array2D.mapi (fun y x cell -> this.DeadOrAlive(field, y, x)) field
    member this.DeadOrAlive(field: int[,], y: int, x: int): int =
        let aliveNeighbours = this.CountAliveNeighbours(field, y, x)
        match aliveNeighbours with
        | 2 -> field.[y, x]
        | 3 -> 1
        | _ -> 0
    member this.CountAliveNeighbours(field: int[,], y: int, x: int): int =
        [| for yi in -1..1 do
            for xi in -1..1 ->
                if not (yi = 0 && xi = 0) then
                    field.[this.Mod(y + yi, height), this.Mod(x + xi, width)]
                else
                    0 |]
        |> Array.sum
    member this.Mod(a: int, b: int): int =
        match a with
        | _ when a > 0 -> a % b
        | _ when a < 0 -> (a + b) % b
        | _ -> 0
    member this.DumpField() =
        let charField = Array2D.map (fun cell -> if cell = 0 then ' ' else 'o') field
        Array2D.iteri (fun y x cell ->
            if x = width - 1 then printfn "%c" cell else printf "%c" cell) charField
    member this.ClearScreen() = Console.Clear()

[<EntryPoint>]
let main argv =
    let lifegame = new Lifegame(20, 40)
    lifegame.DumpField()
    lifegame.Loop()
    0
