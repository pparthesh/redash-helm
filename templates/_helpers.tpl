{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "redash.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redash.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "redash.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
redash host
*/}}
{{- define "redash.host" -}}
{{- range $host := .Values.ingress.hosts -}}
  {{- printf "https://%s" $host | quote -}}
{{- end -}}
{{- end -}}

{{/*
redash redis
*/}}
{{- define "redash.redisURL" -}}
{{- if .Values.externalRedis.enabled -}}
{{- $redisport := .Values.externalRedis.RedisPort | toString -}}
{{- printf "redis://%s@%s:%s/0" .Values.externalRedis.RedisPassword .Values.externalRedis.RedisHost $redisport | quote -}}
{{- else -}}
{{- $redisport := .Values.redis.RedisPort | toString -}}
{{- printf "redis://%s@%s-redis-master:%s/0" .Values.redis.RedisPassword .Values.redis.RedisHost $redisport | quote -}}
{{- end -}}
{{- end -}}

{{/*
redash postgres
*/}}
{{- define "redash.postgresConnectionURL" -}}
{{- if .Values.externalPostgres.enabled -}}
{{- $psqlport := .Values.externalPostgres.postgresqlPort | toString -}}
{{- printf "postgresql://%s:%s@%s:%s/%s" .Values.externalPostgres.postgresqlUsername .Values.externalPostgres.postgresqlPassword .Values.externalPostgres.postgresqlHost $psqlport .Values.externalPostgres.postgresqlDatabase | quote -}}
{{- else -}}
{{- if .Values.nameOverride -}}
{{- $hostnameoverride := printf "%s-postgresql" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- $host := (include "redash.fullname" .) -}}
{{- printf "postgresql://%s:%s@%s-postgresql:5432/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword $host .Values.postgresql.postgresqlDatabase | quote -}}
{{- else -}}
{{- $hostnamedefault := printf "%s-postgresql" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- $host := $hostnamedefault | trunc 63 | trimSuffix "-" -}}
{{- printf "postgresql://%s:%s@%s:5432/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword $host .Values.postgresql.postgresqlDatabase | quote -}}
{{- end -}}
{{- end -}}
{{- end -}}
