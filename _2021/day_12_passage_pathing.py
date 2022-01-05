import logging
import sys
import time
from pathlib import Path
from typing import Any, Dict, List

import numpy as np
from dotenv import dotenv_values
from neo4j import GraphDatabase
from utilities.utilities import get_parser, logging_cfg

LOGGER = logging.getLogger("day122021.py")


def main(args: List[str]) -> None:
    """
    Main method solving AdventOfCode 2021 day 12 for arguments in 'args'.

    Parameters
    ----------
    args : List[str]
        The array containing all (command-line) flags.

    Returns
    -------
    None
    """
    parser = get_parser(
        "Solving AdventOfCode 2021 Day 12: Passage Pathing https://adventofcode.com/2021/day/12"
    )
    parser.add_argument(
        "--infile",
        help="file containing the input for the puzzle.",
        default=Path(__file__).parent / "input12",
    )
    options = parser.parse_args(args)

    logging_cfg(filename="logging.ini", loglevel=options.loglevel)
    LOGGER.info("Called with '%s'", options)

    config = dotenv_values(Path(__file__).parent.parent / ".env", verbose=True)
    app = AoC2021Day12(
        config["NEO4J_SERVERURL"], config["NEO4J_USER"], config["NEO4J_PASSWORD"]
    )
    with open(options.infile, "r") as file:
        app.create_prepare_graph(edges=[s.strip() for s in file.readlines()])
    day12of2021(**app.get_adjacency_matrix())
    del app


def pathing(wam, visited, posi, end, twice=True):
    """
    wam: arraylike the W-Adj-M of the grid
    visited: [int] forbidden nodes
    posi: int current position
    end: int terminating node
    twice: bool if possible to visit twice
    """
    ways = np.copy(wam[::, posi])
    ends = ways[end]
    ways[end] = 0
    if not twice:
        ways[visited] = 0
    return ends + sum(
        [
            ways[x] * pathing(wam, visited + [x], x, end, twice and (x not in visited))
            for x in np.where(ways > 0)[0]
        ]
    )


def day12of2021(nodes: List[str], matrix: List[List[int]]) -> List[int]:
    wam = np.array(matrix)
    wam[nodes.index("start")] = 0
    wam[::, nodes.index("end")] = 0
    results = []
    for part2 in [False, True]:
        start_time = time.perf_counter()
        result = pathing(
            np.copy(wam), [], nodes.index("start"), nodes.index("end"), part2
        )
        end_time = time.perf_counter()
        LOGGER.info(
            "Part %d %s milliseconds",
            2 if part2 else 1,
            round((end_time - start_time) * 1000, 3),
        )
        print(result)
        results += result
    return results


