<#
Each image tile has been rotated and flipped to a random orientation. 
Your first task is to reassemble the original image by orienting the tiles so they fit together.

To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. 
All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. 
Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.
#>
Import-Module functional -DisableNameChecking

function borderToInt ($instring) {
    ($instring | Select-String "#" -AllMatches).Matches.Index  
    | ForEach-Object { [math]::Pow(2, $_) } 
    | reduce { Param($a, $b) $a + $b }
}

function reverse ($inarray) {
    if ($inarray.GetType().Name -eq "String") {
        return ($inarray[-1.. - $inarray.length] -join '')
    }
    return $inarray[-1.. - $inarray.length]
}

function reverse ($inarray) {
    if ($inarray.GetType().Name -eq "String") {
        return ($inarray[-1.. - $inarray.length] -join '')
    }
    return $inarray[-1.. - $inarray.length]
}

$file = $PSScriptRoot + "/input20"
$tilesize = 10 # manual
$parsed = @{}
$it = [System.IO.File]::ReadLines($file)

while ($it.MoveNext()) {
    $line = $it.Current
    if ($line -match "T") {
        write $line
        #found tile
        [void]$it.MoveNext()
        $top = $it.Current
        $lefts = $it.Current[0]
        $rights = $it.Current[-1]
        (2..$tilesize) | % { [void]$it.MoveNext() # down to bottom
            $lefts += $it.Current[0]
            $rights += $it.Current[-1]
        }
        $bottom = $it.Current
        # first 4 are one direction around, the later 4 direction reversed:
        $parsed[$line] = ($rights, $top, (reverse $lefts), (reverse $bottom), (reverse $rights), (reverse $top), $lefts, $bottom) | % { borderToInt $_ }
    }
}

$parsed.Values | reduce { $a + $b } | group | sort Count | select Count, Name
$tilecount = $parsed.Count
$sidelength = [math]::Sqrt($tilecount)