# CP4I - DataPower instance module

Module to create DataPower instance(s) using a DataPower operator. The module also enables the WebUI using a config map and sets an admin password in a secret.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v15
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- GitOps             - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace          - github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- Catalogs           - github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs.git
- DataPower Operator - github.com/cloud-native-toolkit/terraform-gitops-cp-datapower.git

## Example usage

```hcl-terraform
module "datapower" {
   source = "./module"
   depends_on = [
     module.gitops_cp_datapower_operator
   ]
   gitops_config = module.gitops.gitops_config
   git_credentials = module.gitops.git_credentials
   server_name = module.gitops.server_name
   namespace = module.gitops_namespace.name
   catalog = module.cp_catalogs.catalog_ibmoperators
   entitlement_key = module.cp_catalogs.entitlement_key
   kubeseal_cert = module.gitops.sealed_secrets_cert


   #Pulling variables from CP4I dependency management
   dpReleaseVersion  = module.cp4i-dependencies.datapower.version
   dpLicense    = module.cp4i-dependencies.datapower.license
   dpLicenseUse = module.cp4i-dependencies.datapower.license_use
}


```
