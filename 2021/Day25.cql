CREATE CONSTRAINT grid_pos_key IF NOT EXISTS
 FOR (n:Posi)
 REQUIRE n.pos IS NODE KEY;
MATCH (n)
DETACH DELETE n;
WITH split('..>>v>vv.. ..v.>>vv.. ..>>v>>vv. ..>>>>>vv. v......>vv v>v....>>v vvv....>.> >vv......> .>v.vv.v..',' ') AS lines
//
WITH split('v...>>.vv> .vv>>.vv.. >>.>v>...v >>v>>.>.v. v>v.vv.v.. >.>>..v... .vv..>.>v. v.v..>>v.v ....v..v.>',' ') AS lines
WITH lines, range(0,size(lines)-1) AS linerange, range(0,size(lines[0])-1) AS columnrange
UNWIND linerange AS line
UNWIND columnrange AS column
MERGE (s:Posi {
	pos:(column+((line+1)%size(lines))*size(lines[0]))})
MERGE (p:Posi {
	pos:(column+line*size(lines[0]))})
MERGE (e:Posi {
	pos:((column+1)%size(lines[0])+line*size(lines[0]))})
MERGE (s)<-[:MOVESOUTH]-(p)-[:MOVEEAST]->(e)
WITH split(lines[line],'') AS cucumbers,line,lines
UNWIND range(0,size(cucumbers)-1) AS c
MATCH (p:Posi{
	pos:c+line*size(lines[0])})
SET p.floor = cucumbers[c]
RETURN max(size(lines)), max(size(lines[0]))



CALL apoc.periodic.commit(
 '
MATCH (p{
	floor:">"})-[:MOVEEAST]->(e{
	floor:"."}) SET p.floor=".", e.floor=">"
RETURN COUNT(p) AS c
LIMIT 1
UNION
MATCH (p{
	floor:"v"})-[:MOVESOUTH]->(s{
	floor:"."}) SET p.floor=".", s.floor="v"
RETURN count(p) AS c
LIMIT 1') yield executions
RETURN executions AS steps