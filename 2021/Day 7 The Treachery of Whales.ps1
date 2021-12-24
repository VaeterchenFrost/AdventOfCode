<#
--- Day 7: The Treachery of Whales ---

For example, consider the following horizontal positions:

16,1,2,0,4,2,7,1,2,14
This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

Each change of 1 step in horizontal position of a single crab costs 1 fuel. 
You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2
Determine the horizontal position that the crabs can align to using the least fuel possible. 
How much fuel must they spend to align to that position?

--- Part Two ---
The crabs don't seem interested in your proposed solution. Perhaps you misunderstand crab engineering?
As it turns out, crab submarine engines don't burn fuel at a constant rate. 
Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: 
the first step costs 1, the second step costs 2, the third step costs 3, and so on.

As each crab moves, moving further becomes more expensive. 
This changes the best horizontal position to align them all on; in the example above, this becomes 5
#>

$year, $day = 2021, 7

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}
$numbers = $lines -split ',' | ForEach-Object { [int]$_ }

$positions = $numbers | Group-Object | Select-Object Name, Count 
$positions.ForEach({ $_.name = [int]$_.Name }) # string per default

$min = [Int64]::MaxValue # init with highest diff
# find position with lowest difference of larger<->smaller counts
foreach ($position in $positions)
{
    $disorder = [Math]::Abs(($positions.Where({ $_.Name -lt $position.Name }) | Measure-Object -Sum -Property Count).Sum -
        ($positions.Where({ $_.Name -gt $position.Name }) | Measure-Object -Sum -Property Count).Sum )
    Write-Debug "$disorder in $position"
    if ($disorder -gt $min) # minimum was last
    {
        Write-Warning "Found lowest disorder to be in position $before !"
        $fuel = $positions.ForEach({ [Math]::Abs($_.Name - $before) * $_.Count }) | Measure-Object -Sum
        Write-Warning $fuel.Sum
        break;
    }
    $min = $disorder
    $before = $position.Name
}

# Part 2
function fuel2
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object[]]$positions,
        [Parameter(Mandatory)]
        [double]$point
    )
    ($positions.ForEach({ 
            $distance = [Math]::Abs($_.Name - $point); 
($distance * ++$distance) / 2 * $_.Count }) | Measure-Object -Sum).Sum    
}
# check around the balance point to see which integer fits best. 
$optimal_point = ($numbers | Measure-Object -Average).Average
$points = ([Math]::Floor($optimal_point), [Math]::Ceiling($optimal_point))
$fuel = $points.ForEach({ fuel2 $positions $_ })
if ($fuel[0] -lt $fuel[1])
{
    Write-Warning "Found lowest disorder to be in position $($points[0]) !"
    Write-Warning $fuel[0]
} else {
    Write-Warning "Found lowest disorder to be in position $($points[1]) !"
    Write-Warning $fuel[1]
}

