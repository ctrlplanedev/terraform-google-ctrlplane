output "database_name" {
  value       = module.database.database_name
  description = "The name of the database."
}

output "sql_user_username" {
  value       = module.database.sql_user_username
  description = "The name of the database user."
}

output "sql_user_password" {
  value       = module.database.sql_user_password
  description = "The password of the database user."
}

output "database_instance_private_ip_address" {
  value       = module.database.database_instance_private_ip_address
  description = "The private IP address of the database instance."
}

output "redis_auth_string" {
  value       = module.redis.redis_auth_string
  description = "The authentication string of the Redis instance."
}

output "redis_host" {
  value       = module.redis.redis_host
  description = "The host of the Redis instance."
}

output "redis_port" {
  value       = module.redis.redis_port
  description = "The port of the Redis instance."
}

output "cluster_ca_certificate" {
  value     = module.gke.cluster_ca_certificate
  sensitive = true
}

output "cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}

output "ip" {
  value = google_compute_global_address.this.address
}