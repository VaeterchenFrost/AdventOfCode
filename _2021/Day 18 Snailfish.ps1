<# --- Day 18: Snailfish ---
Instead, every snailfish number is a pair - an ordered list of two elements. 
Each element of the pair can be either a regular number or another pair.
To add two snailfish numbers, form a pair from the left and right parameters of the addition operator.
To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:

    If any pair is nested inside four pairs, the leftmost such pair explodes.
    If any regular number is 10 or greater, the leftmost such regular number splits.

To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any), 
and the pair's right value is added to the first regular number to the right of the exploding pair (if any). 
Exploding pairs will always consist of two regular numbers. 
Then, the entire exploding pair is replaced with the regular number 0.

To split a regular number, replace it with a pair; the left element of the pair should be the regular number divided by two and rounded down, 
while the right element of the pair should be the regular number divided by two and rounded up.
The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element. 
The magnitude of a regular number is just that number.
Add up all of the snailfish numbers from the homework assignment in the order they appear. What is the magnitude of the final sum?
#>

$year, $day = 2021, 18

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input${day}" -replace '\\', '/'
load_aoc_input $year $day $inputfile | Out-Null

$output = wolframscript.exe -c ('
tolist = ToExpression[StringReplace[#, {FromCharacterCode[91] -> FromCharacterCode[123], FromCharacterCode[93] -> FromCharacterCode[125]}]]&;
lines = tolist /@ StringSplit[ReadString[\"' + $inputfile + '\"]];
magnitude = ReplaceRepeated[#, List[x_Integer, y_Integer] :> 3 x + 2 y]&;
findexplode = Most@First@Position[#, _, {5}, 1]&;
findsplit = First@Position[#, _?(# >= 10 &), All, 1]&;
findrightleaf[list_, leaf_] := Join[#, First@Position[Part[list, Sequence @@ #], _Integer, {-1}, 1]] &@
    Append[Take[leaf, Last@Last@Position[leaf, 1] - 1], 2];
findleftleaf[list_, leaf_] :=  Join[#,  Last@Position[Part[list, Sequence @@ #], _Integer, {-1}]] &@
    Append[Take[leaf, Last@Last@Position[leaf, 2] - 1], 1]
split[list_] := Module[{posi}, Quiet@Check[posi = findsplit@list;
    ReplacePart[list, posi -> {Floor@#, Ceiling@#} &@(Part[list, Sequence @@ posi]/2)], list]
    ];
explode[listin_] := Module[{list, explode, nextleft, nextright}, list = listin; 
    Quiet@Check[explode = findexplode@list;
        If[Or[AllTrue[explode, # == 1 &], list[[Sequence @@ explode, 1]] == 0], Nothing, 
        nextleft = findleftleaf[list, explode];
        list = ReplacePart[list, nextleft -> 
            Plus[list[[Sequence @@ explode, 1]], list[[Sequence @@ nextleft]]]]
        ];
        If[Or[AllTrue[explode, # == 2 &], list[[Sequence @@ explode, 2]] == 0], Nothing, 
        nextright = findrightleaf[list, explode];
        list = ReplacePart[list, nextright -> 
            Plus[list[[Sequence @@ explode, 2]], list[[Sequence @@ nextright]]]]
        ];
        ReplacePart[list, explode -> 0]
    , list]
    ];
(* Part 1: magnitude@Fold[FixedPoint[split@FixedPoint[explode, #] &, List[#1, #2]] &, lines] // AbsoluteTiming *)
 magnitude@Fold[FixedPoint[split@FixedPoint[explode, #] &, List[#1, #2]] &, #] & /@ 
    Permutations[lines, {2}] // Max // AbsoluteTiming')

<# --- Part Two --- What is the largest magnitude of any sum of two different snailfish numbers from the homework assignment? #>

if ($output -match 'password') {
    "Please check the license and possibly concurrent Wolfram kernels ($((Get-Process -Name WolframKernel).Count) WolframKernel, "`
        + "$((Get-Process -Name Mathematica).Count) Mathematica running now)" | Write-Warning
}
else {
    Write-Host $output
    Write-Warning ([regex]::match(($output -split ',')[1], '\d+').Value)
}
