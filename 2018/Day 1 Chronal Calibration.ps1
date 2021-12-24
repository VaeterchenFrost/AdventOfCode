<# --- Day 1: Chronal Calibration ---
Below the message, the device shows a sequence of changes in frequency (your puzzle input). 
A value like +6 means the current frequency increases by 6; a value like -3 means the current frequency decreases by 3.
Starting with a frequency of zero, what is the resulting frequency after all of the changes in frequency have been applied? #>

$year, $day = 2018, 1

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}

$seen = New-Object 'System.Collections.Generic.HashSet[int]'
$c = $frequency = 0
while ($seen.Add($frequency)) {
    $frequency += [int]$lines[$c]
    $c = ++$c % $lines.count 
}
Write-Warning $frequency
