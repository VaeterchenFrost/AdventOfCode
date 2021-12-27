<# --- Day 12: Dumbo Octopus ---
Not just a path - the only way to know if you've found the best path is to find all of them.

Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input). For example:

start-A
start-b
A-c
A-b
b-d
A-end
b-end
This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. 
An entry like b-d means that cave b is connected to cave d - that is, you can move between them.
How many paths through this cave system are there that visit small caves at most once? #>

$year, $day = 2021, 12

$inputfile = $PSScriptRoot + "/input${day}"
if (-not ($lines = Get-Content $inputfile)) {
  $request = Invoke-WebRequest -Uri "https://adventofcode.com/${year}/day/${day}/input" -Headers @{Cookie = "session=$env:ADVENTOFCODE_SESSION"; Accept = 'text/plain' }
  Write-Debug "Got $($request.Headers.'Content-Length') Bytes"  
  Out-File -FilePath $inputfile -InputObject $request.Content.Trim()
  $lines = Get-Content $inputfile
}

# Load with $lines -join ' '
# WITH split('start-A start-b A-c A-b b-d A-end b-end',' ') AS lines

# we-NX ys-px ys-we px-end yq-NX px-NX yq-px qk-yq pr-NX wq-EY pr-oe wq-pr ys-end start-we ys-start oe-DW EY-oe end-oe pr-yq pr-we wq-start oe-NX yq-EY ys-wq ys-pr
<#
MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT cave_name_key IF NOT EXISTS
FOR (n:Cave)
REQUIRE n.name IS NODE KEY;

MATCH (n) DETACH DELETE n;
WITH split('we-NX ys-px ys-we px-end yq-NX px-NX yq-px qk-yq pr-NX wq-EY pr-oe wq-pr ys-end start-we ys-start oe-DW EY-oe end-oe pr-yq pr-we wq-start oe-NX yq-EY ys-wq ys-pr',' ') AS lines
UNWIND lines AS line
WITH split(line, '-') AS vertices
MERGE (from:Cave {name: vertices[0]})
MERGE (to:Cave {name: vertices[1]})
MERGE (from)-[:CONNECTED_TO]->(to);
#>

<# Labels:
MATCH (c:Cave)
WITH c, CASE c.name = toLower(c.name)
WHEN true THEN ["Small"] ELSE ["Big"] END AS cave_type
CALL apoc.create.addLabels(c, cave_type)
YIELD node
RETURN node;
#>

<# Via big
MATCH (s1:Small)-[:CONNECTED_TO]-(big:Big)-[:CONNECTED_TO]-(s2:Small)
WHERE id(s1) < id(s2)
MERGE (s1)-[:CONNECTED_TO {via: big.name}]->(s2);
#>

<# Selfloops over big
MATCH (s:Small)-[:CONNECTED_TO]-(big:Big)
WHERE NOT s.name IN ["start", "end"]
MERGE (s)-[:LOOP {via: big.name}]->(s);
#>

<#remove bigs
MATCH (b:Big) DETACH DELETE b;
#>

<# cut outer leafes
MATCH (s:Small)-[:CONNECTED_TO]-(leaf:Small)
WHERE apoc.node.degree(leaf, "CONNECTED_TO") = 1
MERGE (s)-[:LOOP {via: leaf.name}]->(s)
DETACH DELETE leaf;
#>

<# back edges where needed
MATCH (s1:Small)-[r:CONNECTED_TO]->(s2:Small)
CREATE (s1)<-[:CONNECTED_TO {via: r.via}]-(s2);
#>

<# Query Part 1
MATCH (s:Cave {name:"start"})
MATCH (e:Cave {name:"end"})
match (c:Cave) with count(c) as caves,s,e CALL apoc.path.expandConfig(s, {
    relationshipFilter: "CONNECTED_TO>",
    minLevel: 1,
    maxLevel: caves,
    uniqueness: "NODE_PATH",
    terminatorNodes: [e]
})
YIELD path 
RETURN count(path)
#>

<#--- Part Two ---
After reviewing the available paths, you realize you might have time to visit a single small cave twice. 
Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, 
and the remaining small caves can be visited at most once. 
However, the caves named start and end can only be visited exactly once each: 
once you leave the start cave, you may not return to it, and once you reach the end cave, 
the path must end immediately.
Given these new rules, how many paths through this cave system are there?#>

