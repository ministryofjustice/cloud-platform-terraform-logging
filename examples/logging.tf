/*
 * When using this module through the cloud-platform-environments,
 *
*/

module "logging" {
  source = "../"

  opensearch_app_host             = "placeholder"
  elasticsearch_host              = "placeholder-elasticsearch"

  enable_fluent_bit     = false
}
