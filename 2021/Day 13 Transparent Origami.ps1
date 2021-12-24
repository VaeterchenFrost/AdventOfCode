<#Day 13: Transparent Origami

The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input).

0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward.
fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines)
How many dots are visible after completing just the first fold instruction on your transparent paper?#>

$year, $day = 2021, 13

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}
$iterator = $lines.GetEnumerator()

$points = New-Object 'System.Collections.Generic.HashSet[Tuple[int,int]]'
while ($iterator.MoveNext() -and $iterator.current -match ',') {       
    $point = ($iterator.current -split ',') | ForEach-Object { [int]$_ }
    [void]$points.Add([tuple]::Create($point[0], $point[1] ))      
}

while ($iterator.MoveNext()) {
    $instruction, $num = $iterator.Current -split '='
    if ($instruction.endswith('y')) {
        Write-Debug "Fold at: y $num"
        $points.Where({ $_.item2 -gt $num }).foreach({
                [void]$points.Remove($_)
                [void]$points.Add([tuple]::Create($_.item1, 2 * $num - $_.item2))
            })
    }
    else {
        Write-Debug "Fold at: x $num"
        $points.Where({ $_.item1 -gt $num }).foreach({
                [void]$points.Remove($_)
                [void]$points.Add([tuple]::Create( 2 * $num - $_.item1, $_.item2))
            })
    }  
    # Write-Warning $points.Count
    # break
}
<#--- Part Two ---
Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

What code do you use to activate the infrared thermal imaging camera system?#>
$xrange = ($points | Sort-Object -Property Item1 | Select-Object Item1 -Last 1 -First 1).Item1
$yrange = ($points | Sort-Object -Property Item2 | Select-Object Item2 -Last 1 -First 1).Item2
$field = [string[][]]::new(($yrange[1] - $yrange[0] + 1))
(0..($field.Count - 1)).ForEach({ $field[$_] = ($xrange[0]..$xrange[1]).foreach({ '.' }) })
$points.ForEach({
        $field[$_.item2][$_.item1] = '#'
    })

($field | ForEach-Object { $_ -join '' }) | Write-Warning