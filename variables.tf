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