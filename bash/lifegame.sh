#!/bin/bash
if [[ ! "$BASH_VERSION" =~ ^4\. ]]; then
  echo "Error: Require bash 4.x"
  exit
fi

# Arrays in Bash are (circularly) linked lists of type string (char *).
# So, field and new_field aren't actually a nested array.
# Note that getting field[$y,$x] is O(h * w) and it's quite slow.

height=20
width=40
declare -A field
declare -A new_field

function init_field {
  for y in `seq 0 $((height - 1))`; do
    for x in `seq 0 $((width - 1))`; do
      field[$y,$x]=$((RANDOM % 2))
    done
  done
}

function evolve {
  local alive_neighbours
  for y in `seq 0 $((height - 1))`; do
    for x in `seq 0 $((width - 1))`; do
      alive_neighbours=$(count_alive_neighbours "$y" "$x")
      case $alive_neighbours in
        2 ) new_field[$y,$x]=${field[$y,$x]} ;;
        3 ) new_field[$y,$x]=1 ;;
        * ) new_field[$y,$x]=0 ;;
      esac
    done
  done
}

function count_alive_neighbours {
  local y=$1 x=$2
  local count=0 y_i x_i
  for yi in {-1..1}; do
    for xi in {-1..1}; do
      if [ $yi = 0 ] && [ $xi = 0 ]; then
        continue
      fi
      y_i=$(( (y + yi + height) % height ))
      x_i=$(( (x + xi + width ) % width  ))
      if [ ${field[$y_i,$x_i]} = 1 ]; then
        let count++
      fi
    done
  done
  echo $count
}

function prepare_next {
  for key in "${!new_field[@]}"; do
    field["$key"]="${new_field["$key"]}"
  done
}

function dump_field {
  for y in `seq 0 $((height - 1))`; do
    for x in `seq 0 $((width - 1))`; do
      test ${field["$y,$x"]} = 0 && printf " " || printf "o"
    done
    printf "\n"
  done
}

function clear_screen {
  printf "\033[;H\033[2J"
}

init_field
while true; do
  clear_screen
  dump_field
  # sleep 0.1 # this isn't need bacause entire script is too slow.
  evolve
  prepare_next
done
