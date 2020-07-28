# cloud-platform-terraform-logging

Terraform module that deploys cloud-platform logging solution. It includes components like: fluentd, eventrouter, circle-ci-stats, etc

## Usage

```hcl
module "logging" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-logging?ref=0.0.1"

  elasticsearch_host       = replace(terraform.workspace, "live", "") != terraform.workspace ? "search-cloud-platform-live-dibidbfud3uww3lpxnhj2jdws4.eu-west-2.es.amazonaws.com" : "placeholder-elasticsearch"
  elasticsearch_audit_host = replace(terraform.workspace, "live", "") != terraform.workspace ? "search-cloud-platform-audit-dq5bdnjokj4yt7qozshmifug6e.eu-west-2.es.amazonaws.com" : ""

  dependence_prometheus       = module.prometheus.helm_prometheus_operator_status
  dependence_priority_classes = kubernetes_priority_class.node_critical
  enable_fluent_bit           = true
}
```

## Inputs

| Name                         | Description                                        | Type | Default | Required |
|------------------------------|----------------------------------------------------|:----:|:-------:|:--------:|
| elasticsearch_host           | The ES host where logs are going to be sent        | string   | false | yes |
| elasticsearch_audit_host     | The ES audit host where logs are going to be sent  | string   | false | no |
| dependence_prometheus        | Prometheus Dependence variable                     | string   |       | yes |
| dependence_priority_classes  | Priority class dependence                          | string   |       | yes |
| enable_fluent_bit            | Enable or not fluent-bit Helm Ch                   | string   | false | yes |




## Outputs

None

## Notes

Currently in `fluent-bit.config` when the `Log_Level` is set to `debug` a high number of fluent-d / fluent-bit logs are injested, which can significantly increase the ES storage and cause performance problems. To avoid this the following two options can be done. 

(1) Change the `Log_Level` to `info` as below:

`Log_Level     info`

(2) This has not be been tried and tested but filtering out fluent-d / fluent-bit logs could also be an option by adding the following to the 'input-kubernetes.config' file:

`Exclude_path     *fluent-bit-daemon*,*fluentd*`

Parsers can also be added to Pod annoations to suggest the logs should be parsed using a pre-defined parser. More details on this can be found here:
https://docs.fluentbit.io/manual/pipeline/filters/kubernetes


Pending Actions: 

Currently it has not been possible to parse the ingress logs as individual fields for fluent-bit in the same way its done for fluent-d. In an attempt the following has been tried without success:

(1) Add the parser annotation to the ingress controller pod 

`annotations:
    deployment.kubernetes.io/revision: "2"
    fluentbit.io/parser: k8s-nginx-ingress`

(2) Apply custom regex of the ingress parser, as per this guide here:

 https://stackoverflow.com/questions/53116402/fluentbit-kubernetes-how-to-extract-fields-from-existing-logs