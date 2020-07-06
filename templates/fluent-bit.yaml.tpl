
image:
  fluent_bit:
    repository: fluent/fluent-bit
    tag: ${fluent-bit_version}
  pullPolicy: Always
  # If specified, use these secrets to access the image
  # pullSecrets:
  #   - name: registry-secret


# When enabled, exposes json and prometheus metrics on {{ .Release.Name }}-metrics service
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
    additionalLabels: {}
    # namespace: monitoring
    # interval: 30s
    # scrapeTimeout: 10s

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

# When enabled, pods will bind to the node's network namespace.
hostNetwork: false

# Which DNS policy to use for the pod.
# Consider switching to 'ClusterFirstWithHostNet' when 'hostNetwork' is enabled.
dnsPolicy: ClusterFirst

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

audit:
  enable: false
  input:
    memBufLimit: 35MB
    parser: docker
    tag: audit.*
    path: /var/log/kube-apiserver-audit.log
    bufferChunkSize: 2MB
    bufferMaxSize: 10MB
    skipLongLines: On
    key: kubernetes-audit

rbac:
  # Specifies whether RBAC resources should be created
  create: true
  # Specifies whether a PodSecurityPolicy should be created
  pspEnabled: false

taildb:
  directory: /var/lib/fluent-bit

serviceAccount:
  # Specifies whether a ServiceAccount should be created
  create: true