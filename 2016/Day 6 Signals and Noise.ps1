<#--- Day 6: Signals and Noise ---
The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

Given the recording in your puzzle input, what is the error-corrected version of the message being sent?#>

$file = $PSScriptRoot + '/input6'
$lines = (Get-Content(Get-ChildItem ($file))) 

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
$message = $characters.ForEach({ ($_.GetEnumerator() | Sort-Object Value | Select-Object -Last 1).Name }) -join ''
Write-Warning $message