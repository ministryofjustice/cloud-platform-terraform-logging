module "logging" {
  source = "../"
  enable_elasticsearch     = true
  enable_kibana            = true
  elasticsearch_host       = "elasticsearch-master"
  elasticsearch_port       = 9200
}