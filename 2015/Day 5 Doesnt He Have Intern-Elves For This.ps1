<# --- Day 5: Doesn't He Have Intern-Elves For This? ---
https://adventofcode.com/2015/day/5
A nice string is one with all of the following properties:

    It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
    It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.

How many strings are nice? #>

$year, $day = 2015, 5

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile
$vowels = 'aeiou'.ToCharArray()

$selection = $lines.Where({ $ar = $_.toCharArray(); 
        $allowed = $true
        :travel foreach ($pos in (2..$ar.Count)) {
    (('a', 'b'), ('c', 'd'), ('p', 'q'), ('x', 'y')) | 
            ForEach-Object { if (-not($ar[$pos - 2] -ne $_[0] -or $ar[$pos - 1] -ne $_[1])) { $allowed = $false; break travel } }
        };
    ($allowed -and 
    (($ar.where{ $vowels -contains $_ }).count -ge 3) -and
    ((2..$ar.Count) | ForEach-Object { $ar[$_ - 2] -eq $ar[$_ - 1] } | Test-Any)
    ) 
    })
Write-Warning $selection.count
