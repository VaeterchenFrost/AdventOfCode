<# 
--- Day 2: Dive! ---

The submarine seems to already have a planned course (your puzzle input). You should probably figure out where it's going. For example:

forward 5
down 5
forward 8
up 3
down 8
forward 2

After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)

    forward X increases the horizontal position by X units.
    down X increases the depth by X units.
    up X decreases the depth by X units.
#>

$year, $day = 2021, 2

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$horizontal = $depth = 0

foreach ($instruction in $lines) {
    $val = $instruction -split ' '
    if ( $val[0] -eq 'forward' ) { $horizontal += $val[1] }
    elseif ( $val[0] -eq 'down' ) { $depth += $val[1] }
    elseif ($val[0] -eq 'up' ) { $depth -= $val[1] }
    else { Write-Output "error in instruction $instruction" }
}
Write-Warning ($horizontal * $depth)

<#In addition to horizontal position and depth, you'll also need to track a third value, aim, which also starts at 0. The commands also mean something entirely different than you first thought:

    down X increases your aim by X units.
    up X decreases your aim by X units.
    forward X does two things:
        It increases your horizontal position by X units.
        It increases your depth by your aim multiplied by X.

Again note that since you're on a submarine, down and up do the opposite of what you might expect: "down" means aiming in the positive direction.

Now, the above example does something different:

    forward 5 adds 5 to your horizontal position, a total of 5. Because your aim is 0, your depth does not change.
    down 5 adds 5 to your aim, resulting in a value of 5.
    forward 8 adds 8 to your horizontal position, a total of 13. Because your aim is 5, your depth increases by 8*5=40.
    up 3 decreases your aim by 3, resulting in a value of 2.
    down 8 adds 8 to your aim, resulting in a value of 10.
    forward 2 adds 2 to your horizontal position, a total of 15. Because your aim is 10, your depth increases by 2*10=20 to a total of 60.

After following these new instructions, you would have a horizontal position of 15 and a depth of 60. (Multiplying these produces 900.)
#>

$horizontal = $depth = $aim = 0

foreach ($instruction in $lines) {
    $val = $instruction -split ' '
    if ( $val[0] -eq 'forward' ) { $horizontal += $val[1]; $depth += $aim * $val[1] }
    elseif ( $val[0] -eq 'down' ) { $aim += $val[1] }
    elseif ($val[0] -eq 'up' ) { $aim -= $val[1] }
    else { Write-Output "error in instruction $instruction" }
}
Write-Warning ($horizontal * $depth)