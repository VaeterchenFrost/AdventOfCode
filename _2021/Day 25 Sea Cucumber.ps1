<# Day 25: Sea Cucumber
https://adventofcode.com/2021/day/25

There are two herds of sea cucumbers sharing the same region; one always moves east (>), while the other always moves south (v). 
Each location can contain at most one sea cucumber; the remaining locations are empty (.). 
The submarine helpfully generates a map of the situation (your puzzle input).
Every step, the sea cucumbers in the east-facing herd attempt to move forward one location, 
then the sea cucumbers in the south-facing herd attempt to move forward one location. 
When a herd moves forward, every sea cucumber in the herd first simultaneously considers 
whether there is a sea cucumber in the adjacent location it's facing (even another sea cucumber facing the same direction), 
and then every sea cucumber facing an empty location simultaneously moves into that location.
Due to strong water currents in the area, sea cucumbers that move off the right edge of the map appear on the left edge, 
and sea cucumbers that move off the bottom edge of the map appear on the top edge. 
Sea cucumbers always check whether their destination location is empty before moving, 
even if that destination is on the opposite side of the map:
To find a safe place to land your submarine, the sea cucumbers need to stop moving.
Find somewhere safe to land your submarine. What is the first step on which no sea cucumbers move?#>


$year, $day = 2021, 25

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
load_aoc_input $year $day $inputfile | Out-Null

$output = (wolframscript.exe -c ('
    field = Characters@StringSplit[ReadString[File[\"' + $inputfile + '\"]]];
    moveRightInArray[char_String, empty_ : \".\"] := 
        ArrayFilter[# /. {{_, char, empty} -> empty, {char, empty, _} -> 
            char, {_, x_, _} :> x} &, #, 1, Padding -> \"Periodic\"] &;
    stepSeaCucumbers := 
        Transpose@
            Map[moveRightInArray[\"v\"], Transpose[moveRightInArray[\">\"] /@ #]] &;
    AbsoluteTiming[c = 0; FixedPoint[(c += 1; stepSeaCucumbers@#) &, field]; c]'))

if ($output -match 'password') {
  "Please check the license and possibly concurrent Wolfram kernels ($((Get-Process -Name WolframKernel).Count) WolframKernel, "`
    + "$((Get-Process -Name Mathematica).Count) Mathematica running now)" | Write-Warning
}
else {
  Write-Host $output
  Write-Warning ([regex]::match(($output -split ',')[1], '\d+').Value)
}
