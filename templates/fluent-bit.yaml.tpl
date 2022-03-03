
image:
  repository: fluent/fluent-bit
  tag: "${fluentbit_app_version}"
  pullPolicy: Always

serviceMonitor:
  enabled: true
  interval: 10s
  scrapeTimeout: 10s

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

## https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/configuration-file
config:
  service: |
    [SERVICE]
        Flush         1
        Log_Level     info
        Daemon        Off
        Parsers_File  parsers.conf
        Parsers_File  custom_parsers.conf
        HTTP_Server   On
        HTTP_Listen   0.0.0.0
        HTTP_Port     2020
  ## https://docs.fluentbit.io/manual/pipeline/inputs
  inputs: |
    [INPUT]
        Name              tail
        Tag               kubernetes.*
        Path              /var/log/containers/*.log
        Exclude_Path      *nx-*.log,eventrouter-*.log
        Parser            docker
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
        Skip_Long_Lines   On
    [INPUT]
        Name              tail
        Tag               nginx-ingress.*
        Path              /var/log/containers/*nx-*.log
        Exclude_Path      *modsec-controller-*.log
        Parser            generic-json
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
    [INPUT]
        Name              tail
        Tag               nginx-ingress-modsec.*
        Path              /var/log/containers/*modsec-controller-*.log
        Parser            generic-json
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
    [INPUT]
        Name              tail
        Tag               eventrouter.*
        Path              /var/log/containers/eventrouter-*.log
        Parser            generic-json
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
    [INPUT]
        Name              tail
        Tag               kube-apiserver-audit.*
        Path              /var/log/kube-apiserver-audit.log
        Parser            docker
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
        Buffer_Max_Size   5MB
        Buffer_Chunk_Size 1M

  ## https://docs.fluentbit.io/manual/pipeline/filters
  filters: |
    [FILTER]
        Name                kubernetes
        Match               kubernetes.*
        Kube_Tag_Prefix     kubernetes.var.log.containers.
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
        Merge_Log           On
        Merge_Log_Key       log_processed
    [FILTER]
        Name                kubernetes
        Match               eventrouter.*
        Kube_Tag_Prefix     eventrouter.var.log.containers.eventrouter*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
        Merge_Log           On
        Merge_Log_Key       log_processed
    [FILTER]
        Name                kubernetes
        Match               nginx-ingress.*
        Kube_Tag_Prefix     nginx-ingress.var.log.containers.nginx-ingress*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
        Merge_Log           On
        Merge_Log_Key       log_processed
    [FILTER]
        Name                kubernetes
        Match               nginx-ingress-modsec.*
        Kube_Tag_Prefix     nginx-ingress.var.log.containers.nginx-ingress-modsec*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
        Merge_Log           On
        Merge_Log_Key       log_processed

  ## https://docs.fluentbit.io/manual/pipeline/outputs
  outputs: |
    [OUTPUT]
        Name            es
        Match           kubernetes.*
        Host            ${elasticsearch_host}
        Port            443
        Type            _doc
        Time_Key        @timestamp
        Logstash_Prefix ${cluster}_kubernetes_cluster
        tls             On
        Logstash_Format On
        Replace_Dots    On
        Generate_ID     On
        Retry_Limit     False
    [OUTPUT]
        Name            es
        Match           nginx-ingress.*
        Host            ${elasticsearch_host}
        Port            443
        Type            _doc
        Time_Key        @timestamp
        Logstash_Prefix ${cluster}_kubernetes_ingress
        tls             On
        Logstash_Format On
        Replace_Dots    On
        Generate_ID     On
        Retry_Limit     False
    [OUTPUT]
        Name            es
        Match           nginx-ingress-modsec.*
        Host            ${elasticsearch_host}
        Port            443
        Type            _doc
        Time_Key        @timestamp
        Logstash_Prefix ${cluster}_kubernetes_ingress_modsec
        tls             On
        Logstash_Format On
        Replace_Dots    On
        Generate_ID     On
        Retry_Limit     False
    [OUTPUT]
        Name            es
        Match           eventrouter.*
        Host            ${elasticsearch_host}
        Port            443
        Type            _doc
        Time_Key        @timestamp
        Logstash_Prefix ${cluster}_eventrouter
        tls             On
        Logstash_Format On
        Replace_Dots    On
        Generate_ID     On
        Retry_Limit     False
    [OUTPUT]
        Name            es
        Match           kube-apiserver-audit.*
        Host            ${elasticsearch_audit_host}
        Port            443
        Type            _doc
        Time_Key        @timestamp
        Logstash_Prefix kubeapi_audit
        tls             On
        Logstash_Format On
        Replace_Dots    On
        Generate_ID     On
        Retry_Limit     5

  ## https://docs.fluentbit.io/manual/pipeline/parsers
  customParsers: |
    [PARSER]
        Name         generic-json
        Format       json
        Time_Key     time
        Time_Format  %Y-%m-%dT%H:%M:%S.%L
        Time_Keep    On
    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
        Time_Keep   Off
    # CRI Parser
    [PARSER]
        # http://rubular.com/r/tjUt3Awgg4
        Name cri
        Format regex
        Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>[^ ]*) (?<message>.*)$
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z