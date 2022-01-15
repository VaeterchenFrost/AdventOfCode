<#--- Day 20: Firewall Rules ---

You'd like to set up a small hidden computer here so you can use it to get back into the network later. However, the corporate firewall only allows communication with certain external IP addresses.
You've retrieved the list of blocked IPs from the firewall, but the list seems to be messy and poorly maintained, and it's not clear which IPs are allowed. 
Also, rather than being written in dot-decimal notation, they are written as plain 32-bit integers, which can have any value from 0 through 4294967295, inclusive.
For example, suppose only the values 0 through 9 were valid, and that you retrieved the following blacklist:

5-8
0-2
4-7

The blacklist specifies ranges of IPs (inclusive of both the start and end value) that are not allowed. Then, the only IPs that this firewall allows are 3 and 9, since those are the only numbers not in any range.
Given the list of blocked IPs you retrieved from the firewall (your puzzle input), what is the lowest-valued IP that is not blocked?
#>

$year, $day = 2016, 20

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$list = $lines.ForEach({
        $range = $_.split('-').ForEach({ [UInt32]$_ })
        [tuple]::Create($range)
    }) | Sort-Object -Property @{Expression = { $_[0][0] } }

$candidate = $list[0]

while ($candidate) {
    $min, $max = $candidate.Item1
    $set = $list.Where({ $_[0][0] -ge $min -and $_[0][0] -le ($max + 1) -and $_[0][1] -gt $max })
    $candidate = $set | Sort-Object -Property @{Expression = { $_[0][1] } } -Descending -Top 1
}
Write-Warning ($max + 1)

<#--- Part Two ---

How many IPs are allowed by the blacklist?
#>
$result = (wolframscript.exe -c ('
    text = ReadString[File[\"' + $inputfile + '\"]];
    list = ToExpression@StringSplit[#, \"-\"] &@StringSplit[text] // Sort;
    lastmax = First@First@list;
    2^32 - Total@First@Last@Reap@Scan[
        (Sow@Max[0, #[[2]] - Max[#[[1]] - 1, lastmax]];lastmax = Max[lastmax, #[[2]]]) &
        , list] - If[Length@list > 0, 1, 0]')) 
# around 11ms in Mathematica

($result -match 'password') ? "Please check the license and possibly concurrent Wolfram kernels ($((Get-Process -Name WolframKernel).Count) WolframKernel, "`
    + "$((Get-Process -Name Mathematica).Count) Mathematica running now)" 
: $result
| Write-Warning



