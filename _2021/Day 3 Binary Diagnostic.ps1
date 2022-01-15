<#
Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:

$instructions = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010" -split "\n"

Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.
The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.
The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.
So, the gamma rate is the binary number 10110, or 22 in decimal.
The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal. 
Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.
Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine?
#>

$year, $day = 2021, 3

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$instructions = $lines
$stringlength = $instructions[0].Length
$c = [int[]]::new($stringlength)

$instructions | ForEach-Object { $bits = $_ -split ''; 
    foreach ($index in (0..($c.Count - 1))) 
    { $c[$index] += [int]($bits[$index + 1]) } 
}
$c = $c | ForEach-Object { [int]($_ -gt $instructions.Count / 2) }

$gamma = [Convert]::ToInt32(($c -join ''), 2)
$epsilon = [Convert]::ToInt32($c.foreach({ 1 - $_ }) -join '', 2)

Write-Warning ($gamma * $epsilon)

<#
Before searching for either rating value, start with the full list of binary numbers from your diagnostic report and consider just the first bit of those numbers. Then:

    Keep only numbers selected by the bit criteria for the type of rating value for which you are searching. Discard numbers which do not match the bit criteria.
    If you only have one number left, stop; this is the rating value for which you are searching.
    Otherwise, repeat the process, considering the next bit to the right.

The bit criteria depends on which type of rating value you want to find:

    To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 1 in the position being considered.
    To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 0 in the position being considered.
Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together.
#>
$set1 = $instructions.Where({ $_[0] -eq '1' })
$set0 = $instructions.Where({ $_[0] -eq '0' })
if ($set1.count -ge $set0.count) {
    $oxygen_generator_rating = $set1
    $co2_scrubber_rating = $set0
}
else {
    $oxygen_generator_rating = $set0
    $co2_scrubber_rating = $set1
}

foreach ($index in (1..($stringlength - 1))) {
    Write-Debug "$index index"
    if ($oxygen_generator_rating.count -gt 1) {
        $group = $oxygen_generator_rating | Group-Object { $_[$index] -eq '1' }
        $oxygen_generator_rating = ($group | Sort-Object Count | Select-Object -Last 1).Group
    }
    Write-Debug $oxygen_generator_rating.count
    if ($co2_scrubber_rating.count -gt 1) {
        $group = $co2_scrubber_rating | Group-Object { $_[$index] -eq '1' }
        $co2_scrubber_rating = ($group | Sort-Object Count | Select-Object -First 1).Group
    }
    Write-Debug $co2_scrubber_rating.count
}
Write-Debug $oxygen_generator_rating[0]
Write-Debug $co2_scrubber_rating[0]
Write-Warning ([Convert]::ToInt32($oxygen_generator_rating[0], 2) * [Convert]::ToInt32($co2_scrubber_rating[0], 2))
