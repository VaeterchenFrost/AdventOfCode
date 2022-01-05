<#
Day 4: Giant Squid
Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. 
Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) 
If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. 
Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

To guarantee victory against the giant squid, figure out which board will win first. 
What will your final score be if you choose that board?

Part 2: (Commented #)
Figure out which board will win last. Once it wins, what would its final score be?
#>

Import-Module functional -DisableNameChecking

$year, $day = 2021, 4

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$boardsize = 5
$boardcount = ($lines.Count - 1) / ($boardsize + 1)
$draws = $lines[0] -split ","

$boards = @{}
foreach ($board in (1..$boardcount)) {
    $boards[$board] = (1..$boardsize).ForEach({ [regex]::Split($lines[($board - 1) * (1 + $boardsize) + $_ + 1].Trim(), "\s+").ForEach({ [int]$_ }) })
}
# $boards.Values | % { $_.count -eq 25 } | Test-All
$rows = (1..$boardsize).ForEach({ --$_ * $boardsize })

:calculation ($boardsize..$draws.Count).ForEach({
        # go through all rows and columns to check if one is contained in cúrrent draw
        $draw = $draws[0..($_ - 1)]
        # $boards_won = @()
        foreach ($key in $boards.Keys) {
            foreach ($line in (1..$boardsize)) {
                if (
($boards[$key][($boardsize * ($line - 1))..($boardsize * $line - 1)] | ForEach-Object { $draw -contains $_ } | Test-All) -or 
($boards[$key][($rows | % { $_ + $line - 1 })] | ForEach-Object { $draw -contains $_ } | Test-All)
                ) {
                    # $boards_won += ($key)
                    # if (($boards.Count - $boards_won.Count) -eq 0) {
                        # handle found board: sum of all unmarked numbers on that board; Then, multiply that sum by the number that was just called when the board won
                        $sumunmarked = $boards[$key].Where({ $draw -notcontains $_ }) | reduce { $a + $b }
                        Write-Debug "board $key has unmarked $sumunmarked after draw $($draw[-1])"
                        Write-Warning ($sumunmarked * $draw[-1])
                        break calculation
                    # }
                }
            }
        }
        # $boards_won.ForEach({ $boards.Remove($_) })
    })
