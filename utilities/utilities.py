# -*- coding: utf-8 -*-
"""
Helper methods for this project.


Copyright (C) 2022  Martin Röbke

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.
    If not, see https://www.gnu.org/licenses/gpl-3.0.html

"""

import argparse
import logging
import logging.config
from collections.abc import Iterable as iter_type
from itertools import chain
from pathlib import Path
from typing import Any, Generator, Iterable, Iterator, TypeVar, Union

from utilities.version import __date__, __version__


LOGGER = logging.getLogger("utilities.py")

CFG_EXT = (".ini", ".cfg", ".conf", ".config")
LOGLEVEL_EPILOG = """
Logging levels for python 3.8:
    CRITICAL: 50
    ERROR:    40
    WARNING:  30
    INFO:     20
    DEBUG:    10
    NOTSET:    0 (will traverse the logging hierarchy until a value is found)
    """
DEFAULT_LOGGING_CFG = {
    "version": 1,
    "formatters": {
        "simple": {
            "format": "%(asctime)s %(levelname)s %(message)s",
            "datefmt": "%H:%M:%S",
        }
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": "WARNING",
            "formatter": "simple",
            "stream": "ext://sys.stdout",
        }
    },
    'loggers': {
        'day122021.py': {
            'level': 'NOTSET',
        },
        'utilities.py': {
            'level': 'NOTSET',
        }
    },
    "root": {"level": "WARNING", "handlers": ["console"]},
}

_T = TypeVar("_T")


def get_parser(extra_desc: str = "") -> argparse.ArgumentParser:
    """
    Prepare an argument parser for AdventOfCode scripts.

    Parameters
    ----------
    extra_desc : str, optional
        Description about the script using the parser. The default is ''.

    Returns
    -------
    parser : argparse.ArgumentParser
        The prepared argument parser object.

    """
    parser = argparse.ArgumentParser(
        description="""
        Copyright (C) 2022 Martin Röbke
        This program comes with ABSOLUTELY NO WARRANTY
        This is free software, and you are welcome to redistribute it
        under certain conditions; see COPYING for more information.
        """
        + "\n"
        + extra_desc,
        epilog=LOGLEVEL_EPILOG,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s " + __version__ + ", " + __date__,
    )
    parser.add_argument("--loglevel", help="set the minimal loglevel for root")
    return parser


def logging_cfg(filename: str, loglevel: Union[None, int, str] = None) -> None:
    """Configure logging for this module"""
    logging.basicConfig()
    read_err = "could not read configuration from '%s'"
    config_err = "could not use logging configuration from '%s'"
    # should be in same directory
    file = Path(__file__).parent / filename

    if loglevel is not None:
        try:
            loglevel = int(float(loglevel))
        except ValueError:
            loglevel = loglevel.upper()

    if file.suffix.lower() in CFG_EXT:  # .config
        try:
            logging.config.fileConfig(file, defaults=DEFAULT_LOGGING_CFG, disable_existing_loggers=False)
            if loglevel is not None:
                root = logging.getLogger()
                root.setLevel(loglevel)
                for handler in root.handlers:
                    handler.setLevel(loglevel)
            return
        except OSError:
            LOGGER.error(read_err, file.resolve(), exc_info=True)
        except ValueError:
            LOGGER.error(config_err, file.resolve(), exc_info=True)


def flatten(iterable: Iterable[Iterable[_T]]) -> Iterator[_T]:
    """Flatten at first level.

    Turn ex=[[1,2],[3,4]] into
    [1, 2, 3, 4]
    and [ex,ex] into
    [[1, 2], [3, 4], [1, 2], [3, 4]]
    """
    return chain.from_iterable(iterable)


def gen_arg(arg_or_iter: Any) -> Generator:
    """
    Infinite generator for the next argument of `arg_or_iter`.
    If the argument is exhausted, always return the last element.

    Parameters
    ----------
    arg_or_iter : object
        Object to iterate over. Considers three cases:
            string: yields the string as one element indefinitely
            iterable: yields all elements from it, and only the last one after.
            not iterable: yield the object indefinitely
    """
    if isinstance(arg_or_iter, str):
        while True:
            yield arg_or_iter
    elif not isinstance(arg_or_iter, iter_type):
        while True:
            yield arg_or_iter
    else:
        item = None
        for item in arg_or_iter:
            yield item
    while True:
        yield item
