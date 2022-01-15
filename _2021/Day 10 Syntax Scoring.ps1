<# --- Day 10: Syntax Scoring ---
You ask the submarine to determine the best route out of the deep-sea cave, but it only replies:

Syntax error in navigation subsystem on line: all of them
Every chunk must open and close with one of four legal pairs of matching characters:

If a chunk opens with (, it must close with ).
If a chunk opens with [, it must close with ].
If a chunk opens with {, it must close with }.
If a chunk opens with <, it must close with >.
So, () is a legal chunk that contains no other chunks, as is []. More complex but valid chunks include ([]), {()()()}, <([{}])>, [<>({}){}[([])<>]], and even (((((((((()))))))))).

Some lines are incomplete, but others are corrupted. Find and discard the corrupted lines first.

A corrupted line is one where a chunk closes with the wrong character - that is, where the characters it opens and closes with do not form one of the four legal pairs listed above.
take the first illegal character on the line and look it up in the following table:

  ): 3 points.
  ]: 57 points.
  }: 1197 points.
  >: 25137 points.
Find the first illegal character in each corrupted line of the navigation subsystem. What is the total syntax error score for those errors?#>
Import-Module functional -DisableNameChecking

$year, $day = 2021, 10

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

$error_score = @{[char]')' = 3; [char]']' = 57; [char]'}' = 1197; [char]'>' = 25137; }
$score = 0
$stack = [System.Collections.Stack]::new() 
$lines.ForEach({
    Write-Debug $_
    foreach ($c in $_.ToCharArray()) {
      if ( ('(', '<', '[', '{') -contains $c) {
        $stack.Push($c)
      }
      else {
        if (-not $stack.Count -or [math]::Abs($stack.Pop() - $c) -gt 2) {
          $score += $error_score[$c]
          Write-Debug "corrupt $c with stack.Count $($stack.Count)" 
          break
        }
      }
    }
    $stack.Clear()
  })
Write-Warning $score

<#--- Part Two ---
Now, discard the corrupted lines. The remaining lines are incomplete.
You can only use closing characters (), ], }, or >), and you must add them in the correct order 
so that only legal pairs are formed and all chunks end up closed.

It's true! The score is determined by considering the completion string character-by-character. 
Start with a total score of 0. Then, for each character, multiply the total score by 5 and 
then increase the total score by the point value given for the character in the following table:

    ): 1 point.
    ]: 2 points.
    }: 3 points.
    >: 4 points.

Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score? #>

$scores = [System.Collections.Stack]::new() 
$error_score = @{[char]'(' = 1; [char]'[' = 2; [char]'{' = 3; [char]'<' = 4; }
$lines.ForEach({
    Write-Debug $_
    $discard = $false
    foreach ($c in $_.ToCharArray()) {
      if ( ('(', '<', '[', '{') -contains $c) {
        $stack.Push($c)
      }
      else {
        if (-not $stack.Count -or [math]::Abs($stack.Pop() - $c) -gt 2) {   
          $discard = $true
          break
        }
      }
    }
    if (-not $discard) {
      $scores.Push(($stack.ForEach({ $error_score[$_] }) | reduce { 5 * $a + $b }))
      Write-Debug $scores.Peek()
    }
    $stack.Clear()
  })
Write-Warning ($scores | Sort-Object)[(($scores.Count - 1) / 2)]