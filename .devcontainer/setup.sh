#!/bin/bash

echo "🚀 Setting up AdventOfCode development environment..."

# Update system packages
sudo apt-get update

# Install additional packages needed for this repository
sudo apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    tree

# Set up conda environment from environment.yml
echo "📦 Setting up conda environment..."
if [ -f "environment.yml" ]; then
    conda env create -f environment.yml --force
    conda activate aoc-martinroebke
    echo "conda activate aoc-martinroebke" >> ~/.bashrc
    echo "conda activate aoc-martinroebke" >> ~/.zshrc
else
    echo "⚠️ environment.yml not found, installing basic Python dependencies..."
    pip install neo4j-python-driver numpy python-dotenv setuptools
fi

# Install the project in development mode
echo "🔧 Installing project in development mode..."
pip install -e .

# Create .env file from template if it doesn't exist
if [ -f ".env.template" ] && [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    cp .env.template .env
    echo "✅ Created .env file. Please update it with your actual values."
fi

# Set PowerShell as default shell for the user
echo "🐚 Configuring PowerShell..."
sudo chsh -s /usr/bin/pwsh codespace 2>/dev/null || echo "Note: Could not set PowerShell as default shell"

# Configure PowerShell profile
mkdir -p ~/.config/powershell
cat > ~/.config/powershell/profile.ps1 << 'EOF'
# AdventOfCode PowerShell Profile
Write-Host "🎄 Welcome to AdventOfCode Development Environment!" -ForegroundColor Green
Write-Host "PowerShell 7 is ready for Advent of Code solutions!" -ForegroundColor Cyan

# Set location to repository root
Set-Location $env:GITHUB_WORKSPACE

# Useful aliases for AdventOfCode development
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name python -Value python3

# Function to quickly navigate to year folders
function Set-AocYear {
    param([int]$Year)
    $yearPath = if ($Year -eq 2021) { "_2021" } else { $Year.ToString() }
    if (Test-Path $yearPath) {
        Set-Location $yearPath
        Write-Host "📅 Switched to year $Year" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Year $Year not found" -ForegroundColor Red
    }
}
Set-Alias -Name aoc -Value Set-AocYear

Write-Host "Use 'aoc <year>' to navigate to a specific year folder" -ForegroundColor Gray
EOF

# Create a welcome message
cat > ~/.motd << 'EOF'
🎄 AdventOfCode Development Environment 🎄

Available tools:
• PowerShell 7      - Primary language for solutions
• Python 3.9+      - For utilities and graph problems  
• Conda             - Python package management
• Neo4j drivers     - For graph-based challenges
• VS Code Extensions- PowerShell, Python, Copilot

Quick start:
• Use 'aoc <year>' in PowerShell to navigate to year folders
• Update .env file with your AOC session token
• Run solutions with './Day X Solution.ps1'

Happy coding! 🚀
EOF

echo "✅ Setup complete! Environment is ready for AdventOfCode development."
echo "🎄 Use PowerShell as your primary terminal for the best experience."