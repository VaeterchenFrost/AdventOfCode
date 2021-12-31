$DOTENVFILE = Resolve-Path '../.env'

function load_aoc_input($year, $day, $inputfile) {
    if (-not ($text = Get-Content $inputfile -ErrorAction SilentlyContinue)) {
        Write-Debug "load_aoc_input for $year/$day to '$inputfile'"
        load_dotenv $DOTENVFILE
        $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:AOC_SESSION"; Accept = 'text/plain' }
        unload_dotenv $DOTENVFILE
        Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
        $text = $request.Content.Trim()
        Out-File -FilePath $inputfile -InputObject $text
        $text = Get-Content $inputfile
    }
    return $text
}

function load_dotenv($filepath) {
    if (Test-Path ($filePath)) {
        foreach ($line in [System.IO.File]::ReadAllLines($filePath)) {
            $line = $line.Trim()
            if (-not $line.StartsWith('#') -and $line.Length -ge 3) {
                $parts = $line.Split('=');
                Write-Verbose "loading env '$($parts[0])'"
                if ($parts.Count -eq 2) {
                    [System.Environment]::SetEnvironmentVariable($parts[0], $parts[1]);
                }
            } 
        }
    }    
}
function unload_dotenv($filepath) {
    if (Test-Path ($filePath)) {
        foreach ($line in [System.IO.File]::ReadAllLines($filePath)) {
            $line = $line.Trim()
            if (-not $line.StartsWith('#') -and $line.Length -ge 3) {
                $parts = $line.Split('=');
                Write-Verbose "removing from env '$($parts[0])'"
                if ($parts.Count -eq 2) {
                    Remove-Item "Env:\$($parts[0])";
                }
            } 
        }
    }    
}
