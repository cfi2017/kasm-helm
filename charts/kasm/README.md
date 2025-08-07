# Kasm Workspaces Helm Chart

This chart deploys [Kasm Workspaces](https://kasmweb.com) on Kubernetes following Helm best practices and GitOps compatibility.

## Features

### Improvements over Original Chart

- ✅ **External Database Support**: Connect to existing PostgreSQL databases
- ✅ **cert-manager Integration**: Automatic certificate management
- ✅ **GitOps Compatible**: No helm hooks that break ArgoCD workflows
- ✅ **Idiomatic Helm**: Follows Helm best practices throughout
- ✅ **Security Hardened**: Pod security contexts and STIG compliance
- ✅ **Production Ready**: Persistent storage, health checks, autoscaling

### Supported Components

- **Kasm API**: Core API service with health checks
- **Kasm Manager**: Agent management service
- **Kasm Proxy**: Nginx reverse proxy with proper upstream configuration
- **Guacamole**: Remote desktop connection service
- **PostgreSQL**: Internal database or external database support
- **Redis**: Internal cache or external Redis support
- **RDP Gateways**: Optional RDP connection services

## Quick Start

### Minimal Installation

```bash
helm install kasm ./charts/kasm --values charts/kasm/values-minimal.yaml
```

### External Database Installation

```bash
# Create database secret first
kubectl create secret generic kasm-db-secret --from-literal=password=mydbpassword

# Install with external database
helm install kasm ./charts/kasm --values charts/kasm/values-external-db.yaml
```

### With cert-manager

```bash
helm install kasm ./charts/kasm \
  --set global.hostname=kasm.example.com \
  --set certificates.certManager.enabled=true \
  --set certificates.certManager.issuerName=letsencrypt-prod \
  --set ingress.enabled=true
```

## Configuration

### Database Options

| Option | Description | Default |
|--------|-------------|---------|
| `database.deploy` | Deploy internal PostgreSQL | `true` |
| `database.external.enabled` | Use external database | `false` |
| `database.external.host` | External database host | `""` |
| `database.external.existingSecret` | Reference to existing database secret | `""` |

### Certificate Management

| Option | Description | Default |
|--------|-------------|---------|
| `certificates.certManager.enabled` | Use cert-manager for certificates | `false` |
| `certificates.certManager.issuerName` | cert-manager issuer name | `""` |
| `certificates.ingress.existingSecret` | Use existing TLS secret | `""` |

### Deployment Sizes

| Size | Description | API Replicas | Resources |
|------|-------------|--------------|-----------|
| `small` | Development/testing | 1 | Low |
| `medium` | Production | 2 | Medium |
| `large` | High availability | 3 | High |

## Examples

See the included example values files:

- `values-minimal.yaml`: Simple deployment with internal database
- `values-external-db.yaml`: External database with cert-manager

## Security

The chart implements several security best practices:

- Non-root user containers
- Read-only root filesystems
- Pod security contexts
- Secret-based password management
- Network policies support

## GitOps Compatibility

This chart is fully compatible with GitOps workflows:

- No helm hooks that interfere with ArgoCD
- Init containers for service dependencies
- Declarative configuration management
- Supports ArgoCD sync policies

## Requirements

- Kubernetes 1.19+
- Helm 3.8+
- cert-manager (optional, for automatic certificates)
- External PostgreSQL (optional, for external database)
- External Redis (optional, for external cache)

## Support

For issues with this chart, please create an issue in the repository.

For Kasm Workspaces product support, visit [https://kasmweb.com](https://kasmweb.com).