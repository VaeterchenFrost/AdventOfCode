<#--- Day 4: Security Through Obscurity ---

Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.
Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.
A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

    aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
    a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
    not-a-real-room-404[oarel] is a real room.
    totally-real-room-200[decoy] is not.

Of the real rooms from the list above, the sum of their sector IDs is 1514.

What is the sum of the sector IDs of the real rooms?#>
<#--- Part Two ---

To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.
For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

What is the sector ID of the room where North Pole objects are stored?#>

$year, $day = 2016, 4

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$sum = 0
function rotate ($char, $num) {
    return [char]((([int]$char - 97 + $num) % 26) + 97)
}
$lines.ForEach({
        $split = $_.Split('-')
        $id, $checksum = $split[-1] -split '\['
        $countnames = $split.count - 2
        $commonletters = (($split[0..$countnames] -join '').toCharArray() | 
            Group-Object | 
            Sort-Object @{ Expression = 'Count'; Descending = $true }, @{ Expression = 'Name' })
        if ((0..4) | ForEach-Object { $commonletters[$_].Name -eq $checksum[$_] } | Test-All) {
            $room = (($split[0..$countnames] | ForEach-Object { $_.toCharArray() | ForEach-Object { rotate $_ $id } }) -join '')
            if ($room -match 'northpole') {
                Write-Warning "$room at $id"
            }
            $sum += [int]$id
        }  
    })

Write-Warning $sum
