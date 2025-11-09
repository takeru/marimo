#!/bin/bash
set -euo pipefail

# Only run in Claude Code web environment
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Enable async mode with 5-minute timeout
echo '{"async": true, "asyncTimeout": 300000}'

echo "🚀 Setting up marimo development environment..."

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
  echo "📦 Creating virtual environment..."
  uv venv
  echo "✅ Virtual environment created"
else
  echo "✅ Virtual environment already exists"
fi

# Build frontend assets
echo "🔧 Building frontend assets..."
if make fe; then
  echo "✅ Frontend build complete"
else
  echo "❌ Frontend build failed"
  exit 1
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
if make py; then
  echo "✅ Python dependencies installed"
else
  echo "❌ Python dependencies installation failed"
  exit 1
fi

echo "✨ Development environment setup complete!"
echo "📝 You can now run 'make dev' to start the development servers"
