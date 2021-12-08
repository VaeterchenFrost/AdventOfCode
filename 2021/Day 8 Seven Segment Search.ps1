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

$file = $PSScriptRoot + '/input8'
$iterator = [System.IO.File]::ReadLines($file)
Write-Warning $iterator.ForEach({ $_.Split('|')[1].Split(' ').Where({ (2, 4, 3, 7) -contains $_.length }) }).Count

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

$iterator = [System.IO.File]::ReadLines($file)
[void]$iterator.MoveNext()
$words = ($iterator.Current.Split('|')[0] | Select-String '(\w+)' -AllMatches).Matches.Value
$counts = ($iterator.Current.Split('|')[0] | Select-String '(\w)' -AllMatches).Matches.Value | Group-Object | Select-Object Name, Count
@{
  $counts.Where({ $_.count -eq 9 }).name = 'f';
  $counts.Where({ $_.count -eq 6 }).name = 'b';
  $counts.Where({ $_.count -eq 4 }).name = 'e';
  $counts.Where({ $_.count -eq 7 -and 
    ($words.Where({ $_.length -eq 4 }) -match $_.Name) 
    }).name = 'd';
  $counts.Where({ $_.count -eq 7 -and
      ($words.Where({ $_.length -eq 4 }) -notmatch $_.Name) 
    }).name = 'g';
  $counts.Where({ $_.count -eq 8 -and 
      ($words.Where({ $_.length -eq 2 }) -match $_.Name) 
    }).name = 'c';
  $counts.Where({ $_.count -eq 8 -and
      ($words.Where({ $_.length -eq 2 }) -notmatch $_.Name) 
    }).name = 'a';

}
$iterator.dispose()