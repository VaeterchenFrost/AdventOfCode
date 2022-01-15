<# --- Day 11: Dumbo Octopus ---

You enter a large cavern full of rare bioluminescent dumbo octopuses! They seem to not like the Christmas lights on your submarine, so you turn them off for now.
Each octopus has an energy level - your submarine can remotely measure the energy level of each octopus (your puzzle input).
The energy level of each octopus is a value between 0 and 9. Here, the top-left octopus has an energy level of 5, the bottom-right one has an energy level of 6, and so on.
You can model the energy levels and flashes of light in steps. During a single step, the following occurs:

    - First, the energy level of each octopus increases by 1.
    - Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1, including octopuses that are diagonally adjacent. 
    If this causes an octopus to have an energy level greater than 9, it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9. 
    (An octopus can only flash at most once per step.)
    - Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.

Given the starting energy levels of the dumbo octopuses in your cavern, simulate 100 steps. How many total flashes are there after 100 steps?#>

$year, $day = 2021, 11

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$columns = 1..10 # expected
$energy_levels = [int[][]]::new($lines.Count + 2)
$flashed = New-Object 'System.Collections.Generic.HashSet[Tuple[int,int]]'
$to_flash = [System.Collections.Stack]::new() 

(1..$lines.Count).ForEach({ $energy_levels[$_] = (, 0) + ($lines[$_ - 1] | Select-String '\d' -AllMatches).Matches.Value + (, 0) | ForEach-Object { [int]$_ } })

$energy_levels[0] = $energy_levels[-1] = (, 0) * ($columns.Count + 2)
$octopusses = $lines.Count * $columns.Count
$flashes = 0
$step = 0
do {
  $step++
  $energy_levels | ForEach-Object { $_ -join '' } | Write-Debug
  # First, the energy level of each octopus increases by 1.
  foreach ($line in (1..$lines.Count)) {
    foreach ($column in $columns) {
      $energy_levels[$line][$column] += 1
    }
  }
  # Collect Flashes
  $to_flash.Clear()
  $flashed.Clear()
  foreach ($line in (1..$lines.Count)) {
    foreach ($column in $columns) {
      if ($energy_levels[$line][$column] -gt 9) {
        $tuple = [System.Tuple]::Create($line, $column)
        $to_flash.Push($tuple)
        [void]$flashed.Add($tuple)
      }
    }
  }
  # Flashes
  while ($to_flash.Count) {
    $flash = $to_flash.Pop()
        ((-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)).ForEach({
        $tuple = [System.Tuple]::Create($flash[0] + $_[0], $flash[1] + $_[1])
        if ($energy_levels[$tuple[0]][$tuple[1]]) {
          # not a border
          $energy_levels[$tuple[0]][$tuple[1]] += 1
          if ($energy_levels[$tuple[0]][$tuple[1]] -gt 9 -and $flashed.Add($tuple)) {
            $to_flash.Push($tuple)
          }
        }
      })
  }
  # Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
  $flashed.ForEach({ $energy_levels[$_[0]][$_[1]] = 0 })
  $flashes += $flashed.Count
  Write-Debug ($flashed | ForEach-Object { "$($_.Item1),$($_.Item2)" } | Join-String -Separator ' ')
  if ($step -eq 100) { Write-Warning "$flashes after 100 steps" }
} until ($flashed.Count -eq $octopusses)

Write-Warning $step
