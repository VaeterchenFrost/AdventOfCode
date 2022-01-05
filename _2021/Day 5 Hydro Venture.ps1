<#
Day 5: Hydrothermal Venture

Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end 
of the line segment and x2,y2 are the coordinates of the other end.
These line segments include the points at both ends.

Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
#>

$year, $day = 2021, 5

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$numbers = $lines.foreach(
    { ($_ | Select-String '(\d+)' -AllMatches).Matches.Value | ForEach-Object { [int]$_ } }
)
$min, $max = $numbers | Sort-Object | Select-Object -First 1 -Last 1

$field = New-Object 'int[,]' ($max + 1), ($max + 1)

foreach ($index in (0..($lines.Count - 1))) { 
    $x1, $y1, $x2, $y2 = $numbers[(4 * $index)..(4 * $index + 3)]; 
    # Write-Debug "$x1,$y1->$x2,$y2" # uncomment for Part 1:
    # if ($x1 -eq $x2 -or $y1 -eq $y2) {
    if ($x1 -eq $x2) {
        ($y1..$y2).ForEach({ ++$field[$x1, $_] })
    }
    elseif ($y1 -eq $y2) {
        ($x1..$x2).ForEach({ ++$field[$_, $y1] })
    }
    else {
        $xrange = ($x1..$x2)
        $yrange = ($y1..$y2)
        (1..$xrange.count).ForEach({ ++$field[$xrange[$_ - 1], $yrange[$_ - 1]] })
    }
    # }
}
Write-Warning $field.Where({ $_ -ge 2 }).count 