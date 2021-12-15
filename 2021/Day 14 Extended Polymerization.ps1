<#Day 14: Extended Polymerization

The submarine manual contains instructions for finding the optimal polymer formula; 
specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input)
The first line is the polymer template - this is the starting point of the process.

The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, 
element C should be inserted between them. These insertions all happen simultaneously.
Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. 
What do you get if you take the quantity of the most common element and subtract the quantity of the least common element? #>

<#--- Part Two ---
Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. 
What do you get if you take the quantity of the most common element and subtract the quantity of the least common element? #>

Write-Warning (wolframscript.exe -c '
    steps = 40
    lines=StringSplit[ReadString[File[\"C:/Users/Martin/Documents/GitHub/AdventOfCode/2021/input14\"]],\"\n\"]
    (First@Differences@MinMax@(#[[1]] / 2 & /@
        List @@ (Total@Flatten@(MatrixPower[SparseArray[# -> Table[1, Length@#] &@
            (Map[{{#[[2, 1]], #[[1]]}, {#[[2, 2]], #[[1]]}} &, #] /.
                MapIndexed[#1 -> First@#2 &, #[[All, 1]]] // Flatten[#, 1] &),
            {Length@#, Length@#}], steps, Table[0, Length@#] // ReplacePart[
            Rule @@ # & /@ (Tally@Partition[Characters@lines[[1]], 2, 1] /.
                MapIndexed[#1 -> First@#2 &, #[[All, 1]]])]] * #[[All, 1]]) +
        First@Characters@lines[[1]] + Last@Characters@lines[[1]])) &@
    Sort[Map[(Characters@StringTake[#, 2] -> {{StringTake[#, {1}], StringTake[#, {-1}]}, {StringTake[#, {-1}], StringTake[#, {2}]}}) &
            , lines[[3 ;;]]]]) '
)