  replicaCount: 1

  elasticsearch:
    host: "${elasticsearch_host}"
    port: ${elasticsearch_port}
    useSsl: "True"

  realertIntervalMins: "0"

  rules:
    k8s_logs_critical-errors: |-
      ---
      name: <NAME>
      index: kubernetes_cluster-*

      type: any

      filter:
      - query:
          query_string:
            query: "kubernetes.pod_name: <POD_NAME>"  
            analyze_wildcard: true

      alert:
      - "slack"

      slack:
      slack_title: <TITLE>
      slack_webhook_url: "${elastalert_slack_webhook_url}"
      slack_msg_color: warning
      