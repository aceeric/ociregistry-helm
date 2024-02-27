{{/*
Expand the name of the chart.
*/}}
{{- define "ociregistry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ociregistry.fullname" -}}
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
{{- define "ociregistry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ociregistry.labels" -}}
helm.sh/chart: {{ include "ociregistry.chart" . }}
{{ include "ociregistry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ociregistry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ociregistry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ociregistry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ociregistry.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image URL
*/}}
{{- define "ociregistry.image" -}}
{{- $sep := ":" }}
{{- $ref := .Values.image.tag }}
{{- if ne (default "" .Values.image.digest) "" }}
{{- $sep = "@" }}
{{- $ref = .Values.image.digest }}
{{- end }}
{{- if ne .Values.image.registry "" }}
{{- printf "%s/%s%s%s" .Values.image.registry .Values.image.repository $sep $ref }}
{{- else }}
{{- printf "%s%s%s" .Values.image.repository $sep $ref }}
{{- end }}
{{- end }}

{{/*
Emanate args for the server
*/}}
{{- define "ociregistry.args" -}}
{{- $args := 0 }}
{{- if .Values.upstreamConfig }}
{{- $args = 1 }}
{{- end }}
{{- if and .Values.configs .Values.configs.port }}
{{- $args = 1 }}
{{- end }}
{{- if and .Values.configs .Values.configs.logLevel }}
{{- $args = 1 }}
{{- end }}
{{- if and .Values.configs .Values.configs.configPath }}
{{- $args = 1 }}
{{- end }}
{{- if and .Values.configs .Values.configs.imagePath }}
{{- $args = 1 }}
{{- end }}
{{- if and .Values.configs .Values.configs.pullTimeout }}
{{- $args = 1 }}
{{- end }}
{{- if eq $args 0 }}
{{- printf "args: []" }}
{{- else }}
{{- $arg := "args:" }}
{{- if .Values.upstreamConfig }}
{{- $arg = printf "%s\n- --config-path=%s" $arg .Values.upstreamConfig.mountPath }}
{{- end }}
{{- if and .Values.configs .Values.configs.port }}
{{- $arg = printf "%s\n- --port=%v" $arg .Values.configs.port }}
{{- end }}
{{- if and .Values.configs .Values.configs.logLevel }}
{{- $arg = printf "%s\n- --log-level=%s" $arg .Values.configs.logLevel }}
{{- end }}
{{- if and .Values.configs .Values.configs.configPath }}
{{- $arg = printf "%s\n- --config-path=%s" $arg .Values.configs.configPath }}
{{- end }}
{{- if and .Values.configs .Values.configs.imagePath }}
{{- $arg = printf "%s\n- --image-path=%s" $arg .Values.configs.imagePath }}
{{- end }}
{{- if and .Values.configs .Values.configs.pullTimeout }}
{{- $arg = printf "%s\n- --pull-timeout=%v" $arg .Values.configs.pullTimeout }}
{{- end }}
{{- printf $arg }}
{{- end }}
{{- end }}
