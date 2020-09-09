module "logging2" {
  source = "../"
  enable_fluent_bit        = false
  enable_elasticsearch     = false
  enable_kibana            = false
  enable_elastalert        = true
  elasticsearch_host       = "search-cloud-platform-test-zradqd7twglkaydvgwhpuypzy4.eu-west-2.es.amazonaws.com"
  elasticsearch_audit_host = "search-cloud-platform-test-zradqd7twglkaydvgwhpuypzy4.eu-west-2.es.amazonaws.com"
  elasticsearch_port       = 443
  #enable_curator_job       = true
  #curator_unit             = "minutes"
  #curator_unit_count       = 30
}