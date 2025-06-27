variable "elasticsearch_host" {
  description = "The elasticsearch host where logs are going to be shipped"
}

variable "opensearch_app_host" {
  description = "The opensearch host where user app logs are going to be shipped"
}

variable "enable_fluent_bit" {
  description = "Enable or not fluent-bit Helm Chart - change the default to true once it is ready to use"
  default     = true
  type        = bool
}

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
  default     = ""
}

variable "application" {
  description = "Application name"
  type        = string
  default     = ""
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
  default     = ""
}

variable "team_name" {
  description = "Team name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace name"
  type        = string
  default     = ""
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = ""
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
  default     = ""
}