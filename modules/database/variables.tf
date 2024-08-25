variable "namespace" {
  description = "Namespace for the database"
  type        = string
}

variable "database_version" {
  description = "Version for Postgres"
  type        = string
  default     = "POSTGRES_16"
}

variable "network_connection_string" {
  description = "The private service networking connection string that will connect Postgres to the network."
  type        = string
}

variable "postgres_tier" {
  description = "The tier for the Postgres instance"
  type        = string
}
