# AdventOfCode Codespaces

This repository includes a GitHub Codespaces configuration for a complete development environment.

## Quick Start

1. Click the "Code" button on GitHub
2. Select "Create codespace on main"
3. Wait for the environment to set up (2-3 minutes)
4. Open a PowerShell terminal and start coding!

## What's Included

### Languages & Runtimes
- **PowerShell 7** - Primary language for AdventOfCode solutions
- **Python 3.9+** - For utilities and Neo4j integration
- **Conda** - Python environment management

### VS Code Extensions
- PowerShell extension with syntax highlighting and debugging
- Python extension with Pylance for enhanced development
- GitHub Copilot for AI-assisted coding
- Neo4j Cypher extension for graph queries
- Jupyter notebooks support
- Markdown and YAML editing support

### Development Tools
- Git configuration
- Neo4j Python driver for graph problems
- All dependencies from `environment.yml`
- Auto-setup of project in development mode

## Environment Setup

The codespace automatically:
1. Installs all dependencies from `environment.yml`
2. Sets up the project in development mode (`pip install -e .`)
3. Creates a `.env` file from the template
4. Configures PowerShell as the primary terminal
5. Sets up helpful aliases and functions

## Usage Tips

### PowerShell Terminal
- Use `aoc <year>` to quickly navigate to year folders (e.g., `aoc 2021`)
- PowerShell 7 is set as the default terminal
- All .ps1 files have proper syntax highlighting

### Python Development
- Conda environment `aoc-martinroebke` is automatically activated
- Neo4j drivers are pre-installed for graph challenges
- Project is installed in development mode

### Environment Variables
- Update `.env` file with your AOC session token for automatic input download
- Neo4j credentials can be configured for graph-based solutions

## Port Forwarding

The following ports are automatically forwarded:
- **7474**: Neo4j HTTP interface
- **7687**: Neo4j Bolt protocol

## File Structure

```
.devcontainer/
├── devcontainer.json    # Main configuration
├── setup.sh            # Post-creation setup script
└── README.md           # This file
```

## Troubleshooting

- If conda environment activation fails, run: `conda activate aoc-martinroebke`
- For PowerShell issues, ensure you're using the PowerShell terminal
- Neo4j connection requires proper credentials in `.env` file

Happy coding! 🎄