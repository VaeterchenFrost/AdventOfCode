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

# Duration ~ 3.7 seconds
$doorid = 'ffykfhsq'
$password = ''
$integer = 0

$md5 = [System.Security.Cryptography.MD5]::Create()

while ($password.Length -lt 8) {
    $string = $doorid + $integer++
    $bytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($string))
    # $hash = $bytes | ForEach-Object { $_.ToString('x2') } | Join-String -Separator ''
    # if (-not ($integer % 100000)) { Write-Debug $integer }
    if ($bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -lt 16) {
        $password += $bytes[2].tostring('x')
        Write-Debug "Found hash at $integer"
        Write-Debug "Password is now $password"
    }
}
Write-Warning $password