locals {
  base_name     = "ibm-datapower"
  subscription_name = local.base_name
  instance_name = "${local.base_name}-instance"
  bin_dir       = module.setup_clis.bin_dir

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

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}


module pull_secret {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pull-secret"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  server_name = var.server_name
  kubeseal_cert = var.kubeseal_cert
  namespace = var.namespace
  docker_username = "cp"
  docker_password = var.entitlement_key
  docker_server   = "cp.icr.io"
  secret_name     = "ibm-entitlement-key"
}

resource null_resource create_instance_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.instance_name}' '${local.instance_chart_dir}' '${local.instance_yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.instance_values_content)
    }
  }
}

resource gitops_module module {
  depends_on = [null_resource.create_instance_yaml]


  name = local.base_name
  namespace = var.namespace
  content_dir = local.instance_yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}

