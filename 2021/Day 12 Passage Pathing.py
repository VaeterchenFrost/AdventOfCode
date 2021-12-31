import logging
import sys
from dotenv import dotenv_values
from neo4j import GraphDatabase


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

    def clear_database(self):
        with self.driver.session() as session:
            # Write transactions allow the driver to handle retries and transient errors
            session.write_transaction(self._clear_database)


if __name__ == "__main__":
    config = dotenv_values(".env")
    app = AoC2021Day12(config["NEO4J_SERVERURL"], config["NEO4J_USER"], config["NEO4J_PASSWORD"])
    app.enable_log(logging.INFO, sys.stdout)
    app.clear_database()
