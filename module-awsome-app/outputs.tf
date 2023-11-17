output "external_ip" {
  value       = "https://${module.lb-http.external_ip}"
  description = "The external IPv4 assigned"
}
