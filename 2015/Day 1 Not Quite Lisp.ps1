<# --- Day 1: Not Quite Lisp ---
An opening parenthesis, (, means he should go up one floor, and a closing parenthesis, ), means he should go down one floor.

The apartment building is very tall, and the basement is very deep; he will never find the top or bottom floors.
To what floor do the instructions take Santa? #>

$year, $day = 2015, 1

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
    $lines = Get-Content $inputfile
}

$c = $lines.ToCharArray()
$counter = 0
(1..$text.Length).foreach({ $counter += 1 - 2 * ($c[$_ - 1] -eq ')'); if ($counter -lt 0) { Write-Warning $_; break } })
Write-Warning $counter

<# --- Part Two ---

Now, given the same instructions, find the position of the first character that causes him to enter the basement (floor -1). The first character in the instructions has position 1, the second character has position 2, and so on.

For example:

    ) causes him to enter the basement at character position 1.
    ()()) causes him to enter the basement at character position 5.

What is the position of the character that causes Santa to first enter the basement? #>
