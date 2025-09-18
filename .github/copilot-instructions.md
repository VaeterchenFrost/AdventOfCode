# GitHub Copilot Instructions for AdventOfCode Repository

## Repository Overview

This repository contains solutions for [Advent of Code](https://adventofcode.com) challenges, implemented primarily in **PowerShell 7** and **Python**, with some **Wolfram Mathematica** solutions. The codebase is highly modular and organized by year, with shared utilities and automated tooling.

## Repository Structure

```
AdventOfCode/
├── 2015/, 2016/, 2017/, 2018/, 2020/, _2021/  # Year-based solution folders
├── scripts/                                    # Build and utility scripts
├── utilities/                                  # Shared Python utilities
├── .github/workflows/                         # CI/CD automation
├── environment.yml                            # Conda environment
├── setup.py                                   # Python package setup
└── DIRECTORY.md                               # Auto-generated file index
```

## Code Generation Guidelines

### PowerShell Solutions (Primary Language)

**File Naming Convention:**
- Files follow pattern: `Day X [Challenge Name].ps1`
- Use descriptive challenge names from Advent of Code

**PowerShell Patterns to Follow:**

```powershell
# Standard header with challenge description
<#--- Day X: Challenge Name ---
[Original challenge description]
#>

# Year and day variables
$year, $day = 2023, 1

# Load shared input functionality
. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$lines = load_aoc_input $year $day $inputfile

# Solution code here
# Use Write-Warning for output display
$result | Write-Warning
```

**PowerShell Best Practices:**
- Use `$PSScriptRoot` for relative paths
- Leverage `.NET` collections for performance (`System.Collections.Generic.HashSet`, etc.)
- Use `-replace '\\', '/'` for cross-platform path handling
- Prefer `Write-Warning` for visible output over `Write-Host`
- Use meaningful variable names (`$visited`, `$coordinates`, etc.)

### Python Solutions and Utilities

**Python Patterns:**

```python
# -*- coding: utf-8 -*-
"""
Module description following the existing docstring style.

Copyright (C) 2022 Martin Röbke
[Standard GPL license header]
"""

import logging
from typing import Any, Generator, Iterator, Optional
from utilities.version import __version__, __date__

LOGGER = logging.getLogger(__name__)
```

**Python Best Practices:**
- Follow existing type annotation patterns
- Use the established logging configuration
- Include GPL license headers for new files
- Follow the existing utilities module patterns
- Use generator functions where appropriate

### Wolfram Mathematica Integration

**For complex mathematical problems:**
- Use `wolframscript.exe -c` for Wolfram code execution
- Handle licensing warnings appropriately
- Include error checking for Wolfram availability

```powershell
$result = wolframscript.exe -c 'MathematicaCode'
($result -match 'password') ? "License check needed" : $result | Write-Warning
```

## Modular Architecture Guidelines

### Shared Utilities

**PowerShell Utilities:**
- `scripts/LoadAocInput.ps1`: Input loading with session management
- Reuse existing functions: `load_aoc_input`, `load_dotenv`, `unload_dotenv`

**Python Utilities:**
- `utilities/utilities.py`: Common helper functions
- `utilities/version.py`: Version management
- Use existing patterns for argument parsing and logging

### Input Management

- Input files follow pattern: `input{day}` in year folders
- Automatic download using AOC session cookie via `.env` file
- Use `load_aoc_input` function for consistent input handling

### Directory Management

- **NEVER modify `DIRECTORY.md` manually** - it's auto-generated
- The `scripts/build_directory_md.py` script maintains the file index
- CI/CD automatically updates `DIRECTORY.md` on push

## Development Environment

### Setup Commands:
```bash
# Python environment
conda env create -f ./environment.yml
# OR
pip install -e .

# PowerShell 7 required (versions before 7 don't work)
```

### Dependencies:
- **PowerShell 7+** (primary requirement)
- **Python 3.8+** with neo4j-python-driver, numpy, python-dotenv
- **Wolfram Mathematica 13** (optional, for mathematical solutions)
- **Neo4j** (for graph-based challenges)

## Code Suggestions and Completions

### When suggesting PowerShell code:
1. Always include proper error handling
2. Use cross-platform path handling
3. Leverage .NET collections for performance
4. Follow the established input loading pattern
5. Include meaningful comments explaining algorithms

### When suggesting Python code:
1. Include proper type annotations
2. Follow the established logging patterns
3. Use the existing utilities where applicable
4. Include appropriate docstrings
5. Handle both iterator and non-iterator inputs

### For new solution files:
1. Follow the year/day folder structure
2. Include challenge description in comments
3. Use established input loading patterns
4. Output results using `Write-Warning` (PowerShell) or proper logging (Python)
5. Consider performance for large datasets

## Testing and Validation

- Test solutions with provided sample inputs
- Ensure cross-platform compatibility (Windows/Linux)
- Validate that input loading works correctly
- Check that solutions produce expected output format

## Special Considerations

### Graph Problems:
- Consider Python + Neo4j for graph-heavy challenges
- Use `neo4jexample.py` as reference for Neo4j integration
- Leverage the conda environment for graph dependencies

### Performance-Critical Solutions:
- Use .NET collections in PowerShell
- Consider numpy arrays for Python numerical computations
- Evaluate Wolfram Mathematica for mathematical optimizations

### Multi-Language Solutions:
- Primary solution in PowerShell when possible
- Python for graph/data science heavy problems
- Wolfram for complex mathematical computations
- Maintain consistent input/output patterns across languages

## File Exclusions

When creating new files, avoid:
- Modifying auto-generated `DIRECTORY.md`
- Adding build artifacts or temporary files to version control