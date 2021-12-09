<#--- Day 2: Bathroom Security ---
You picture a keypad like this:

1 2 3
4 5 6
7 8 9

The document goes on to explain that each button to be pressed can be found by starting on the previous button 
and moving to adjacent buttons on the keypad: U moves up, D moves down, L moves left, and R moves right. 
Each line of instructions corresponds to one button, starting at the previous button (or, for the first line, the "5" button); 
press whatever button you're on at the end of each line. 
If a move doesn't lead to a button, ignore it.
Your puzzle input is the instructions from the document you found at the front desk. 
What is the bathroom code?#>
<#--- Part Two ---

You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:

    1
  2 3 4
5 6 7 8 9
  A B C
    D

You still start at "5" and stop when you're at an edge #>

$file = $PSScriptRoot + "/input2"
$directions = (Get-Content(Get-ChildItem ($file))) 

$x = $y = 0
$code = ''
$directions.ForEach({
        foreach ($instruction in ($_.ToCharArray())) {
            Write-Host $instruction
            switch ($instruction) {
                'D' { $y = [Math]::Min($y + 1, 1) }
                'U' { $y = [Math]::Max($y - 1, -1) }
                'L' { $x = [Math]::Max($x - 1, -1) }
                'R' { $x = [Math]::Min($x + 1, 1) }
            }
        }
        $code += $y * 3 + $x + 5 
    })
Write-Warning $code
