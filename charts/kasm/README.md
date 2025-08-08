# kasm

![Version: 1.17.0](https://img.shields.io/badge/Version-1.17.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.17.0](https://img.shields.io/badge/AppVersion-1.17.0-informational?style=flat-square)

Kasm is a platform specializing in providing secure browser-based workspaces
for a wide range of applications and industries. Its main goal is to provide
isolated and secure environments that can be accessed via web browsers,
ensuring that users can perform tasks without risking the security of their
local systems.

**Homepage:** <https://kasmweb.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| CFI2017 |  | <https://github.com/cfi2017/kasm-helm> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| certificates.certManager.enabled | bool | `false` |  |
| certificates.certManager.issuerKind | string | `"ClusterIssuer"` |  |
| certificates.certManager.issuerName | string | `""` |  |
| certificates.ingress.certificate | string | `""` |  |
| certificates.ingress.create | bool | `true` |  |
| certificates.ingress.existingSecret | string | `""` |  |
| certificates.ingress.privateKey | string | `""` |  |
| certificates.proxy.certificate | string | `""` |  |
| certificates.proxy.create | bool | `true` |  |
| certificates.proxy.existingSecret | string | `""` |  |
| certificates.proxy.privateKey | string | `""` |  |
| certificates.rdpGateway.certificate | string | `""` |  |
| certificates.rdpGateway.create | bool | `true` |  |
| certificates.rdpGateway.existingSecret | string | `""` |  |
| certificates.rdpGateway.privateKey | string | `""` |  |
| database.deploy | bool | `true` |  |
| database.external.database | string | `"kasm"` |  |
| database.external.enabled | bool | `false` |  |
| database.external.existingSecret | string | `""` |  |
| database.external.existingSecretPasswordKey | string | `"password"` |  |
| database.external.host | string | `""` |  |
| database.external.port | int | `5432` |  |
| database.external.sslMode | string | `"prefer"` |  |
| database.external.username | string | `"kasmapp"` |  |
| database.internal.image.repository | string | `"kasmweb/postgres"` |  |
| database.internal.image.tag | string | `"1.17.0"` |  |
| database.internal.persistentVolumeClaimRetentionPolicy.enabled | bool | `false` |  |
| database.internal.persistentVolumeClaimRetentionPolicy.whenDeleted | string | `"Retain"` |  |
| database.internal.persistentVolumeClaimRetentionPolicy.whenScaled | string | `"Retain"` |  |
| database.internal.resources | object | `{}` |  |
| database.internal.storageClassName | string | `""` |  |
| database.internal.storageSize | string | `"10Gi"` |  |
| global.altHostnames | list | `[]` |  |
| global.clusterDomain | string | `"cluster.local"` |  |
| global.hostname | string | `""` |  |
| global.image.pullPolicy | string | `"IfNotPresent"` |  |
| global.image.pullSecrets | list | `[]` |  |
| global.image.restartPolicy | string | `"Always"` |  |
| global.ingressClassName | string | `""` |  |
| global.namespace | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| kasm.applyHardening | bool | `true` |  |
| kasm.deploymentSize | string | `"small"` |  |
| kasm.name | string | `"kasm"` |  |
| kasm.zoneName | string | `"default"` |  |
| nodeSelector | object | `{}` |  |
| passwords.adminPassword | string | `""` |  |
| passwords.dbPassword | string | `""` |  |
| passwords.managerToken | string | `""` |  |
| passwords.redisPassword | string | `""` |  |
| passwords.serviceToken | string | `""` |  |
| passwords.userPassword | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| redis.deploy | bool | `true` |  |
| redis.external.enabled | bool | `false` |  |
| redis.external.existingSecret | string | `""` |  |
| redis.external.existingSecretPasswordKey | string | `"password"` |  |
| redis.external.host | string | `""` |  |
| redis.external.port | int | `6379` |  |
| redis.image.repository | string | `"redis"` |  |
| redis.image.tag | string | `"5-alpine"` |  |
| redis.resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| services.api.enabled | bool | `true` |  |
| services.api.healthcheck.enabled | bool | `true` |  |
| services.api.healthcheck.path | string | `"/api/__healthcheck"` |  |
| services.api.healthcheck.port | int | `8080` |  |
| services.api.image.repository | string | `"kasmweb/api"` |  |
| services.api.image.tag | string | `"1.17.0"` |  |
| services.api.name | string | `"kasm-api"` |  |
| services.api.replicas | int | `1` |  |
| services.api.resources | object | `{}` |  |
| services.guac.enabled | bool | `true` |  |
| services.guac.healthcheck.enabled | bool | `true` |  |
| services.guac.image.repository | string | `"kasmweb/kasm-guac"` |  |
| services.guac.image.tag | string | `"1.17.0"` |  |
| services.guac.name | string | `"kasm-guac"` |  |
| services.guac.replicas | int | `1` |  |
| services.guac.resources | object | `{}` |  |
| services.manager.enabled | bool | `true` |  |
| services.manager.healthcheck.enabled | bool | `true` |  |
| services.manager.image.repository | string | `"kasmweb/manager"` |  |
| services.manager.image.tag | string | `"1.17.0"` |  |
| services.manager.name | string | `"kasm-manager"` |  |
| services.manager.replicas | int | `1` |  |
| services.manager.resources | object | `{}` |  |
| services.proxy.enabled | bool | `true` |  |
| services.proxy.healthcheck.enabled | bool | `true` |  |
| services.proxy.image.repository | string | `"kasmweb/proxy"` |  |
| services.proxy.image.tag | string | `"1.17.0"` |  |
| services.proxy.name | string | `"kasm-proxy"` |  |
| services.proxy.replicas | int | `1` |  |
| services.proxy.resources | object | `{}` |  |
| services.proxy.serviceKeepalive | int | `16` |  |
| services.rdpGateway.enabled | bool | `false` |  |
| services.rdpGateway.healthcheck.enabled | bool | `true` |  |
| services.rdpGateway.image.repository | string | `"kasmweb/rdp-gateway"` |  |
| services.rdpGateway.image.tag | string | `"1.17.0"` |  |
| services.rdpGateway.name | string | `"kasm-rdp-gateway"` |  |
| services.rdpGateway.replicas | int | `1` |  |
| services.rdpGateway.resources | object | `{}` |  |
| services.rdpHttpsGateway.enabled | bool | `false` |  |
| services.rdpHttpsGateway.healthcheck.enabled | bool | `true` |  |
| services.rdpHttpsGateway.image.repository | string | `"kasmweb/rdp-https-gateway"` |  |
| services.rdpHttpsGateway.image.tag | string | `"1.17.0"` |  |
| services.rdpHttpsGateway.name | string | `"kasm-rdp-https-gateway"` |  |
| services.rdpHttpsGateway.replicas | int | `1` |  |
| services.rdpHttpsGateway.resources | object | `{}` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
