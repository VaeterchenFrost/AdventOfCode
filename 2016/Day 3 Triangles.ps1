<#--- Day 3: Squares With Three Sides ---
The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.
In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.
In your puzzle input, how many of the listed triangles are possible?#>
Import-Module functional -DisableNameChecking

$file = $PSScriptRoot + "/input3"
$lines = (Get-Content(Get-ChildItem ($file))) 

function findnumbers($string) {
    ($string | Select-String '(\d+)' -AllMatches).Matches.Value | % { [int]$_ }
}

Write-Warning ($lines.foreach({
    (findnumbers $_ | Sort-Object -Descending | reduce { $a - $b }) -lt 0
        }) | Measure-Object -Sum).Sum

<#--- Part Two ---
Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. 
Each set of three numbers in a column specifies a triangle. Rows are unrelated.
For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:

101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603

In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?#>
$valid = 0
foreach ($line in $lines) {
    $l1 = findnumbers $line
    [void]$foreach.movenext()
    $l2 = findnumbers $foreach.current
    [void]$foreach.movenext()
    $l3 = findnumbers $foreach.current
    $valid += (0..($l1.Count - 1)).ForEach({
        (($l1[$_], $l2[$_], $l3[$_]) | Sort-Object -Descending | reduce { $a - $b }) -lt 0
        }) | Measure-Object -Sum | ForEach-Object { $_.sum }
}
Write-Warning $valid
