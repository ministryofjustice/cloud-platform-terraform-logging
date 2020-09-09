  replicaCount: 1

  elasticsearch:
    host: search-cloud-platform-test-zradqd7twglkaydvgwhpuypzy4.eu-west-2.es.amazonaws.com
    port: 443
    useSsl: "True"

  realertIntervalMins: "0"

  rules:
    k8s_logs_critical-errors: |-
      ---
      name: Critial Errors
      index: kubernetes_cluster-*

      type: any

      filter:
      - query:
          query_string:
            query: "kubernetes.pod_name: counter"  
            analyze_wildcard: true

      alert:
      - "slack"

      slack:
      slack_title: Critial Errors
      slack_webhook_url: https://hooks.slack.com/services/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
      slack_msg_color: warning

      