<# 
--- Day 1: Sonar Sweep ---

Count the number of times a depth measurement increases from the previous measurement. 
There is no measurement before the first measurement. In the example above, the changes are as follows:
199 (N/A - no previous measurement)
200 (increased)
208 (increased)
210 (increased)
200 (decreased)
207 (increased)
240 (increased)
269 (increased)
260 (decreased)
263 (increased) 
#>

$year, $day = 2021, 1

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$measurements = $lines.Split() | ForEach-Object { [int]$_ }

$increased = 0
foreach ($index in (0..($measurements.Length - 2))) {
    $increased += ($measurements[$index + 1] -gt $measurements[$index] )
}
Write-Warning $increased

<#
Considering every single measurement isn't as useful as you expected: there's just too much noise in the data.

Instead, consider sums of a three-measurement sliding window. 
In the above example, the sum of each three-measurement window is as follows:

A: 607 (N/A - no previous sum)
B: 618 (increased)
C: 618 (no change)
D: 617 (decreased)
E: 647 (increased)
F: 716 (increased)
G: 769 (increased)
H: 792 (increased)

In this example, there are 5 sums that are larger than the previous sum.

Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?
#>
$sliding_window = [int[]]::new($measurements.Count - 2)
foreach ($index in (0..($measurements.Count - 3))) {
    $sliding_window[$index] = $measurements[$index] + $measurements[$index + 1] + $measurements[$index + 2] 
}
$increased = 0
foreach ($index in (0..($measurements.Length - 4))) {
    $increased += ($measurements[$index + 3] -gt $measurements[$index] )
}
Write-Warning $increased