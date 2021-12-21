<#--- Day 7: Internet Protocol Version 7 ---

While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).

An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.

For example:

    abba[mnop]qrst supports TLS (abba outside square brackets).
    abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
    aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
    ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).

How many IPs in your puzzle input support TLS?
#>

$day = 7

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($text = Get-Content $inputfile)) {
    $request = Invoke-WebRequest -Uri "https://adventofcode.com/2016/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
    Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
    $text = $request.Content
    Out-File -FilePath $inputfile -InputObject $text.Trim()
}

$supportTLS = foreach ($line in $text.Split('\n')) {
    $brackets = $bad = $good = $false
    (0..($line.Length - 4)).foreach( { 
            if ($line[$_] -eq '[') { $brackets = $true }; 
            if ($line[$_] -eq ']') { $brackets = $false }; 
            $pali = ($line[$_] -eq $line[$_ + 3] -and $line[$_ + 1] -eq $line[$_ + 2] -and $line[$_] -ne $line[$_ + 1]) 
            $good = $good -or ($pali -and -not $brackets)
            $bad = $bad -or ($pali -and $brackets)
        })
    $good -and -not $bad
}
Write-Warning ($supportTLS.Where({ $_ }).count)  

<#--- Part Two ---

#>