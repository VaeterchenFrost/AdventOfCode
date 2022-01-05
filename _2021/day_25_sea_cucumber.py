import logging
from pathlib import Path
import sys
from typing import Any, Dict, List
from dotenv import dotenv_values
from neo4j import GraphDatabase
from _2021.day_12_passage_pathing import AoC2021Day12

from utilities.utilities import get_parser, logging_cfg

LOGGER = logging.getLogger("day252021.py")


def main(args: List[str]) -> None:
    """
    Main method solving AdventOfCode 2021 day 25 for arguments in 'args'.

    Parameters
    ----------
    args : List[str]
        The array containing all (command-line) flags.

    Returns
    -------
    None
    """
    parser = get_parser(
        "Solving AdventOfCode 2021 Day 25: Passage Pathing https://adventofcode.com/2021/day/25"
    )
    # get cmd-arguments
    options = parser.parse_args(args)

    logging_cfg(filename="logging.ini", loglevel=options.loglevel)
    LOGGER.info("Called with '%s'", options)

    config = dotenv_values(Path(__file__).parent.parent / ".env", verbose=True)
    app = AoC2021Day12(
        config["NEO4J_SERVERURL"], config["NEO4J_USER"], config["NEO4J_PASSWORD"]
    )
    # app.clear_database()
    inputfile = Path(__file__).parent / "input12"
    with open(inputfile, "r") as file:
        app.create_prepare_graph(edges=[s.strip() for s in file.readlines()])
    day12of2021(**app.get_adjacency_matrix())
    del app


class AoC2021Day25(AoC2021Day12):
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
    def _clear_database(tx, labelfilter: List[str] = None):
        labels = [""]
        if labelfilter:
            labels += labelfilter
        query = f"MATCH (n{':'.join(labels)}) DETACH DELETE n"
        tx.run(query)
        return True

    @staticmethod
    def _add_constraint(tx):
        query = r"""CREATE CONSTRAINT cave_name_key IF NOT EXISTS 
        FOR (n:Cave) 
        REQUIRE n.name IS NODE KEY;"""
        tx.run(query)
        return True

    @staticmethod
    def _add_cavelabels(tx):
        query = r"""MATCH (c:Cave)
        WITH c, CASE c.name = toLower(c.name)
        WHEN true THEN ["Small"] ELSE ["Big"] END AS cave_type
        CALL apoc.create.addLabels(c, cave_type)
        YIELD node
        RETURN node;"""
        tx.run(query)
        return True

    @staticmethod
    def _add_connected_over_big(tx):
        query = r"""MATCH (s1:Small)-[:CONNECTED_TO]-(big:Big)-[:CONNECTED_TO]-(s2:Small)
        WHERE id(s1) < id(s2)
        MERGE (s1)-[:CONNECTED_TO {via: big.name}]->(s2);"""
        tx.run(query)
        return True

    @staticmethod
    def _add_loop_over_big(tx):
        query = r"""MATCH (s:Small)-[:CONNECTED_TO]-(big:Big)
        WHERE NOT s.name IN ["start", "end"]
        MERGE (s)-[:LOOP {via: big.name}]->(s);"""
        tx.run(query)
        return True

    @staticmethod
    def _add_loop_over_leaf(tx):
        query = r"""MATCH (s:Small)-[:CONNECTED_TO]-(leaf:Small)
        WHERE apoc.node.degree(leaf, "CONNECTED_TO") = 1
        MERGE (s)-[:LOOP {via: leaf.name}]->(s)
        DETACH DELETE leaf;"""
        tx.run(query)
        return True

    @staticmethod
    def _create_graph(tx, edges: List[str]):
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
    def _read_adjacency_matrix(tx):
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

    def clear_database(self):
        with self.driver.session() as session:
            # Write transactions allow the driver to handle retries and transient errors
            session.write_transaction(self._clear_database)

    def create_prepare_graph(self, edges: List[str]):
        with self.driver.session() as session:
            LOGGER.info(
                f"Clearing database: {session.write_transaction(self._clear_database)}"
            )
            LOGGER.info(
                f"Adding edges: {session.write_transaction(self._create_graph, edges)}"
            )
            LOGGER.info(
                f"Adding labels: {session.write_transaction(self._add_cavelabels)}"
            )
            LOGGER.info(
                f"Adding edges connected over big: {session.write_transaction(self._add_connected_over_big)}"
            )
            LOGGER.info(
                f"Adding loop over big: {session.write_transaction(self._add_loop_over_big)}"
            )
            LOGGER.info(
                f"Removing big caves: {session.write_transaction(self._clear_database, ['Big'])}"
            )
            LOGGER.info(
                f"Replacing leafs with loops: {session.write_transaction(self._add_loop_over_leaf)}"
            )


def init():
    """Initialization that is executed at the time of the module import."""
    if __name__ == "__main__":
        sys.exit(main(sys.argv[1:]))  # call main function


init()
