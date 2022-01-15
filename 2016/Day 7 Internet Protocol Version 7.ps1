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

$year, $day = 2016, 7

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$text = load_aoc_input $year $day $inputfile

$supportTLS = foreach ($line in $text.Split())
{
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
You would also like to know which IPs support SSL (super-secret listening).

An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), 
and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. 
An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. 
A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.
How many IPs in your puzzle input support SSL? #>
$abas = New-Object 'System.Collections.Generic.HashSet[string]'
$babs = New-Object 'System.Collections.Generic.HashSet[string]'
$supportSSL = foreach ($line in $text.Split())
{
    $brackets = $good = $false
    foreach ($c in 0..($line.Length - 3))
    { 
        if ($line[$c] -eq '[') { $brackets = $true; continue }
        elseif ($line[$c] -eq ']') { $brackets = $false; continue }
        if ('[', ']' -contains $line[$c + 1]  ) { continue }
        elseif ($line[$c] -eq $line[$c + 2] -and $line[$c] -ne $line[$c + 1])
        {
            if (-not $brackets -and $abas.Add(($line[$c..($c + 2)] -join '')) -and 
                $babs.Contains(($line[$c + 1], $line[$c], $line[$c + 1] -join ''))) { $good = $true ; break } 
            if ( $brackets -and $babs.Add(($line[$c..($c + 2)] -join '')) -and 
                $abas.Contains(($line[$c + 1], $line[$c], $line[$c + 1] -join ''))) { $good = $true ; break }              
        }
    }
    Write-Debug "$good for $line"
    Write-Debug "$abas"
    Write-Debug "$babs"
    $abas.Clear()
    $babs.Clear()
    $good
}
Write-Warning ($supportSSL.Where({ $_ }).count)  