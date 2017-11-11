#!/usr/bin/osascript

set fieldHeight to 20
set fieldWidth to 40
set field to {}
repeat with y from 1 to fieldHeight
  set end of field to {}
  repeat with x from 1 to fieldWidth
    set end of item y of field to random number from 0 to 1
  end repeat
end repeat

on convertListToString(theList, theDelimiter)
  set AppleScript's text item delimiters to theDelimiter
  set theString to theList as string
  set AppleScript's text item delimiters to ""
  return theString
end convertListToString

on disp(field, fieldHeight, fieldWidth)
  repeat with y from 1 to fieldHeight
    set tmp to {}
    repeat with x from 1 to fieldWidth
      set cell to item x of item y of field
      set end of tmp to item (cell + 1) of {" ", "o"}
    end repeat
    log convertListToString(tmp, "")
  end repeat
end disp

on countAliveNeighbours(field, fieldHeight, fieldWidth, y, x)
  local cellCount, y_i, x_i
  set cellCount to 0
  repeat with yi from -1 to 1
    repeat with xi from -1 to 1
      set y_i to (((y - 1) + yi + fieldHeight) mod fieldHeight) + 1
      set x_i to (((x - 1) + xi + fieldWidth) mod fieldWidth) + 1
      set cellCount to cellCount + (field's item y_i's item x_i)
    end repeat
  end repeat
  set cellCount to cellCount - (field's item y's item x)
  return cellCount
end countAliveNeighbours

on evolve(field, fieldHeight, fieldWidth)
  local newField, cellCount
  set newField to {}
  repeat with y from 1 to fieldHeight
    set end of newField to {}
    repeat with x from 1 to fieldWidth
      set cellCount to countAliveNeighbours(field, fieldHeight, fieldWidth, y, x)
      if cellCount = 2 then
        set end of item y of newField to field's item y's item x
      else if cellCount = 3 then
        set end of item y of newField to 1
      else
        set end of item y of newField to 0
      end if
    end repeat
  end repeat
  return newField
end evolve

repeat
  log do shell script "echo '\\033[;H\\033[2J'"
  disp(field, fieldHeight, fieldWidth)
  set newField to evolve(field, fieldHeight, fieldWidth)
  copy newField to field
end repeat

return 0
