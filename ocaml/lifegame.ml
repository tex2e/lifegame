
let () = Random.self_init()

let init_field height width =
  Array.init height (fun _ ->
    Array.init width (fun _ ->
      Random.int 2))

let dump_field field =
  let get_char cell =
    match cell with
      | 1 -> 'o'
      | _ -> ' ' in
  Array.iter (fun row ->
    Array.iter (fun cell ->
      Printf.printf "%c" (get_char cell)) row;
    Printf.printf "\n%!" (* "%!" means flush the output *)
  ) field

let count_alive_neighbours field y x =
  let height = Array.length field
  and width  = Array.length field.(0)
  and modulo a b = (a + b) mod b in
  let neighbours = [
    modulo (x - 1) width, modulo (y - 1) height;
    modulo (x - 1) width, modulo (y    ) height;
    modulo (x - 1) width, modulo (y + 1) height;
    modulo (x    ) width, modulo (y - 1) height;
    modulo (x    ) width, modulo (y + 1) height;
    modulo (x + 1) width, modulo (y - 1) height;
    modulo (x + 1) width, modulo (y    ) height;
    modulo (x + 1) width, modulo (y + 1) height;
  ] |> List.map (fun (x,y) -> field.(y).(x)) in
  List.fold_left (fun a b -> a + b) 0 neighbours

let evolve field =
  let height = Array.length field
  and width  = Array.length field.(0) in
  let new_field =
    Array.init height (fun y ->
      Array.init width (fun x ->
        match count_alive_neighbours field y x with
        | 2 -> field.(y).(x)
        | 3 -> 1
        | _ -> 0
      )) in
  new_field

let rec lifegame field =
  let _ = Sys.command "clear" in
  dump_field field;
  Unix.sleepf 0.1;
  lifegame (evolve field);;

let main =
  lifegame (init_field 20 40)
