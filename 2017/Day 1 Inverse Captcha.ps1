<#--- Day 1: Inverse Captcha ---
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match the next digit in the list. 
The list is circular, so the digit after the last digit is the first digit in the list.
#>

$year, $day = 2017, 1

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$t = $lines.ToCharArray()

$c = 0; (1..$t.Length).ForEach({ if ($t[$_ - $t.Length / 2 - 1] -eq $t[$_ - 1]) { $c += $t[$_ - 1] - 48 } })
Write-Warning $c