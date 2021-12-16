<# --- Day 15: Chiton ---
You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. 
The number at each position is its risk level; to determine the total risk of an entire path, 
add up the risk levels of each position you enter
 (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).

Your goal is to find a path with the lowest total risk.#>
<#--- Part Two ---

The entire cave is actually five times larger in both dimensions than you thought; the area you originally scanned is just 
one tile in a 5x5 tile area that forms the full map. Your original map tile repeats to the right and downward; 
each time the tile repeats to the right or downward, all of its risk levels are 1 higher than the tile immediately up or left of it. 
However, risk levels above 9 wrap back around to 1.
Using the full map, what is the lowest total risk of any path from the top left to the bottom right?#>

$output = (wolframscript.exe -c '
    lines = StringSplit[ReadString[File[\"C:/Users/Martin/Documents/GitHub/AdventOfCode/2021/input15\"]]];
    c = Quiet@Compile[{{levelsin, _Integer, 2}}, levels=levelsin; (*Two lines for Part 2:*)
    levels = Join @@ Table[Mod[levels + i - 1, 9, 1], {i, 5}];
    levels = (Join @@ Table[Mod[# + i - 1, 9, 1], {i, 5}]) & /@ levels;
    llen = Length@First@levels;
    GraphDistance[WeightedAdjacencyGraph@SparseArray[Flatten[Reap[
          Table[
           (Sow[{0, 1} + (line - 1)*llen + # -> levels[[line, # + 1]]];
               Sow[{1, 0} + (line - 1)*llen + # -> 
                levels[[line, #]]]) & /@ Range[llen - 1], {line, 1, 
            Length@levels}];
          Table[(Sow[(# - 1)*llen + column + {0, llen} -> 
                levels[[# + 1, column]]]; 
              Sow[(# - 1)*llen + column + {llen, 0} -> 
                levels[[#, column]]]) & /@ 
            Range[Length@levels - 1], {column, 1, llen}];
          ][[2]], 2], {llen^2, llen^2}, Infinity], 1, llen^2],
    {{llen, _Integer}, {levels, _Integer, 2}}];
 c@ToExpression[Characters /@ lines] // AbsoluteTiming')

Write-Host $output
Write-Warning ($output -split ',')[1].Substring(1, $in[1].Length - 3)