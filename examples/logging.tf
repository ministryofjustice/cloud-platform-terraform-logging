/*
 * When using this module through the cloud-platform-environments,
 *
*/

module "logging" {
  source = "../"

  elasticsearch_host       = "placeholder-elasticsearch"
  elasticsearch_audit_host = ""

  dependence_prometheus       = "status"
  enable_curator_cronjob      = false
  enable_fluent_bit           = false

}

