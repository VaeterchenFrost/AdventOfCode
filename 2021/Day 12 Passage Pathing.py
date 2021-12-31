import logging
import sys
from typing import Any, Dict, List
from dotenv import dotenv_values
from neo4j import GraphDatabase
import numpy as np
import time


def pathing(wam, visited, posi, end, twice=True):
    """
    wam: arraylike the W-Adj-M of the grid
    visited: [int] forbidden nodes
    posi: int current position
    end: int terminating node
    twice: bool if possible to visit twice
    """
    # print("p ", visited, posi)
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


def day12of2021(nodes: List[str], matrix: List[List[int]]):
    wam = np.array(matrix)
    wam[nodes.index("start")] = 0
    wam[::, nodes.index("end")] = 0

    start_time = time.perf_counter()
    result = pathing(np.copy(wam), [], nodes.index("start"), nodes.index("end"), False)
    end_time = time.perf_counter()
    print("Part 1 ", round((end_time - start_time) * 1000, 3), "milliseconds")
    print(result)
    start_time = time.perf_counter()
    result = pathing(np.copy(wam), [], nodes.index("start"), nodes.index("end"))
    end_time = time.perf_counter()
    print("Part 2 ", round((end_time - start_time) * 1000, 3), "milliseconds")
    print(result)


class AoC2021Day12:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        self.logger = logging.getLogger(self.__class__.__name__)

    def __del__(self):
        self.driver.close()
        self.logger.info(
            f"{self.__class__.__name__} closed driver {self.driver.__class__.__name__}"
        )

    def enable_log(self, level, output_stream):
        handler = logging.StreamHandler(output_stream)
        handler.setLevel(level)
        self.logger.addHandler(handler)
        self.logger.setLevel(level)

    @staticmethod
    def _clear_database(tx):
        query = "MATCH (n) DETACH DELETE n"
        tx.run(query)
        return True

    @staticmethod
    def _read_adjacency_matrix(tx):
        query = """
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
            {
                "nodes": row["Nodes"],
                "matrix": row["AdjacencyMatrix"],
            }
            for row in result
        ]

    def get_adjacency_matrix(self) -> Dict[str, Any]:
        with self.driver.session() as session:
            (result,) = session.read_transaction(self._read_adjacency_matrix)
            return result

    def clear_database(self):
        with self.driver.session() as session:
            # Write transactions allow the driver to handle retries and transient errors
            session.write_transaction(self._clear_database)


if __name__ == "__main__":
    config = dotenv_values(".env")
    app = AoC2021Day12(
        config["NEO4J_SERVERURL"], config["NEO4J_USER"], config["NEO4J_PASSWORD"]
    )
    app.enable_log(logging.INFO, sys.stdout)
    # app.clear_database()
    day12of2021(**app.get_adjacency_matrix())
    del app
