
-module(lifegame).
-export([main/0]).

main() ->
  Height = 20,
  Width = 40,
  Field = init_field(Height, Width),
  lifegame(Field, Height, Width).

init_field(Height, Width) ->
  List = [{{Y,X}, rand:uniform(2) - 1} || Y<-lists:seq(0, Height-1), X<-lists:seq(0, Width-1)],
  orddict:from_list(List).

lifegame(Field, Height, Width) ->
  clear_screen(),
  dump_field(Field, Height, Width),
  timer:sleep(100), % 100[ms]
  NewField = evolve(Field, Height, Width),
  lifegame(NewField, Height, Width).

evolve(Field, Height, Width) ->
  List = [{{Y,X}, dead_or_alive(Field, Height, Width, {Y,X})} || Y<-lists:seq(0, Height-1), X<-lists:seq(0, Width-1)],
  NewField = orddict:from_list(List),
  NewField.

dead_or_alive(Field, Height, Width, {Y,X}) ->
  AliveNeighbours = count_alive_neighbours(Field, Height, Width, {Y,X}),
  if
    AliveNeighbours =< 1 -> 0;
    AliveNeighbours == 2 -> orddict:fetch({Y,X}, Field);
    AliveNeighbours == 3 -> 1;
    AliveNeighbours >= 4 -> 0
  end.

count_alive_neighbours(Field, Height, Width, {Y,X}) ->
  Neighbours = [ orddict:fetch({mod(Y + Yi, Height), mod(X + Xi, Width)}, Field)
                || Yi<-[-1,0,1], Xi<-[-1,0,1], not ((Yi == 0) and (Xi == 0))],
  lists:sum(Neighbours).

mod(A, B) when A > 0 -> A rem B;
mod(A, B) when A < 0 -> mod(A + B, B);
mod(0, _) -> 0.

dump_field(Field, _, Width) ->
  Lines = chunks_of(Width, lists:map(fun to_char/1, orddict:to_list(Field))),
  io:format("~s~n", [ string:join(Lines, "\n") ]).

to_char({{_,_},Ch}) -> case Ch of 0 -> " "; 1 -> "o" end.

chunks_of(N, List) ->
  lists:foldr(fun(E, []) -> [[E]];
                 (E, [H|RAcc]) when length(H) < N -> [[E|H]|RAcc];
                 (E, [H|RAcc]) -> [[E],H|RAcc]
              end, [], List).

clear_screen() ->
  io:format("\033[;H\033[2J").
