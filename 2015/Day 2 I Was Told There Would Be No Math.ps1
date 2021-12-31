<# --- Day 2: I Was Told There Would Be No Math ---
https://adventofcode.com/2015/day/2
The elves are running low on wrapping paper, and so they need to submit an order for more. They have a list of the dimensions (length l, width w, and height h) of each present, and only want to order exactly as much as they need.

Fortunately, every present is a box (a perfect right rectangular prism), which makes calculating the required wrapping paper for each gift a little easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The elves also need a little extra paper for each present: the area of the smallest side.

For example:

    A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 square feet of wrapping paper plus 6 square feet of slack, for a total of 58 square feet.
    A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 square feet of wrapping paper plus 1 square foot of slack, for a total of 43 square feet.

All numbers in the elves' list are in feet. How many total square feet of wrapping paper should they order?
#>

$year, $day = 2015, 2

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$wrapping_paper = $lines | ForEach-Object { $ar = $_.Split('x') | ForEach-Object { [int]$_ } | Sort-Object; 3 * $ar[0] * $ar[1] + 2 * $ar[0] * $ar[2] + 2 * $ar[1] * $ar[2] } | Measure-Object -Sum
Write-Warning $wrapping_paper.Sum

<# --- Part Two --- How many total feet of ribbon should they order? #>

$ribbon = $lines | ForEach-Object { $ar = $_.Split('x') | ForEach-Object { [int]$_ } | Sort-Object; 2 * ($ar[0] + $ar[1]) + $ar[0] * $ar[1] * $ar[2] } | Measure-Object -Sum
Write-Warning $ribbon.Sum