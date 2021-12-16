<#--- Day 1: Inverse Captcha ---
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match the next digit in the list. 
The list is circular, so the digit after the last digit is the first digit in the list.
#>

$file = $PSScriptRoot + '/input1'
$t = (Get-Content(Get-ChildItem ($file))).ToCharArray()

$c = 0; (1..$t.Length).ForEach({ if ($t[$_ - $t.Length / 2 - 1] -eq $t[$_ - 1]) { $c += [int][string]$t[$_ - 1] } })
Write-Warning $c