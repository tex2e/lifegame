@echo off

REM ライフゲームのフィールドサイズ
set /a field_max_x=10
set /a field_max_y=10
set /a fieldy=%field_max_x%-1
set /a fieldx=%field_max_y%-1
REM 隣接セルで生きている数の結果を格納する変数
set alive_count=0


setlocal enabledelayedexpansion

call :init_field
:LOOP
cls
call :dump_field
call :evolve
goto LOOP
exit /b


REM フィールドの初期化
:init_field
for /l %%y in (0,1,%fieldy%) do (
  for /l %%x in (0,1,%fieldx%) do (
    set /a field[%%y][%%x]=!random!%%2
  )
)
exit /b

REM フィールドの表示
:dump_field
for /l %%y in (0,1,%fieldy%) do (
  for /l %%x in (0,1,%fieldx%) do (
    if !field[%%y][%%x]! == 0 (
      set /p="_" < nul
    ) else (
      set /p="o" < nul
    )
  )
  echo.
)
exit /b

REM 次の世代を求める
:evolve
for /l %%y in (0,1,%fieldy%) do (
  for /l %%x in (0,1,%fieldx%) do (
    call :count_alive_neighbours %%y %%x
    if !alive_count! == 2 (
      set cell=!field[%%y][%%x]!
      set newfield[%%y][%%x]=!cell!
    ) else if !alive_count! == 3 (
      set newfield[%%y][%%x]=1
    ) else (
      set newfield[%%y][%%x]=0
    )
  )
)
for /l %%y in (0,1,%fieldy%) do (
  for /l %%x in (0,1,%fieldx%) do (
    set field[%%y][%%x]=!newfield[%%y][%%x]!
  )
)
exit /b

REM 隣接セルの生きている数を数える
:count_alive_neighbours
set /a alive_count=0
for /l %%y in (-1,1,1) do (
  for /l %%x in (-1,1,1) do (
    set /a "yi=(%1 + %%y + %field_max_y%) %% %field_max_y%"
    set /a "xi=(%2 + %%x + %field_max_x%) %% %field_max_x%"
    call set cell=%%field[!yi!][!xi!]%%
    set flag=0
    if %%y equ 0 (
      if %%x equ 0 (
        set flag=1
      )
    )
    if !flag! == 0 (
      if !cell! equ 1 (
        set /a alive_count+=1
      )
    )
  )
)
exit /b
