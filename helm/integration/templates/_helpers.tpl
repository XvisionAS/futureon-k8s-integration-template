{{/* vim: set filetype=mustache: */}}

{{/*
*******************************************************************************
Global
*******************************************************************************
*/}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "integration.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "integration.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "integration.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "integration.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "integration.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "integration.labels" -}}
helm.sh/chart: {{ include "integration.chart" . }}
{{ include "integration.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "integration.selectorLabels" -}}
app.kubernetes.io/name: {{ include "integration.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
*******************************************************************************
Svelte Frontend
*******************************************************************************
*/}}

{{- define "integration.frontendsvelte.name" -}}
{{- default "frontendsvelte" .Values.frontendsvelte.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "integration.frontendsvelte.fullname" -}}
{{- $name := (include "integration.frontendsvelte.name" .) -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "integration.frontendsvelte.hostname" -}}
{{- $defaultHostname := printf "%s.%s" (include "integration.frontendsvelte.fullname" .) .Values.defaultDnsDomain }}
{{- default $defaultHostname .Values.frontendsvelte.hostname -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "integration.frontendsvelte.labels" -}}
helm.sh/chart: {{ include "integration.chart" . }}
{{ include "integration.frontendsvelte.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
app.kubernetes.io/name: {{ template "futureon.frontendsvelte.name" . }}

{{/*
Selector labels
*/}}
{{- define "integration.frontendsvelte.selectorLabels" -}}
app.kubernetes.io/name: {{ include "integration.frontendsvelte.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
*******************************************************************************
Backend
*******************************************************************************
*/}}

{{- define "integration.backend.name" -}}
{{- default "backend" .Values.backend.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "integration.backend.fullname" -}}
{{- $name := (include "integration.backend.name" .) -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "integration.backend.hostname" -}}
{{- $defaultHostname := printf "%s.%s" (include "integration.backend.fullname" .) .Values.defaultDnsDomain }}
{{- default $defaultHostname .Values.backend.hostname -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "integration.backend.labels" -}}
helm.sh/chart: {{ include "integration.chart" . }}
{{ include "integration.backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
app.kubernetes.io/component: {{ template "futureon.backend.name" . }}

{{/*
Selector labels
*/}}
{{- define "integration.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "integration.backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}