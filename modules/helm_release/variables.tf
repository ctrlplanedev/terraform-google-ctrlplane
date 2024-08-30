variable "redis_host" {
  type        = string
  description = "The host for the Redis instance."
}

variable "redis_port" {
  type        = number
  description = "The port for the Redis instance."
}

variable "redis_password" {
  type        = string
  description = "The password for the Redis instance."
}

variable "postgres_user" {
  type        = string
  description = "The user for the Postgres instance."
}

variable "postgres_password" {
  type        = string
  description = "The password for the Postgres instance."
}

variable "postgres_host" {
  type        = string
  description = "The host for the Postgres instance."
}

variable "postgres_port" {
  type        = number
  description = "The port for the Postgres instance."
}

variable "postgres_database" {
  type        = string
  description = "The database for the Postgres instance."
}

variable "service_account_email" {
  type        = string
  description = "The service account email."
}

variable "global_static_ip_name" {
  type = string
}

variable "pre_shared_cert" {
  type = string
}

variable "google_auth" {
  type = object({
    client_id     = string
    client_secret = string
  })
  description = "The Google OAuth client ID and secret."
}

variable "chart_version" {
  type = string
}

variable "fqdn" {
  type    = string
  default = ""
}