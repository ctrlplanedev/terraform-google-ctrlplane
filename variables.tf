variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "postgres_tier" {
  description = "The tier for the Postgres instance"
  type        = string
  default     = "db-f1-micro"
}
