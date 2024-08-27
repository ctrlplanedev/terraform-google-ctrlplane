output "redis_ca_cert" {
  value = google_redis_instance.this.server_ca_certs[0].cert
}

output "redis_auth_string" {
  value = google_redis_instance.this.auth_string
}

output "redis_host" {
  value = google_redis_instance.this.host
}

output "redis_port" {
  value = google_redis_instance.this.port
}
