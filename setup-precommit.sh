#!/bin/bash
# setup-precommit.sh - Setup script for pre-commit hooks

set -e

echo "🚀 Setting up pre-commit hooks for Helm chart development..."

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is required but not installed. Please install Python 3.7+ first."
    exit 1
fi

# Determine Python command
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

# Check if pip is available
if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    echo "❌ pip is required but not installed. Please install pip first."
    exit 1
fi

# Determine pip command
PIP_CMD="pip3"
if ! command -v pip3 &> /dev/null; then
    PIP_CMD="pip"
fi

echo "📦 Installing pre-commit..."
$PIP_CMD install pre-commit

echo "📦 Installing chart-testing dependencies..."
$PIP_CMD install yamale chart-testing

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "⚠️  Helm is not installed. Please install Helm 3.x first:"
    echo "   https://helm.sh/docs/intro/install/"
    echo ""
fi

# Check if helm-docs is installed
if ! command -v helm-docs &> /dev/null; then
    echo "⚠️  helm-docs is not installed. Options:"
    echo "   1. Install via Go: go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest"
    echo "   2. Install via Homebrew: brew install norwoodj/tap/helm-docs"
    echo "   3. Use Docker (automatic fallback in pre-commit hooks)"
    echo ""
fi

# Check if chart-testing is installed
if ! command -v ct &> /dev/null; then
    echo "⚠️  chart-testing (ct) is not installed. Options:"
    echo "   1. Install via Homebrew: brew install chart-testing"
    echo "   2. Download from: https://github.com/helm/chart-testing/releases"
    echo "   3. Use pip: pip install chart-testing"
    echo ""
fi

echo "🔧 Installing pre-commit hooks..."
pre-commit install

echo ""
echo "✅ Pre-commit setup complete!"
echo ""
echo "🎯 Available commands:"
echo "   pre-commit run --all-files    # Run all hooks on all files"
echo "   pre-commit run helm-lint      # Run only Helm linting"
echo "   pre-commit run helm-docs      # Generate documentation"
echo "   pre-commit run yamllint       # Run YAML linting"
echo ""
echo "💡 The hooks will now run automatically on git commit."
echo "   To skip hooks temporarily: git commit --no-verify"
echo ""
echo "🧪 Test the setup:"
echo "   pre-commit run --all-files"
