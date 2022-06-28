locals {
  
  namespace = var.namespace

  name          = "gitops-cp-datapower"
  bin_dir       = module.setup_clis.bin_dir
  
  base_name          = "ibm-datapower"
  instance_name      = "${local.base_name}-instance"

  instance_chart_dir = "${path.module}/charts/${local.instance_name}"
  yaml_dir           = "${path.cwd}/.tmp/${local.name}/chart/${local.instance_name}"
  

  service_url   = "http://${local.name}.${local.namespace}"


  values_content = {
    datapower_instance = {
      name = var.dpInstanceName
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

    }
  }

  values_file = "values.yaml"
  layer = "services"
  type  = "base"
  application_branch = "main"
  
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
  namespace= local.namespace
  docker_username = "cp"
  docker_password = var.entitlement_key
  docker_server   = "cp.icr.io"
  secret_name     = "ibm-entitlement-key"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.instance_name}' '${local.instance_chart_dir}' '${local.yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}

resource null_resource setup_gitops {


  triggers = {
    name = local.instance_name

    namespace= local.namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    type = local.type
    git_credentials = yamlencode(var.git_credentials)
    gitops_config   = yamlencode(var.gitops_config)
    bin_dir = local.bin_dir
  }

  provisioner "local-exec" {
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }
}
