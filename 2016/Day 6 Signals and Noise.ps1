<#--- Day 6: Signals and Noise ---
The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

Given the recording in your puzzle input, what is the error-corrected version of the message being sent?#>
<#--- Part Two ---
Even after signal-jamming noise, you can look at the letter distributions in each column and 
choose the least common letter to reconstruct the original message.#>

$year, $day = 2016, 6

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}

$characters = (1..$lines[0].Length) | ForEach-Object { @{} }

$lines.ForEach({
        $chars = $_.toCharArray()
        foreach ($bucket in (0..($_.length - 1))) {
            try {
                $characters[$bucket].Add($chars[$bucket], 1)
            }
            catch {
                $characters[$bucket][$chars[$bucket]] += 1
            }
        }
    })
$message = $characters.ForEach({ ($_.GetEnumerator() | Sort-Object Value | Select-Object -First 1).Name }) -join ''
Write-Warning $message