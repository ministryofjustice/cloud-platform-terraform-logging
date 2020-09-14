module "logging" {
  source = "../"
  enable_fluent_bit        = false
  enable_elasticsearch     = false
  enable_kibana            = false
  enable_elastalert        = true
  elasticsearch_host       = "<ES_HOST>"
  elasticsearch_audit_host = "<ES_HOST>"
  elasticsearch_port       = <ES_PORT>
  elastalert_slack_webhook_url  = "<ELASTALERT_SLACKWEBHOOK_URL>"
}