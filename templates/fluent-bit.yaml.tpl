metrics:
  enabled: true
  serviceMonitor:
    enabled: true

backend:
  type: es

fullConfigMap: true
existingConfigMap: "fluent-bit-config"

tolerations:
  - key: node-role.kubernetes.io/master
    effect: NoSchedule
  - key: "monitoring-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  - key: "ingress-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule" 
