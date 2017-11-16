<?php

class Lifegame {
  function __construct($height, $width) {
    $this->height = $height;
    $this->width  = $width;
    $this->field  = $this->initField($height, $width);
  }

  private function initField($height, $width) {
    $field = [];
    for ($y = 0; $y < $height; $y++) {
      for ($x = 0; $x < $width; $x++) {
        $field[$y][$x] = rand(0, 1);
      }
    }
    return $field;
  }

  public function loop() {
    while (true) {
      $this->clearScreen();
      $this->dumpField();
      usleep(100000);
      $this->field = $this->evolve();
    }
  }

  public function evolve() {
    $newField = [];
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        switch ($this->countAliveNeighbours($y, $x)) {
          case 2:  $newField[$y][$x] = $this->field[$y][$x]; break;
          case 3:  $newField[$y][$x] = 1;                    break;
          default: $newField[$y][$x] = 0;                    break;
        }
      }
    }
    return $newField;
  }

  private function countAliveNeighbours($y, $x) {
    $count = 0;
    foreach (range(-1, 1) as $yi) {
      foreach (range(-1, 1) as $xi) {
        if ($yi == 0 && $xi == 0) continue;
        if ($this->field[$this->mod($y + $yi, $this->height)][$this->mod($x + $xi, $this->width)] == 1) {
          $count++;
        }
      }
    }
    return $count;
  }

  private function mod($a, $b) {
    return ($a + $b) % $b;
  }

  public function dumpField() {
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        echo ($this->field[$y][$x] == 0 ? " " : "o");
      }
      echo "\n";
    }
  }

  public function clearScreen() {
    echo "\033[;H\033[2J";
  }
}

$lifegame = new Lifegame(20, 40);
$lifegame->loop();
