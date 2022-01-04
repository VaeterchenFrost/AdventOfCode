<# --- Day 12: Dumbo Octopus ---
Not just a path - the only way to know if you've found the best path is to find all of them.

Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input). For example:

start-A
start-b
A-c
A-b
b-d
A-end
b-end
This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. 
An entry like b-d means that cave b is connected to cave d - that is, you can move between them.
How many paths through this cave system are there that visit small caves at most once? #>

$year, $day = 2021, 12

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
load_aoc_input $year $day $inputfile | Out-Null

$ret = python.exe "$PSScriptRoot/Day 12 Passage Pathing.py"
$ret | Write-Warning
