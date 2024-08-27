output "database_name" {
  value       = google_sql_database.this.name
  description = "The name of the database."
}

output "sql_user_username" {
  value       = google_sql_user.this.name
  description = "The name of the database user."
}

output "sql_user_password" {
  value       = google_sql_user.this.password
  description = "The password of the database user."
}

output "database_instance_private_ip_address" {
  value       = google_sql_database_instance.this.private_ip_address
  description = "The private IP address of the database instance."
}
