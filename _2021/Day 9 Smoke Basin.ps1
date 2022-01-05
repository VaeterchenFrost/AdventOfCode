<# --- Day 9: Smoke Basin ---
Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.
Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)
The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the map is therefore 15.
Find all of the low points on your map. What is the sum of the risk levels of all low points on your map? #>
Import-Module functional -DisableNameChecking

$year, $day = 2021, 9

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$vertical = $lines.Length
$horizontal = $lines[0].Length
$padding = [int]::MaxValue

$map = [int[][]]::new($vertical + 2)
$map[0] = $map[-1] = (, $padding) * ($horizontal + 2)

(1..$vertical).ForEach({
    $map[$_] = $lines[$_ - 1] -split ''
    $map[$_][0] = $map[$_][-1] = $padding
  })
<# Part 1
$counter = $risklevel = 0
foreach ($y in (1..$vertical))
{
  foreach ($x in (1..$horizontal))
  {
    if (-not($map[$y][$x - 1], $map[$y][$x + 1], $map[$y - 1][$x], $map[$y + 1][$x]).where({ $_ -le $map[$y][$x] }).Count )
    {
      $counter++
      Write-Debug "Found point $($map[$y][$x]) to be a lowpoint on $x, $y"
      $risklevel += $($map[$y][$x]) + 1
    }
  }
}
Write-Debug "$counter low points"
Write-Warning $risklevel #>
<#--- Part Two ---
Next, you need to find the largest basins so you know what areas are most important to avoid.
A basin is all locations that eventually flow downward to a single low point. 
Therefore, every low point has a basin, although some basins are very small. 
Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.
The size of a basin is the number of locations within the basin, including the low point.
What do you get if you multiply together the sizes of the three largest basins?#>

$basinsizes = @()
$initial_point = -1
function fillcount 
{
  [CmdletBinding()] #<<-- This turns a regular function into an advanced function
  param (
    [int[]]$position
  )
  if ($map[$position[0] + 1][$position[1] + 1] -ge 9) { return 0 }
  Write-Debug "in fillcount $position ($($map[$position[0] + 1][$position[1] + 1]))"
  $map[$position[0] + 1][$position[1] + 1] = 9
  return ((
      (fillcount (($position[0] - 1), ($position[1]))),
      (fillcount (($position[0] + 1), ($position[1]))),
      (fillcount (($position[0]), ($position[1] - 1))),
      (fillcount (($position[0]), ($position[1] + 1))),
      1
    ) | Measure-Object -Sum).Sum
}

while ($initial_point -le $vertical * $horizontal)
{
  ++$initial_point
  $position = [math]::floor($initial_point / $horizontal), ($initial_point % $horizontal)
  if ($map[$position[0] + 1][$position[1] + 1] -ge 9) { continue }
  Write-Debug "checking fillcount from $position ($($map[$position[0] + 1][$position[1] + 1]))"
  $basinsizes += (fillcount $position)
}

Write-Warning ($basinsizes | Sort-Object | Select-Object -Last 3 | reduce { $a * $b })