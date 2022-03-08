resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        dpInstanceName        = module.datapower.dpInstanceName
        dpWebuiConfigMap      = module.datapower.dpWebuiConfigMap
        adminPasswordSecret   = module.datapower.adminPasswordSecret
      })
    }
  }
}
