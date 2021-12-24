<#--- Day 8: Seven Segment Search ---

Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg
 
 Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. 
 Within an entry, the same wire/segment connections are used

 Because the digits 1, 4, 7, and 8 each use a unique number of segments, 
 you should be able to tell which combinations of signals correspond to those digits. 
 Counting only digits in the output values (the part after | on each line), in the above example, 
 there are 26 instances of digits that use a unique number of segments (highlighted above).

 In the output values, how many times do digits 1, 4, 7, or 8 appear? #>

$year, $day = 2021, 8

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
  $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
  Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
  Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
  $lines = Get-Content $inputfile
}

Write-Warning $lines.ForEach({ $_.Split('|')[1].Split(' ').Where({ (2, 4, 3, 7) -contains $_.length }) }).Count

<# --- Part Two ---
Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

 dddd
e    a
e    a
 ffff
g    b
g    b
 cccc
So, the unique signal patterns would correspond to the following digits:

acedgfb: 8
cdfbe: 5
gcdfa: 2
fbcad: 3
dab: 7
cefabd: 9
cdfgeb: 6
eafb: 4
cagedb: 0
ab: 1
Then, the four digits of the output value can be decoded:

cdfeb: 5
fcadb: 3
cdfeb: 5
cdbaf: 3
Therefore, the output value for this entry is 5353.

Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

fdgacbe cefdb cefbgd gcbe: 8394
fcgedb cgb dgebacf gc: 9781
cg cg fdcagb cbg: 1197
efabcd cedba gadfec cb: 9361
gecf egdcabf bgf bfgea: 4873
gebdcfa ecba ca fadegcb: 8418
cefg dcbef fcge gbcadfe: 4548
ed bcgafe cdgba cbgef: 1625
gbdfcae bgc cg cgb: 8717
fgae cfgab fg bagce: 4315
Adding all of the output values in this larger example produces 61229.

For each entry, determine all of the wire/segment connections and decode the four-digit output values. 
What do you get if you add up all of the output values? #>

$letters = @{
  0 = 'a', 'b', 'c', 'e', 'f', 'g'; 
  # 1 = 'c', 'f'; 
  2 = 'a', 'c', 'd', 'e', 'g'; 
  3 = 'a', 'c', 'd', 'f', 'g'; 
  # 4 = 'b', 'c', 'd', 'f'; 
  5 = 'a', 'b', 'd', 'f', 'g'; 
  6 = 'a', 'b', 'd', 'e', 'f', 'g'; 
  # 7 = 'a', 'c', 'f';
  # 8 = 'a', 'b', 'c', 'd', 'e', 'f', 'g'; 
  9 = 'a', 'b', 'c', 'd', 'f', 'g' 
}

$result = 0
foreach ($line in $lines) {
  $leftpart, $rightpart = $line.Split('|')
  $words = ($leftpart | Select-String '(\w+)' -AllMatches).Matches.Value
  $counts = ($leftpart | Select-String '(\w)' -AllMatches).Matches.Value | Group-Object | Select-Object Name, Count
  $outputvalues = ($rightpart | Select-String '(\w+)' -AllMatches).Matches.Value
  $wiring = @{
    $counts.Where({ $_.count -eq 8 -and
      ($words.Where({ $_.length -eq 2 }) -notmatch $_.Name) 
      }).name = 'a'; 
    $counts.Where({ $_.count -eq 6 }).name = 'b';
    $counts.Where({ $_.count -eq 8 -and 
      ($words.Where({ $_.length -eq 2 }) -match $_.Name) 
      }).name = 'c';
    $counts.Where({ $_.count -eq 7 -and 
    ($words.Where({ $_.length -eq 4 }) -match $_.Name) 
      }).name = 'd';
    $counts.Where({ $_.count -eq 4 }).name = 'e';
    $counts.Where({ $_.count -eq 9 }).name = 'f';
    $counts.Where({ $_.count -eq 7 -and
      ($words.Where({ $_.length -eq 4 }) -notmatch $_.Name) 
      }).name = 'g';
  }

  $lineresult = ''
  foreach ($string in $outputvalues) { # can also check the length of strings and shortcut the bigger selection
    if ($string.Length -eq 2) { $lineresult += 1 }
    elseif ($string.Length -eq 3) { $lineresult += 7 }
    elseif ($string.Length -eq 4) { $lineresult += 4 }
    elseif ($string.Length -eq 7) { $lineresult += 8 }
    else {
      $segment = ($string -split '')[1..$string.Length].ForEach({ $wiring[$_] })
      Write-Debug ($segment -join '')
      $lineresult += $letters.keys.Where({ -not (Compare-Object $segment $letters[$_]) })
    }
  } 
  $result += [int]$lineresult
  Write-Debug "Result of $outputvalues : $lineresult"
}
Write-Warning $result
