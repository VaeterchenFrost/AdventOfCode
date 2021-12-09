<#--- Day 1: No Time for a Taxicab ---

You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.
The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.
There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

For example:

    Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
    R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
    R5, L5, R5, R3 leaves you 12 blocks away.

How many blocks away is Easter Bunny HQ? #>

$file = $PSScriptRoot + "/input1"
$directions = (Get-Content(Get-ChildItem ($file))) -split ', '

$North, $East_, $South, $West_ = 0..3
$face = 0 
$x = $y = 0

foreach ($direction in $directions) {
    $face = ($face - 1 + 2 * $direction.StartsWith("R") + 4) % 4
    
    switch ($face) {
        $North { $y += $direction.Substring(1) ; break }
        $East_ { $x += $direction.Substring(1) ; break }
        $South { $y -= $direction.Substring(1) ; break }
        $West_ { $x -= $direction.Substring(1) ; break }
    }
}
Write-Warning ([math]::Abs($x) + [math]::Abs($y))

<#--- Part Two ---

Then, you notice the instructions continue on the back of the Recruiting Document. 
Easter Bunny HQ is actually at the first location you visit twice.
For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due Easts.
How many blocks away is the first location you visit twice?#>

$face = 0 
$x = $y = 0
$visited = New-Object 'System.Collections.Generic.HashSet[Tuple[int,int]]'
:travel foreach ($direction in $directions) {
    $face = ($face - 1 + 2 * $direction.StartsWith("R") + 4) % 4
    $distance = $direction.Substring(1)
    switch ($face) {
        $North { (1..$distance).ForEach({ if (-not $visited.Add([Tuple]::Create($x, ++$y))) { break travel } }) }
        $East_ { (1..$distance).ForEach({ if (-not $visited.Add([Tuple]::Create(++$x, $y))) { break travel } }) }
        $South { (1..$distance).ForEach({ if (-not $visited.Add([Tuple]::Create($x, --$y))) { break travel } }) }
        $West_ { (1..$distance).ForEach({ if (-not $visited.Add([Tuple]::Create(--$x, $y))) { break travel } }) }
    }
}
Write-Warning ([math]::Abs($x) + [math]::Abs($y))