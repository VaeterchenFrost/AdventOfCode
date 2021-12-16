<# --- Day 1: Not Quite Lisp ---
An opening parenthesis, (, means he should go up one floor, and a closing parenthesis, ), means he should go down one floor.

The apartment building is very tall, and the basement is very deep; he will never find the top or bottom floors.
To what floor do the instructions take Santa? #>

$file = $PSScriptRoot + '/input1'
$text = (Get-Content(Get-ChildItem ($file)))
$c = $text.ToCharArray()
$counter = 0
(1..$text.Length).foreach({ $counter += 1 - 2 * ($c[$_ - 1] -eq ')'); if ($counter -lt 0) { Write-Warning $_; break } })
