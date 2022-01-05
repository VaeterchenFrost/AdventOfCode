import logging
import sys
from pathlib import Path
from typing import List

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
        app.create_prepare_graph(lines=[s.strip() for s in file.readlines()])
    del app


class AoC2021Day25(AoC2021Day12):
    @staticmethod
    def _add_constraint(tx):
        query = r"""CREATE CONSTRAINT grid_pos_key IF NOT EXISTS
        FOR (n:Posi)
        REQUIRE n.pos IS NODE KEY;"""
        tx.run(query)
        return True

    def create_prepare_graph(self, lines: List[str]):
        with self.driver.session() as session:
            queryresult = session.write_transaction(self._clear_database)
            LOGGER.info("Clearing database: %s", queryresult)

            queryresult = session.write_transaction(self._add_constraint)
            LOGGER.info("Adding constraint: %s", queryresult)


def init():
    """Initialization that is executed at the time of the module import."""
    if __name__ == "__main__":
        sys.exit(main(sys.argv[1:]))


init()
