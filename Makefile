# Makefile for Kasm Helm Chart Development
# Provides convenient commands for linting, testing, and validation

.PHONY: help lint test docs validate install-deps clean

# Default target
help: ## Show this help message
	@echo "Kasm Helm Chart Development Commands"
	@echo "======================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Install development dependencies
install-deps: ## Install development dependencies (pre-commit, yamale, etc.)
	@echo "📦 Installing development dependencies..."
	pip install pre-commit yamale chart-testing
	@echo "✅ Dependencies installed"

# Pre-commit setup
setup-precommit: install-deps ## Set up pre-commit hooks
	@echo "🔧 Setting up pre-commit hooks..."
	pre-commit install
	@echo "✅ Pre-commit hooks installed"

# Linting targets
lint: lint-yaml lint-helm ## Run all linting checks

lint-yaml: ## Lint YAML files
	@echo "🔍 Linting YAML files..."
	yamllint -c .github/lintconf.yaml charts/kasm/values*.yaml charts/kasm/Chart.yaml charts/kasm/ci/*.yaml

lint-helm: ## Lint Helm charts
	@echo "🔍 Linting Helm charts..."
	helm lint charts/kasm

# Testing targets
test: test-template test-values ## Run all tests

test-template: ## Test Helm template generation
	@echo "🧪 Testing template generation..."
	helm template test-release charts/kasm > /dev/null
	@if [ -f charts/kasm/ci/ci-values.yaml ]; then \
		helm template test-release charts/kasm -f charts/kasm/ci/ci-values.yaml > /dev/null; \
	fi
	@if [ -f charts/kasm/values-minimal.yaml ]; then \
		helm template test-release charts/kasm -f charts/kasm/values-minimal.yaml > /dev/null; \
	fi
	@echo "✅ Template generation successful"

test-values: ## Validate values files
	@echo "🧪 Validating values files..."
	@for values_file in charts/kasm/values*.yaml; do \
		echo "  Checking $$values_file..."; \
		helm template test-release charts/kasm -f $$values_file > /dev/null; \
	done
	@echo "✅ All values files are valid"

# Chart testing (requires ct)
test-ct: ## Run chart-testing (ct) validation
	@echo "🧪 Running chart-testing..."
	@if ! command -v ct >/dev/null 2>&1; then \
		echo "❌ chart-testing (ct) not found. Install it first:"; \
		echo "   brew install chart-testing"; \
		echo "   or download from: https://github.com/helm/chart-testing/releases"; \
		exit 1; \
	fi
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo update
	ct lint --all --validate-maintainers=false

# Documentation
docs: ## Generate Helm documentation
	@echo "📚 Generating documentation..."
	@if command -v helm-docs >/dev/null 2>&1; then \
		helm-docs --chart-search-root=charts; \
	else \
		echo "📝 Using Docker to generate docs..."; \
		docker run --rm -v "$$(pwd):/helm-docs" -u $$(id -u) jnorwood/helm-docs:latest --chart-search-root=charts; \
	fi
	@echo "✅ Documentation generated"

# Validation
validate: lint test ## Run comprehensive validation (lint + test)
	@echo "✅ All validation checks passed!"

# Development workflow
dev-check: lint test-template ## Quick development checks (fast)
	@echo "✅ Development checks completed!"

# CI simulation
ci-check: validate test-ct docs ## Simulate CI pipeline checks
	@echo "✅ CI simulation completed!"

# Cleanup
clean: ## Clean up generated files and caches
	@echo "🧹 Cleaning up..."
	rm -rf .pre-commit
	rm -rf charts/kasm/charts/
	rm -rf charts/kasm/*.tgz
	@echo "✅ Cleanup completed"

# Pre-commit shortcuts
pre-commit-all: ## Run all pre-commit hooks on all files
	pre-commit run --all-files

pre-commit-helm: ## Run only Helm-related pre-commit hooks
	pre-commit run helm-lint helm-template-test

pre-commit-docs: ## Run documentation generation
	pre-commit run helm-docs

# Package chart
package: lint test-template ## Package the Helm chart
	@echo "📦 Packaging chart..."
	helm package charts/kasm
	@echo "✅ Chart packaged successfully"
