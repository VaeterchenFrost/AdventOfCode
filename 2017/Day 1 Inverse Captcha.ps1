<#--- Day 1: Inverse Captcha ---
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match the next digit in the list. 
The list is circular, so the digit after the last digit is the first digit in the list.
#>

$year, $day = 2017, 1

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}

$t = $lines.ToCharArray()

$c = 0; (1..$t.Length).ForEach({ if ($t[$_ - $t.Length / 2 - 1] -eq $t[$_ - 1]) { $c += $t[$_ - 1] - 48 } })
Write-Warning $c