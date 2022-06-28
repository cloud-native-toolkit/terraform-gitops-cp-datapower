module "datapower" {
  source = "./module"
  depends_on = [
    module.datapower-operator
  ]

  gitops_config   = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name     = module.gitops.server_name
  namespace       = module.gitops_namespace.name
  kubeseal_cert   = module.gitops.sealed_secrets_cert
  entitlement_key = module.cp_catalogs.entitlement_key

  # Pulling variables from CP4I dependency management
  dpReleaseVersion  = module.cp4i-dependencies.datapower.version
  dpLicense    = module.cp4i-dependencies.datapower.license
  dpLicenseUse = module.cp4i-dependencies.datapower.license_use

}


