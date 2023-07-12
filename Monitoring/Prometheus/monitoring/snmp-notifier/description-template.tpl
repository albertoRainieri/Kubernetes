{{- if .Alerts -}}
{{- range $severity, $alerts := (groupAlertsByLabel .Alerts "severity") -}}
Status: {{ $severity }}
{{- range $index, $alert := $alerts }}
- Alert: {{ $alert.Labels.alertname }}
  Summary: {{ $alert.Annotations.summary }}
  Description: {{ $alert.Annotations.description }}
  Message: {{ $alert.Annotations.message }}
{{ end }}
{{ end }}
{{ else -}}
Status: OK
{{- end -}}
