import logging
import sys
from pathlib import Path
from typing import Dict, List

from dotenv import dotenv_values
from utilities.utilities import get_parser, logging_cfg

from _2021.day_12_passage_pathing import AoC2021Day12

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
    parser.add_argument(
        "--infile",
        help="file containing the input for the puzzle.",
        default=Path(__file__).parent / "input25",
    )
    options = parser.parse_args(args)

    logging_cfg(filename="logging.ini", loglevel=options.loglevel)
    LOGGER.info("Called with '%s'", options)

    config = dotenv_values(Path(__file__).parent.parent / ".env", verbose=True)
    app = AoC2021Day25(
        config["NEO4J_SERVERURL"], config["NEO4J_USER"], config["NEO4J_PASSWORD"]
    )

    with open(options.infile, "r") as file:
        print(app.create_and_iterate_graph(lines=[s.strip() for s in file.readlines()]))
    del app


class AoC2021Day25(AoC2021Day12):
    @staticmethod
    def _add_constraint(tx) -> bool:
        query = r"""CREATE CONSTRAINT grid_pos_key IF NOT EXISTS
        FOR (n:Posi)
        REQUIRE n.pos IS NODE KEY;"""
        tx.run(query)
        return True

    @staticmethod
    def _create_graph(tx, lines: List[str]) -> Dict:
        delim = " "
        query = (
            f"WITH split('{delim.join(lines)}','{delim}') AS lines"
            r"""
            WITH lines, range(0, size(lines)-1) AS linerange, range(0, size(lines[0])-1) AS columnrange
            UNWIND linerange AS line
            UNWIND columnrange AS column
            MERGE (s:Posi {
                pos:(column + ((line+1) % size(lines))*size(lines[0]))})
            MERGE (p:Posi {
                pos:(column + line*size(lines[0]))})
            MERGE (e:Posi {
                pos:((column+1) % size(lines[0]) + line*size(lines[0]))})
            MERGE (s)<-[:MOVESOUTH]-(p)-[:MOVEEAST]->(e)
            WITH split(lines[line], '') AS cucumbers, line, lines
            UNWIND range(0, size(cucumbers)-1) AS c
            MATCH (p:Posi{
                pos:c + line*size(lines[0])})
            SET p.floor = cucumbers[c]
            RETURN max(size(lines)) as rows, max(size(lines[0])) as columns"""
        )
        result = tx.run(query)
        return [{"rows": row["rows"], "columns": row["columns"],} for row in result]

    @staticmethod
    def _fixpoint_steps(tx) -> int:
        query = r"""
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
        RETURN executions AS steps"""
        result = tx.run(query)
        return [row["steps"] + 1 for row in result]

    def create_and_iterate_graph(self, lines: List[str]) -> int:
        with self.driver.session() as session:
            queryresult = session.write_transaction(self._clear_database)
            LOGGER.info("Clearing database: %s", queryresult)

            queryresult = session.write_transaction(self._add_constraint)
            LOGGER.info("Adding constraint: %s", queryresult)

            (queryresult,) = session.write_transaction(self._create_graph, lines)
            LOGGER.info(
                "Adding nodes and relationships to grid: %d rows, %d columns",
                queryresult["rows"],
                queryresult["columns"],
            )

            (queryresult,) = session.write_transaction(self._fixpoint_steps)
            LOGGER.info("Resulting fixed point and answer after %d steps", queryresult)
            return queryresult


def init():
    """Initialization that is executed at the time of the module import."""
    if __name__ == "__main__":
        sys.exit(main(sys.argv[1:]))


init()
