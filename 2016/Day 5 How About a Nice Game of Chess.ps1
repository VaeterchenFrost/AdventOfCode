<#--- Day 5: How About a Nice Game of Chess? ---

You are faced with a security door designed by Easter Bunny engineers that seem to have acquired most of their security knowledge by watching hacking movies.
The eight-character password for the door is generated one character at a time by finding the MD5 hash of some Door ID (your puzzle input) and an increasing integer index (starting with 0).
A hash indicates the next character in the password if its hexadecimal representation starts with five zeroes. If it does, the sixth character in the hash is the next character of the password.

For example, if the Door ID is abc:

    The first index which produces a hash that starts with five zeroes is 3231929, which we find by hashing abc3231929; the sixth character of the hash, and thus the first character of the password, is 1.
    5017308 produces the next interesting hash, which starts with 000008f82..., so the second character of the password is 8.
    The third time a hash starts with five zeroes is for abc5278568, discovering the character f.

In this example, after continuing this search a total of eight times, the password is 18f47a30.
Given the actual Door ID, what is the password?
Your puzzle input is ffykfhsq.#>

# Part 1 duration ~ 3.7 seconds
# Part 2 duration ~ 16 seconds
$expected_length = 8
$doorid = 'ffykfhsq'
$positions = [string[]]::new($expected_length)
$found = 0
$integer = 0

$md5 = [System.Security.Cryptography.MD5]::Create()

while ($found -lt $expected_length) {
    $string = $doorid + $integer++
    $bytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($string))
    # $hash = $bytes | ForEach-Object { $_.ToString('x2') } | Join-String -Separator ''
    # if (-not ($integer % 100000)) { Write-Debug $integer }
    if ($bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -lt 8 -and -not $positions[$bytes[2]]) {
        $positions[$bytes[2]] += $bytes[3].tostring('x').Substring(0, 1)
        $found++
        Write-Debug "Part 2 found $found at $integer"
    }
}
Write-Warning "$($positions -join '')"

<#--- Part Two ---

As the door slides open, you are presented with a second door that uses a slightly more inspired security mechanism. Clearly unimpressed by the last version (in what movie is the password decrypted in order?!), the Easter Bunny engineers have worked out a better solution.

Instead of simply filling in the password from left to right, the hash now also indicates the position within the password to fill. 
You still look for hashes that begin with five zeroes; however, now, the sixth character represents the position (0-7), and the seventh character is the character to put in that position.

A hash result of 000001f means that f is the second character in the password. 
Use only the first result for each position, and ignore invalid positions.#>
