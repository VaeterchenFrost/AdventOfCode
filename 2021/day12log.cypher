MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT cave_name_key IF NOT EXISTS
FOR (n:Cave)
REQUIRE n.name IS NODE KEY;

// WITH split('start-A start-b A-c A-b b-d A-end b-end',' ') AS lines
WITH split('we-NX ys-px ys-we px-end yq-NX px-NX yq-px qk-yq pr-NX wq-EY pr-oe wq-pr ys-end start-we ys-start oe-DW EY-oe end-oe pr-yq pr-we wq-start oe-NX yq-EY ys-wq ys-pr',' ') AS lines
UNWIND lines AS line
WITH split(line, '-') AS vertices
MERGE (from:Cave {name: vertices[0]})
MERGE (to:Cave {name: vertices[1]})
MERGE (from)-[:CONNECTED_TO]->(to);

MATCH (c:Cave)
WITH c, CASE c.name = toLower(c.name)
WHEN true THEN ["Small"] ELSE ["Big"] END AS cave_type
CALL apoc.create.addLabels(c, cave_type)
YIELD node
RETURN node;

MATCH (s1:Small)-[:CONNECTED_TO]-(big:Big)-[:CONNECTED_TO]-(s2:Small)
WHERE id(s1) < id(s2)
MERGE (s1)-[:CONNECTED_TO {via: big.name}]->(s2);

MATCH (s:Small)-[:CONNECTED_TO]-(big:Big)
WHERE NOT s.name IN ["start", "end"]
MERGE (s)-[:LOOP {via: big.name}]->(s);

MATCH (b:Big) DETACH DELETE b;

MATCH (s:Small)-[:CONNECTED_TO]-(leaf:Small)
WHERE apoc.node.degree(leaf, "CONNECTED_TO") = 1
MERGE (s)-[:LOOP {via: leaf.name}]->(s)
DETACH DELETE leaf;

match (a)--(a)  merge (a)-[r:PATH]->(a) ON CREATE SET r.mult = 1
ON MATCH SET r.mult = r.mult +1;

match (a)--(b) where id(a)<id(b) merge (a)-[r:PATH]->(b) ON CREATE SET r.mult = 1
ON MATCH SET r.mult = r.mult +1;

// Part 1:
PROFILE
MATCH (s:Cave {name:"start"})
MATCH (e:Cave {name:"end"})
CALL apoc.meta.stats() yield nodeCount
CALL apoc.path.expandConfig(s, {
    relationshipFilter: "PATH",
    maxLevel: nodeCount-1,
    terminatorNodes: [e],
    uniqueness: "NODE_PATH"
})
YIELD path 
RETURN sum(reduce(acc = 1, r IN relationships(path) | acc*r.mult)) AS reduction;

// Part 2:
PROFILE
MATCH (s:Cave {name:"start"})
MATCH (e:Cave {name:"end"})
CALL apoc.meta.stats() yield nodeCount
CALL apoc.path.expandConfig(s, {
    relationshipFilter: "PATH",
    maxLevel: nodeCount,
    terminatorNodes: [e],
    blacklistNodes: [s]
})
YIELD path 
WITH path, apoc.coll.duplicatesWithCount(nodes(path)) as dupl
WHERE size(dupl) = 0 OR (size(dupl) = 1 and dupl[0]["count"]=2)
RETURN sum(reduce(acc = 1, r IN relationships(path) | acc*r.mult)) AS reduction;