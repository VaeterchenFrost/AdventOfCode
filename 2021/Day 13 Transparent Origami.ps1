<#Day 13: Transparent Origami

The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input).

0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward.
fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines)
How many dots are visible after completing just the first fold instruction on your transparent paper?#>

$file = $PSScriptRoot + '/input13'
$iterator = [System.IO.File]::ReadLines($file)
$points = New-Object 'System.Collections.Generic.HashSet[Tuple[int,int]]'
while ($iterator.MoveNext() -and $iterator.current -match ',')
{       
    $point = ($iterator.current -split ',') | ForEach-Object { [int]$_ }
    [void]$points.Add([tuple]::Create($point[0], $point[1] ))      
}

while ($iterator.MoveNext())
{
    $instruction, $num = $iterator.Current -split '='
    if ($instruction.endswith('y'))
    {
        Write-Debug "Fold at: y $num"
        $points.Where({ $_.item2 -gt $num }).foreach({
                [void]$points.Remove($_)
                [void]$points.Add([tuple]::Create($_.item1, 2 * $num - $_.item2))
            })
    }
    else
    {
        Write-Debug "Fold at: x $num"
        $points.Where({ $_.item1 -gt $num }).foreach({
                [void]$points.Remove($_)
                [void]$points.Add([tuple]::Create( 2 * $num - $_.item1, $_.item2))
            })
    }  
    Write-Warning $points.Count
    break
}
