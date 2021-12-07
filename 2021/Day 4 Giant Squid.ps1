<#
Day 4: Giant Squid
Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. 
Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) 
If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. 
Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

To guarantee victory against the giant squid, figure out which board will win first. 
What will your final score be if you choose that board?
#>

$file = $PSScriptRoot + "/input4"
$bordsize = 5
$lines = Get-Content(Get-ChildItem ($file))
$boardcount = ($lines.Count - 1) / ($boardsize + 1)
$draws = $lines[0] -split ","

$boards = @{}
foreach ($board in (1..$boardcount)) {
    $boards[$board] = (1..$bordsize).ForEach({ [regex]::Split($lines[$board * (1 + $boardsize) + $_], "\s+").ForEach({ [int]$_ }) })
}
$rows = (1..$bordsize).ForEach({ $_ * $boardsize - $_ })
($boardsize..$draws.Count).ForEach({
        # go through all rows and columns to check if one is contained in cúrrent draw
        $draw = $draws[0..($_ - 1)]
        foreach ($board in $boards) {
            (1..$bordsize).ForEach({

                    if (
                ($board[($bordsize * $_)..($bordsize * ($_ + 1))] | ForEach-Object { $draw -contains $_ } | Test-All) -or 
                ($board[#todo] | ForEach-Object { $draw -contains $_ } | Test-All)
                    ) {
                        # handle found board

                    }
                })
        }
    })