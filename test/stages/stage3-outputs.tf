
resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        name        = module.datapower.name
        branch      = module.datapower.branch
        namespace   = module.datapower.namespace
        server_name = module.datapower.server_name
        layer       = module.datapower.layer
        layer_dir   = module.datapower.layer == "infrastructure" ? "1-infrastructure" : (module.datapower.layer == "services" ? "2-services" : "3-applications")
        type        = module.datapower.type
      })
    }
  }
}
