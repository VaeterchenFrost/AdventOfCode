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
# Import-Module functional

$file = $PSScriptRoot + '/input10'
$iterator = [System.IO.File]::ReadLines($file)
$error_score = @{[char]')' = 3; [char]']' = 57; [char]'}' = 1197; [char]'>' = 25137; }
$score = 0
$stack = [System.Collections.Stack]::new() 
$iterator.ForEach({
    Write-Debug $_
    foreach ($c in $_.ToCharArray())
    {
      if ( ('(', '<', '[', '{') -contains $c)
      {
        $stack.Push($c)
      }
      else
      {
        if (-not $stack.Count -or [math]::Abs($stack.Pop() - $c) -gt 2)
        {
          $score += $error_score[$c]
          Write-Debug $c
          break
        }
      }
    }
    $stack.Clear()
  })
Write-Warning $score

