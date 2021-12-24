<#
Day 6: Lanternfish
A lanternfish that creates a new fish resets its timer to 6, not 7 (because 0 is included as a valid timer value). 
The new lanternfish starts with an internal timer of 8 and does not start counting down until the next day.
Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other number decreases by 1 if it was present at the start of the day.
Initial state: 3,4,3,1,2
In this example, after 18 days, there are a total of 26 fish. After 80 days, there would be a total of 5934.

Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?
--- Part Two ---
Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?
After 256 days in the example above, there would be a total of 26984457539 lanternfish!
How many lanternfish would there be after 256 days?
#>
Import-Module functional -DisableNameChecking

$year, $day = 2021, 6

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}

$numbers = $lines -split "," | ForEach-Object { [int]$_ }
#$numbers = @(1)

$fishes_per_day = [bigint[]]::new(9)
$numbers | Group-Object | ForEach-Object { $fishes_per_day[$_.Name] = $_.count }
(1..256).ForEach({
        $spawn = $fishes_per_day[0]
        (0..($fishes_per_day.Count - 2)) | ForEach-Object { $fishes_per_day[$_] = $fishes_per_day[$_ + 1] }
        $fishes_per_day[8] = $spawn
        $fishes_per_day[6] += $spawn
    })

Write-Warning ($fishes_per_day | reduce { $a + $b })