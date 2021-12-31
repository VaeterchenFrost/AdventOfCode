<#--- Day 20: Trench Map ---
The image enhancement algorithm describes how to enhance an image by simultaneously converting all pixels in the input image into an output image. 
Each pixel of the output image is determined by looking at a 3x3 square of pixels centered on the corresponding input image pixel.
Starting from the top-left and reading across each row, these pixels are ..., then #.., then .#.; combining these forms ...#...#.. 
By turning dark pixels (.) into 0 and light pixels (#) into 1, the binary number 000100010 can be formed, which is 34 in decimal.

The image enhancement algorithm string is exactly 512 characters long, enough to match every possible 9-bit binary number.
In the middle of this first group of characters, the character at index 34 can be found: #. 
So, the output pixel in the center of the output image should be #, a light pixel.
The small input image you have is only a small region of the actual infinite input image; 
the rest of the input image consists of dark pixels.
Start with the original input image and apply the image enhancement algorithm twice, being careful to account for the infinite size of the images. 
How many pixels are lit in the resulting image?#>

$year, $day = 2021, 20

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
load_aoc_input $year $day $inputfile | Out-Null

<# --- Part Two --- 
Start again with the original input image and apply the image enhancement algorithm 50 times. 
How many pixels are lit in the resulting image? #>

$wolframcode = 'AbsoluteTiming@(
    lines = Characters@StringSplit[ReadString[\"' + $inputfile + '\"]]/. {\".\" -> 0, \"#\" -> 1};
    Total[CellularAutomaton[<|
        \"RuleNumber\" -> FromDigits[Reverse@First@lines, 2], \"Dimension\" -> 2, \"Neighborhood\" -> 9|>
        , {lines[[2 ;;]] , 0}, {{{#1}}, All}]
    , Infinity])&'
$output = @()
$iterations = (2, 50)
$iterations.Foreach({ 
        $output += (wolframscript.exe -fun $wolframcode -s Integer -args $_);
        Write-Debug "$_ : $output" })
$output | ForEach-Object { Write-Warning ([regex]::match(($_ -split ',')[1], '\d+').Value) }
