`timescale 1ns/100fs

module main();

reg field [100:0][100:0];
reg new_field [100:0][100:0];
parameter WIDTH = 40;
parameter HEIGHT = 20;
integer i, j;
integer _x, _y;
integer xi, yi;
reg [3:0] count;

initial begin
  init_field();

  for (i = 0; i < 150; i++) begin
    clear_screen();
    dump_field();
    evolve();
    prepare_next();
    // sleep
    for (j = 0; j < 100000; j++) begin
    end
  end

  $finish;
end

task init_field;
  for (_y = 0; _y < HEIGHT; _y++) begin
    for (_x = 0; _x < WIDTH; _x++) begin
      field[_y][_x] = $urandom % 2;
    end
  end
endtask

task prepare_next;
  for (_y = 0; _y < HEIGHT; _y++) begin
    for (_x = 0; _x < WIDTH; _x++) begin
      field[_y][_x] = new_field[_y][_x];
    end
  end
endtask

task evolve;
begin
  for (_y = 0; _y < HEIGHT; _y++) begin
    for (_x = 0; _x < WIDTH; _x++) begin
      count = count_alive_neighbours(_y, _x);
      if (count == 2) begin
        new_field[_y][_x] = field[_y][_x];
      end
      else if (count == 3) begin
        new_field[_y][_x] = 1;
      end
      else begin
        new_field[_y][_x] = 0;
      end
    end
  end
end
endtask

function [6:0] count_alive_neighbours;
input [6:0] _y;
input [6:0] _x;
begin
  count = 0;
  for (yi = -1; yi <= 1; yi++) begin
    for (xi = -1; xi <= 1; xi++) begin : CONTINUE
      if (yi == 0 && xi == 0) disable CONTINUE;
      if (field[mod((_y + yi), HEIGHT)][mod((_x + xi), WIDTH)] == 1) begin
        count = count + 1;
      end
    end
  end
  count_alive_neighbours = count;
end
endfunction

function [6:0] mod;
input [6:0] a;
input [6:0] b;
  mod = (a + b) % b;
endfunction

task dump_field;
  for (_y = 0; _y < HEIGHT; _y++) begin
    for (_x = 0; _x < WIDTH; _x++) begin
      if (field[_y][_x] == 1) begin
        $write("o");
      end
      else begin
        $write(" ");
      end
    end
    $write("\n");
  end
endtask

task clear_screen;
  $write("\033[;H\033[2J");
endtask

endmodule
