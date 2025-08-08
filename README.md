# Kasm Helm Chart

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Chart Testing](https://github.com/cfi2017/kasm-helm/workflows/Chart%20Testing/badge.svg)

Production-ready Helm chart for deploying [Kasm Workspaces](https://kasmweb.com/) on Kubernetes. This chart follows Helm best practices and is designed for GitOps workflows with comprehensive testing and validation.

## Features

- 🏗️ **Production Architecture**: Complete Kasm deployment with API, Manager, Proxy, Guacamole, Redis, and PostgreSQL
- 🗂️ **Sensible Organization**: Component-based folder structure with one document per file
- 🗄️ **Flexible Database**: Support for both internal PostgreSQL and external databases
- 🔐 **Advanced Certificates**: cert-manager integration and existing TLS secret support
- 🚀 **GitOps Compatible**: No problematic hooks, fully declarative
- 🧪 **Comprehensive Testing**: Automated chart testing with kind cluster integration
- 📋 **Best Practices**: Security hardening, health checks, autoscaling support

## Quick Start

### Prerequisites

- Kubernetes 1.19+
- Helm 3.8+
- 4GB+ available memory for full deployment

### Install Chart

```bash
# Add repository (if published)
helm repo add kasm https://cfi2017.github.io/kasm-helm

# Install with default values
helm install kasm kasm/kasm

# Or install from source
git clone https://github.com/cfi2017/kasm-helm.git
helm install kasm ./charts/kasm
```

### Example Configurations

**Minimal deployment:**
```bash
helm install kasm ./charts/kasm -f charts/kasm/values-minimal.yaml
```

**External database with cert-manager:**
```bash
helm install kasm ./charts/kasm -f charts/kasm/values-external-db.yaml
```

## Development

### Pre-commit Hooks Setup

This repository uses pre-commit hooks to ensure code quality and chart integrity. The hooks automatically run:

- Helm chart linting
- YAML validation and formatting
- Chart testing with ct (chart-testing)
- Documentation generation with helm-docs
- Template validation

#### Quick Setup

```bash
# Run the setup script
./setup-precommit.sh
```

#### Manual Setup

```bash
# Install pre-commit
pip install pre-commit

# Install dependencies
pip install yamale chart-testing

# Install hooks
pre-commit install
```

#### Available Commands

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hooks
pre-commit run helm-lint
pre-commit run helm-docs
pre-commit run yamllint
pre-commit run helm-template-test

# Skip hooks for a commit (not recommended)
git commit --no-verify

# Alternative: Use Makefile commands
make dev-check          # Quick development checks
make lint               # All linting
make test               # All testing
make docs               # Generate documentation
make validate           # Comprehensive validation
```

### Chart Structure

The chart follows a logical component-based organization:

```
charts/kasm/templates/
├── _helpers.tpl                    # Template helpers
├── serviceaccount.yaml            # Shared service account
├── configmap.yaml                 # Shared configuration
├── secrets.yaml                   # Shared tokens
├── database/
│   ├── service.yaml               # One document per file
│   ├── statefulset.yaml
│   └── secret.yaml               # Component-specific secrets
├── redis/
│   ├── service.yaml
│   ├── deployment.yaml
│   └── secret.yaml
├── kasm-api/
│   ├── service.yaml
│   ├── deployment.yaml
│   └── hpa.yaml
├── networking/                    # Global networking
│   ├── ingress.yaml
│   └── certificates.yaml
└── ... (similar pattern for all components)
```

### Testing

```bash
# Lint charts
helm lint charts/kasm

# Template generation test
helm template test-release charts/kasm

# Chart testing with ct
ct lint --all --validate-maintainers=false

# Integration testing (requires kind)
ct install --all --validate-maintainers=false
```

## Chart Configuration

See the [chart documentation](charts/kasm/README.md) for detailed configuration options.

### Database Options

```yaml
# Internal PostgreSQL (default)
database:
  deploy: true
  internal:
    storageSize: "10Gi"

# External database
database:
  deploy: false
  external:
    enabled: true
    host: "postgres.example.com"
    existingSecret: "kasm-db-secret"
```

### Certificate Management

```yaml
# cert-manager integration
certificates:
  certManager:
    enabled: true
    issuerName: "letsencrypt-prod"

# Existing TLS secret
certificates:
  ingress:
    existingSecret: "my-tls-cert"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Set up pre-commit hooks: ./setup-precommit.sh`
4. Make your changes
5. Ensure all hooks pass: `pre-commit run --all-files`
6. Submit a pull request

The GitHub Actions pipeline will automatically test your changes with:
- Chart linting and validation
- Template generation testing
- Integration testing with kind cluster
- Documentation validation

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
