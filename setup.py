# -*- coding: utf-8 -*-
"""Describing local installs or distribution of the package aoc-martinroebke."""

from setuptools import setup

from utilities.version import __version__ as version


def read_files(files, delim: str = "\n") -> str:
    r"""
    Concatenate the content of one or more files joined by a delimiter.

    Parameters
    ----------
    files : Iterable of single files
        Every file is a text or byte string giving the name
        (and the path if the file isn't in the current working directory)
         of the file to be opened or an integer file descriptor
         of the file to be wrapped.
    delim : str, optional
        The delimiter to be inserted between the contents. The default is "\n".

    Returns
    -------
    str
        The concatenated string.
    """
    data = []
    try:
        for file in files:
            with open(file, encoding='utf-8') as handle:
                data.append(handle.read())
    except IOError:
        pass
    return delim.join(data)


description = "Solving adventofcode.com problems with the help of python.org"

long_description = read_files(['README.md'])

classifiers = [
    'Development Status :: 4 - Beta',
    'Environment :: Console',
    'Intended Audience :: Science/Research',
    'Intended Audience :: Education',
    'Intended Audience :: Developers',
    'Operating System :: OS Independent',
    'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.8',
    'Topic :: Scientific/Engineering :: Visualization',
    'Topic :: Multimedia :: Graphics :: Presentation']

tests_require = ['hypothesis', 'pytest', 'pytest-mock']

setup(name="aocmartinroebke",
      version=version,
      description=description,
      long_description=long_description,
      long_description_content_type='text/markdown',
      url="https://github.com/VaeterchenFrost/AdventOfCode",
      author="Martin Röbke",
      author_email="martin.roebke@web.de",
      license='GPLv3',
      packages=['utilities', "2021"],
      platforms='any',
      classifiers=classifiers,
      keywords='graph visualization neo4j cypher powershell')
