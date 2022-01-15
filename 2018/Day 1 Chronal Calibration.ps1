<# --- Day 1: Chronal Calibration ---
Below the message, the device shows a sequence of changes in frequency (your puzzle input). 
A value like +6 means the current frequency increases by 6; a value like -3 means the current frequency decreases by 3.
Starting with a frequency of zero, what is the resulting frequency after all of the changes in frequency have been applied? #>

$year, $day = 2018, 1

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$seen = New-Object 'System.Collections.Generic.HashSet[int]'
$c = $frequency = 0
while ($seen.Add($frequency)) {
    $frequency += [int]$lines[$c]
    $c = ++$c % $lines.count 
}
Write-Warning $frequency
