module "datapower-operator" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-datapower-operator.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  catalog = module.cp_catalogs.catalog_ibmoperators
  namespace       = module.gitops_namespace.name
  entitlement_key = module.cp_catalogs.entitlement_key
  channel = module.cp4i-dependencies.datapower.channel
}
