variable "dependence_prometheus" {
  description = "Prometheus module dependence - it is required in order to use this module."
}

variable "dependence_priority_classes" {
  description = "Priority Classes dependence - it is required in order to use this module."
}

variable "elasticsearch_host" {
  description = "The elasticsearch host where logs are going to be shipped"
}

variable "elasticsearch_audit_host" {
  description = "The elasticsearch audit host where logs are going to be shipped"
}

variable "enable_fluent_bit" {
  description = "Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use"
  default     = false
  type        = bool
}

variable "enable_curator_cronjob" {
  description = "Enable or not elastic-search curator cronjob - which runs every day to delete indices older than 30 days"
  default     = false
  type        = bool
}
