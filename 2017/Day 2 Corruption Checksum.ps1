<#--- Day 1: Inverse Captcha ---
The spreadsheet consists of rows of apparently-random numbers. 
To make sure the recovery process is on the right track, they need you to calculate the spreadsheet's checksum. 
For each row, determine the difference between the largest value and the smallest value; 
the checksum is the sum of all of these differences.
#>
<#--- Part Two ---
It sounds like the goal is to find the only two numbers in each row where one evenly divides the other - 
that is, where the result of the division operation is a whole number. 
They would like you to find those numbers on each line, divide them, and add up each line's result. #>
Import-Module functional -DisableNameChecking

$year, $day = 2017, 2

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

Write-Warning ($lines | ForEach-Object { $d = ($_ -split '\s+') | ForEach-Object { [int]$_ }; # | Sort-Object;
        # $d[-1] - $d[0] } |
        foreach ($item in $d)
        {
            $d.ForEach({ if ($item -ne $_ -and ($item % $_ -eq 0)) { $item / $_ } })
        } } | 
    reduce { $a + $b })
