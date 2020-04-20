
$ErrorActionPreference = "Stop"

$height = 10
$width = 20
$field = New-Object 'object[,]' $height,$width
$newField = New-Object 'object[,]' $height,$width

function InitField($field) {
  For ($y = 0; $y -lt $height; $y++) {
    For ($x = 0; $x -lt $width; $x++) {
      $field[$y,$x] = Get-Random -Maximum 2
    }
  }
}

function Loop() {
  InitField $field
  while ($true) {
    clear
    DumpField $field
    Start-Sleep -Milliseconds 100  # 100ms
    Evolve $field
    $field = $newField.Clone()
  }
}

function Evolve($field) {
  For ($y = 0; $y -lt $height; $y++) {
    For ($x = 0; $x -lt $width; $x++) {
      $counter = CountAliveNeighbours $x $y
      switch ($counter) {
        2 { $newField[$y,$x] = $field[$y,$x] }
        3 { $newField[$y,$x] = 1 }
        Default { $newField[$y,$x] = 0 }
      }
    }
  }
}

function CountAliveNeighbours([int]$x, [int]$y) {
  $count = 0
  For ($yi = -1; $yi -le 1; $yi++) {
    For ($xi = -1; $xi -le 1; $xi++) {
      if (($yi -eq 0) -And ($xi -eq 0)) { continue }

      $myY = Mod ($y + $yi) $height
      $myX = Mod ($x + $xi) $width
      $count += $field[$myY,$myX]
    }
  }
  return $count
}

function Mod([int]$a, [int]$b) {
  return (($a + $b) % $b)
}

function DumpField($field) {
  For ($y = 0; $y -lt $height; $y++) {
    For ($x = 0; $x -lt $width; $x++) {
      if ($field[$y,$x] -eq 1) {
        Write-Host 'o' -NoNewLine
      } else {
        Write-Host ' ' -NoNewLine
      }
      # Write-Host $field[$y,$x] -NoNewLine
    }
    Write-Output '|'
  }
}

Loop
