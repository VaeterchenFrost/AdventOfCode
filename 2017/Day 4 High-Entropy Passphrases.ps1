<# --- Day 4: High-Entropy Passphrases ---
To ensure security, a valid passphrase must contain no duplicate words.

For example:

    aa bb cc dd ee is valid.
    aa bb cc dd aa is not valid - the word aa appears more than once.
    aa bb cc dd aaa is valid - aa and aaa count as different words.

The system's full passphrase list is available as your puzzle input. How many passphrases are valid?#>

$year, $day = 2017, 4

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

Write-Warning $lines.Where({
        -not ($_.Split() | Group-Object).Where({ $_.Count -gt 1 })
    }).Count

<#--- Part Two ---

For added security, yet another system policy has been put in place. 
Now, a valid passphrase must contain no two words that are anagrams of each other - 
that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.#>

Write-Warning $lines.Where({
        $g = $_.Split() | ForEach-Object { ($_.ToCharArray() | Sort-Object) -join '' } | Group-Object; 
        -not $g.where({ $_.Count -gt 1 })
    }).Count