class AoC2021Day12:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        LOGGER.info(
            f"{self.__class__.__name__} started driver {self.driver.__class__.__name__} "
        )

    def __del__(self):
        LOGGER.info("Closing")
        self.driver.close()
        LOGGER.info(
            f"{self.__class__.__name__} closed driver {self.driver.__class__.__name__}"
        )

    @staticmethod
    def _clear_database(tx, labelfilter: List[str] = None) -> bool:
        labels = [""]
        if labelfilter:
            labels += labelfilter
        query = f"MATCH (n{':'.join(labels)}) DETACH DELETE n"
        tx.run(query)
        return True

    @staticmethod
    def _add_constraint(tx) -> bool:
        query = r"""CREATE CONSTRAINT cave_name_key IF NOT EXISTS 
        FOR (n:Cave) 
        REQUIRE n.name IS NODE KEY;"""
        tx.run(query)
        return True

    @staticmethod
    def _add_cavelabels(tx) -> bool:
        query = r"""MATCH (c:Cave)
        WITH c, CASE c.name = toLower(c.name)
        WHEN true THEN ["Small"] ELSE ["Big"] END AS cave_type
        CALL apoc.create.addLabels(c, cave_type)
        YIELD node
        RETURN node;"""
        tx.run(query)
        return True

    @staticmethod
    def _add_connected_over_big(tx) -> bool:
        query = r"""MATCH (s1:Small)-[:CONNECTED_TO]-(big:Big)-[:CONNECTED_TO]-(s2:Small)
        WHERE id(s1) < id(s2)
        MERGE (s1)-[:CONNECTED_TO {via: big.name}]->(s2);"""
        tx.run(query)
        return True

    @staticmethod
    def _add_loop_over_big(tx) -> bool:
        query = r"""MATCH (s:Small)-[:CONNECTED_TO]-(big:Big)
        WHERE NOT s.name IN ["start", "end"]
        MERGE (s)-[:LOOP {via: big.name}]->(s);"""
        tx.run(query)
        return True

    @staticmethod
    def _add_loop_over_leaf(tx) -> bool:
        query = r"""MATCH (s:Small)-[:CONNECTED_TO]-(leaf:Small)
        WHERE apoc.node.degree(leaf, "CONNECTED_TO") = 1
        MERGE (s)-[:LOOP {via: leaf.name}]->(s)
        DETACH DELETE leaf;"""
        tx.run(query)
        return True

    @staticmethod
    def _create_graph(tx, edges: List[str]) -> bool:
        delim = " "
        query = (
            f"WITH split('{delim.join(edges)}','{delim}') AS lines"
            r"""
        UNWIND lines AS line
        WITH split(line, '-') AS vertices
        MERGE (from:Cave {name: vertices[0]})
        MERGE (to:Cave {name: vertices[1]})
        MERGE (from)-[:CONNECTED_TO]->(to);"""
        )
        tx.run(query)
        return True

    @staticmethod
    def _read_adjacency_matrix(tx) -> Dict:
        query = r"""
            MATCH (n)
            WITH collect(n) AS Nodes
            WITH 
            [n IN Nodes |
            [m IN Nodes |
                size((n)-[:LOOP|CONNECTED_TO]-(m))
            ]
            ] AS AdjacencyMatrix, [n in Nodes|n.name] as Nodes
            RETURN Nodes,AdjacencyMatrix;
        """
        result = tx.run(query)

        return [
            {"nodes": row["Nodes"], "matrix": row["AdjacencyMatrix"],} for row in result
        ]

    def get_adjacency_matrix(self) -> Dict[str, Any]:
        with self.driver.session() as session:
            (result,) = session.read_transaction(self._read_adjacency_matrix)
            return result

    def clear_database(self) -> None:
        with self.driver.session() as session:
            # Write transactions allow the driver to handle retries and transient errors
            session.write_transaction(self._clear_database)

    def create_prepare_graph(self, edges: List[str]) -> None:
        with self.driver.session() as session:
            queryresult = session.write_transaction(self._clear_database)
            LOGGER.info("Clearing database: %s", queryresult)

            queryresult = session.write_transaction(self._add_constraint)
            LOGGER.info("Adding constraint: %s", queryresult)

            queryresult = session.write_transaction(self._create_graph, edges)
            LOGGER.info("Adding edges: %s", queryresult)

            queryresult = session.write_transaction(self._add_cavelabels)
            LOGGER.info("Adding labels: %s", queryresult)

            queryresult = session.write_transaction(self._add_connected_over_big)
            LOGGER.info("Adding edges connected over big: %s", queryresult)

            queryresult = session.write_transaction(self._add_loop_over_big)
            LOGGER.info("Adding loop over big: %s", queryresult)

            queryresult = session.write_transaction(self._clear_database, ["Big"])
            LOGGER.info("Removing big caves: %s", queryresult)

            queryresult = session.write_transaction(self._add_loop_over_leaf)
            LOGGER.info("Replacing leafs with loops: %s", queryresult)


def init():
    """Initialization that is executed at the time of the module import."""
    if __name__ == "__main__":
        sys.exit(main(sys.argv[1:]))


init()
