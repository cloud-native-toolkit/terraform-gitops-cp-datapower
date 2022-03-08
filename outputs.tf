
output "dpInstanceName" {
  description = "The name of DataPower instance"
  value       = var.dpInstanceName
}

output "dpWebuiConfigMap" {
  description = "Name of configmap which contains the configuration to enable WebUI"
  value       = var.dpWebuiConfigMap
}

output "adminPasswordSecret" {
  description = "Secret which stores admin password"
  value = var.passwordSecret
}