output "backend_public_ip" {
  value = module.backend.public_ip
}

output "frontend_public_ip" {
  value = module.frontend.public_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}