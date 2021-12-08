<#
Day 6: Lanternfish
A lanternfish that creates a new fish resets its timer to 6, not 7 (because 0 is included as a valid timer value). 
The new lanternfish starts with an internal timer of 8 and does not start counting down until the next day.
Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, while each other number decreases by 1 if it was present at the start of the day.
Initial state: 3,4,3,1,2
In this example, after 18 days, there are a total of 26 fish. After 80 days, there would be a total of 5934.

Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?
#>

$file = $PSScriptRoot + "/input6"
$numbers = [System.IO.File]::ReadAllText((Get-ChildItem $file)) -split "," | ForEach-Object { [int]$_ }
#$numbers = @(1)

$fishes_per_day = [int[]]::new(9)
$numbers | Group-Object | ForEach-Object { $fishes_per_day[$_.Name] = $_.count }
(1..80).ForEach({
        $spawn = $fishes_per_day[0]
        (0..($fishes_per_day.Count - 2)) | ForEach-Object { $fishes_per_day[$_] = $fishes_per_day[$_ + 1] }
        $fishes_per_day[8] = $spawn
        $fishes_per_day[6] += $spawn
    })