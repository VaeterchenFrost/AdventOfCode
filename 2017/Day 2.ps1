<#--- Day 1: Inverse Captcha ---
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match the next digit in the list. 
The list is circular, so the digit after the last digit is the first digit in the list.
#>

$file = $PSScriptRoot + '/input2'
$t = (Get-Content(Get-ChildItem ($file)))
Write-Warning ($t | ForEach-Object { $d = ($_ -split '\s+') | ForEach-Object { [int]$_ }; foreach ($item in $d) {
            $d.ForEach({ if ($item -ne $_ -and ($item % $_ -eq 0)) { $item / $_ } })
        } } | 
    reduce { $a + $b })
