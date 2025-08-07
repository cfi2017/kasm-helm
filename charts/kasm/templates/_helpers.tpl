{{/*
Expand the name of the chart.
*/}}
{{- define "kasm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kasm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kasm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kasm.labels" -}}
helm.sh/chart: {{ include "kasm.chart" . }}
{{ include "kasm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kasm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kasm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kasm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kasm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the namespace to use
*/}}
{{- define "kasm.namespace" -}}
{{- .Values.global.namespace | default .Release.Namespace }}
{{- end }}

{{/*
Common Kasm labels for all components
*/}}
{{- define "kasm.commonLabels" -}}
kasm.app/name: {{ .Values.kasm.name | default "kasm" }}
kasm.app/zone: {{ .Values.kasm.zoneName | default "default" }}
{{ include "kasm.labels" . }}
{{- end }}

{{/*
Component-specific labels
*/}}
{{- define "kasm.componentLabels" -}}
{{- $componentName := . -}}
kasm.app/component: {{ $componentName }}
{{- end }}

{{/*
Image pull secrets
*/}}
{{- define "kasm.imagePullSecrets" -}}
{{- if .Values.global.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.global.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Database host name
*/}}
{{- define "kasm.databaseHost" -}}
{{- if .Values.database.external.enabled }}
{{- .Values.database.external.host }}
{{- else }}
{{- printf "%s-db" (include "kasm.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Database port
*/}}
{{- define "kasm.databasePort" -}}
{{- if .Values.database.external.enabled }}
{{- .Values.database.external.port | default 5432 }}
{{- else }}
{{- 5432 }}
{{- end }}
{{- end }}

{{/*
Redis host name
*/}}
{{- define "kasm.redisHost" -}}
{{- if .Values.redis.external.enabled }}
{{- .Values.redis.external.host }}
{{- else }}
{{- printf "%s-redis" (include "kasm.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Redis port
*/}}
{{- define "kasm.redisPort" -}}
{{- if .Values.redis.external.enabled }}
{{- .Values.redis.external.port | default 6379 }}
{{- else }}
{{- 6379 }}
{{- end }}
{{- end }}

{{/*
Get certificate secret name for a service
*/}}
{{- define "kasm.certificateSecret" -}}
{{- $service := .service -}}
{{- $context := .context -}}
{{- $certConfig := index $context.Values.certificates $service -}}
{{- if $certConfig.existingSecret }}
{{- $certConfig.existingSecret }}
{{- else if $context.Values.certificates.certManager.enabled }}
{{- printf "%s-%s-tls" (include "kasm.fullname" $context) ($service | lower | replace "gateway" "gw") }}
{{- else }}
{{- printf "%s-%s-cert" (include "kasm.fullname" $context) ($service | lower | replace "gateway" "gw") }}
{{- end }}
{{- end }}

{{/*
Determine if we should create a certificate
*/}}
{{- define "kasm.shouldCreateCertificate" -}}
{{- $service := .service -}}
{{- $context := .context -}}
{{- $certConfig := index $context.Values.certificates $service -}}
{{- if and $certConfig.create (not $certConfig.existingSecret) }}
{{- true }}
{{- else }}
{{- false }}
{{- end }}
{{- end }}

{{/*
Resource calculation based on deployment size
*/}}
{{- define "kasm.resources" -}}
{{- $component := .component -}}
{{- $context := .context -}}
{{- $serviceConfig := index $context.Values.services $component -}}
{{- if $serviceConfig.resources }}
{{- toYaml $serviceConfig.resources }}
{{- else }}
{{- $size := $context.Values.kasm.deploymentSize | default "small" -}}
{{- if eq $component "api" }}
{{- if eq $size "small" }}
requests:
  cpu: 100m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- else if eq $size "medium" }}
requests:
  cpu: 200m
  memory: 512Mi
limits:
  cpu: 1000m
  memory: 1Gi
{{- else if eq $size "large" }}
requests:
  cpu: 500m
  memory: 1Gi
limits:
  cpu: 2000m
  memory: 2Gi
{{- end }}
{{- else if eq $component "proxy" }}
{{- if eq $size "small" }}
requests:
  cpu: 50m
  memory: 128Mi
limits:
  cpu: 200m
  memory: 256Mi
{{- else if eq $size "medium" }}
requests:
  cpu: 100m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- else if eq $size "large" }}
requests:
  cpu: 200m
  memory: 512Mi
limits:
  cpu: 1000m
  memory: 1Gi
{{- end }}
{{- else }}
{{- if eq $size "small" }}
requests:
  cpu: 50m
  memory: 128Mi
limits:
  cpu: 200m
  memory: 256Mi
{{- else if eq $size "medium" }}
requests:
  cpu: 100m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- else if eq $size "large" }}
requests:
  cpu: 200m
  memory: 512Mi
limits:
  cpu: 1000m
  memory: 1Gi
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Replica count calculation based on deployment size
*/}}
{{- define "kasm.replicas" -}}
{{- $component := .component -}}
{{- $context := .context -}}
{{- $serviceConfig := index $context.Values.services $component -}}
{{- if $serviceConfig.replicas }}
{{- $serviceConfig.replicas }}
{{- else }}
{{- $size := $context.Values.kasm.deploymentSize | default "small" -}}
{{- if eq $size "small" }}
{{- 1 }}
{{- else if eq $size "medium" }}
{{- 2 }}
{{- else if eq $size "large" }}
{{- 3 }}
{{- end }}
{{- end }}
{{- end }}
