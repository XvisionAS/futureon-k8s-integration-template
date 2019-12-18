

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
Frontend VUE
*******************************************************************************
*/}}

{{- define "integration.frontendvue.name" -}}
{{- default "frontendvue" .Values.frontendvue.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "integration.frontendvue.fullname" -}}
{{- $name := (include "integration.frontendvue.name" .) -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "integration.frontendvue.labels" -}}
helm.sh/chart: {{ include "integration.chart" . }}
{{ include "integration.frontendvue.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
app.kubernetes.io/name: {{ template "futureon.frontendvue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ template "futureon.frontendvue.name" . }}



{{/*
Selector labels
*/}}
{{- define "integration.frontendvue.selectorLabels" -}}
app.kubernetes.io/name: {{ include "integration.frontendvue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
*******************************************************************************
Backend VUE
*******************************************************************************
*/}}

{{- define "integration.backend.name" -}}
{{- default "backend" .Values.backend.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "integration.backend.fullname" -}}
{{- $name := (include "integration.backend.name" .) -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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
app.kubernetes.io/name: {{ template "futureon.backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ template "futureon.backend.name" . }}



{{/*
Selector labels
*/}}
{{- define "integration.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "integration.backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
