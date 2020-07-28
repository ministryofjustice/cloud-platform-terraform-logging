
metrics:
  enabled: true
  serviceMonitor:
    enabled: true

backend:
  type: es

## By default there different 'files' provides in the config
## (fluent-bit.conf, custom_parsers.conf). This defeats
## changing a configmap (since it uses subPath). If this
## variable is set, the user is assumed to have provided,
## in 'existingConfigMap' the entire config (etc/*) of fluent-bit,
## parsers and system config. In this case, no subPath is
## used
fullConfigMap: true

## ConfigMap override where fullname is {{.Release.Name}}-{{.Values.existingConfigMap}}
## Defining existingConfigMap will cause templates/config.yaml
## to NOT generate a ConfigMap resource
##
existingConfigMap: "fluent-bit-config"

## Node tolerations for fluent-bit scheduling to nodes with taints
## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
##
tolerations:
  - key: node-role.kubernetes.io/master
    effect: NoSchedule
  - key: "monitoring-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"

