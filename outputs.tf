
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


output "name" {
  description = "The name of the module"
  value       = local.base_name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = var.namespace
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [resource.gitops_module.setup_gitops]
}
