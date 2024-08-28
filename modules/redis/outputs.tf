output "redis_auth_string" {
  value = google_redis_instance.this.auth_string
}

output "redis_host" {
  value = google_redis_instance.this.host
}

output "redis_port" {
  value = google_redis_instance.this.port
}
