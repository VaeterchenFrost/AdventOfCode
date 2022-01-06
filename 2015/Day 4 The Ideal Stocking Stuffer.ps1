<# --- Day 4: The Ideal Stocking Stuffer ---
https://adventofcode.com/2015/day/4
Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, 
you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.
#>

$s = 'ckczppom'
$i = 0

$md5 = [System.Security.Cryptography.MD5]::Create()

while (++$i) {
    $bytes = $md5.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($s + $i))
    if ($bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -lt 16) { break }
}

Write-Warning $i
