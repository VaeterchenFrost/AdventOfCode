<#
Each image tile has been rotated and flipped to a random orientation. 
Your first task is to reassemble the original image by orienting the tiles so they fit together.

To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. 
All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. 
Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.
#>
function borderToInt ($instring) {
    ($instring | Select-String "#" -AllMatches).Matches.Index  
    | ForEach-Object { [math]::Pow(2, $_) } 
    | reduce { $a + $b }
}

$file = $PSScriptRoot + "/input20"
$tilesize = 10 # manual
$parsed = @{}
$it = [System.IO.File]::ReadLines($file)

while ($it.MoveNext()) {
    $line = $it.Current
    if ($line -match "T") {
        #found tile
        $it.MoveNext()
        $top = borderToInt($it.Current)
        $lefts = $it.Current[0]
        $rights = $it.Current[-1]
        (2..$tilesize) | % { $it.MoveNext() # down to bottom
            $lefts += $it.Current[0]
            $rights += $it.Current[-1]
        }
        $bottom = borderToInt($it.Current)
        $left_side = borderToInt($lefts)
        $right_side = borderToInt($rights)
        $parsed[$line] = @($right_side, $top, $left_side, $bottom)
    }
}

