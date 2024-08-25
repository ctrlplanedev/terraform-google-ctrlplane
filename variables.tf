variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "database_availability_type" {
  description = "The availability type for the Postgres instance"
  type        = string
  default     = "REGIONAL"
}

variable "database_version" {
  description = "The version of the database to use."
  type        = string
  default     = "POSTGRES_16"
}
