
fluent_elasticsearch_host: "${elasticsearch_host}"
fluent_elasticsearch_audit_host: "${elasticsearch_audit_host}"
fluent_kubernetes_cluster_name: "${cluster_name}"

serviceMonitor:
  enabled: true

tolerations:
  - key: node-role.kubernetes.io/master
    effect: NoSchedule
  - key: "monitoring-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
