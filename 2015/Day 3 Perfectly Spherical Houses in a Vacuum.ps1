<# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
https://adventofcode.com/2015/day/3
Santa is delivering presents to an infinite two-dimensional grid of houses.

He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.

However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off, and Santa ends up visiting some houses more than once. 
How many houses receive at least one present?
#>

$year, $day = 2015, 3

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile
$characters = $lines.ToCharArray()

function visit ($instructions) {
    $x = $y = 0
    $visited = New-Object 'System.Collections.Generic.HashSet[String]'
    [void]$visited.Add("$x,$y")
    foreach ($char in $instructions) {
        if ($char -eq 'v') { $y -= 1 }
        elseif ($char -eq '>') { $x += 1 }
        elseif ($char -eq '^') { $y += 1 }
        else { $x -= 1 }
        [void]$visited.Add("$x,$y")
    }  
    return $visited
}

(visit $characters).count | Write-Warning

<# The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents with him.
Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), 
then take turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous year.

This year, how many houses receive at least one present? #>

$santa_instr = $robo_santa_instr = @() 

while ($characters) { $s, $r, $characters = $characters; $santa_instr += $s; $robo_santa_instr += $r }
$visited_count = (visit $santa_instr) + (visit $robo_santa_instr) | Select-Object -Unique | Measure-Object

$visited_count.Count | Write-Warning
