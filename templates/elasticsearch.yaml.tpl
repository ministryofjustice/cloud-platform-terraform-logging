elasticsearch:
  enabled: true
  replicas: 2
  persistence:
    enabled: false


metrics:
  enabled: false
  serviceMonitor:
    enabled: false

backend:
  type: es

fullConfigMap: true
existingConfigMap: "fluent-bit-config"


