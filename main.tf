locals {
  base_name     = "ibm-datapower"
  subscription_name = local.base_name
  instance_name = "${local.base_name}-instance"

  instance_chart_dir = "${path.module}/charts/${local.instance_name}"
  instance_yaml_dir     = "${path.cwd}/.tmp/${local.base_name}/chart/${local.instance_name}"


  instance_values_content = {
    datapower_instance = {

      name = var.dpInstanceName
      namespace= var.namespace
      spec = {
        domains = [
          {
            name = "default"
            dpApp = {
              config = [ var.dpWebuiConfigMap ]
            }
          }
        ]
        license = {
          accept = true
          license = var.dpLicense
          use = var.dpLicenseUse
        }
        resources = {
          requests = {
            cpu    = var.cpuRequests
            memory = var.memoryRequests
          }
          limits = {
            memory = var.memoryLimits
          }
        }
        users = [
          {
            accessLevel = "privileged"
            name        = "admin"
            passwordSecret = var.passwordSecret
          }
        ]
        version = var.dpReleaseVersion
        replicas = var.replicas
      }
      webUIconfigMap={
        name="dp-webui-config"
      }
      passwordSecret={
        name="dp-credentials"
      }      
    }
  }
  values_file = "values.yaml"
  layer = "services"
  application_branch = "main"
  type="instances"
  layer_config = var.gitops_config[local.layer]
}


resource gitops_pull_secret cp_icr_io {
  name = "ibm-entitlement-key"
  namespace = var.namespace
  server_name = var.server_name
  branch = local.application_branch
  layer = local.layer
  credentials = yamlencode(var.git_credentials)
  config = yamlencode(var.gitops_config)
  kubeseal_cert = var.kubeseal_cert

  secret_name = "ibm-entitlement-key"
  registry_server = "cp.icr.io"
  registry_username = "cp"
  registry_password = var.entitlement_key
}

resource null_resource create_instance_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.instance_name}' '${local.instance_chart_dir}' '${local.instance_yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.instance_values_content)
    }
  }
}

resource gitops_module setup_gitops {
  depends_on = [null_resource.create_instance_yaml]

  name = local.instance_name
  namespace = var.namespace
  content_dir = local.instance_yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}

