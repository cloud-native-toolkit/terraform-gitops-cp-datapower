
variable cluster_username { 
  type        = string
  description = "The username for AWS access"
}

variable "cluster_password" {
  type        = string
  description = "The password for AWS access"
}

variable "server_url" {
  type        = string
}

variable "bootstrap_prefix" {
  type = string
  default = ""
}

variable "namespace" {
  type        = string
  description = "Namespace for tools"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_exists" {
  type        = string
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "true"
}

variable "git_token" {
  type        = string
  description = "Git token"
}

variable "git_host" {
  type        = string
  default     = "github.com"
}

variable "git_type" {
  default = "github"
}

variable "git_org" {
  default = "cloud-native-toolkit-test"
}

variable "git_repo" {
  default = "git-module-test"
}

variable "gitops_namespace" {
  default = "openshift-gitops"
}

variable "git_username" {
}

variable "kubeseal_namespace" {
  default = "sealed-secrets"
}

variable "cp_entitlement_key" {
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "channel" {
  type        = string
  description = "Channel number for subscription"
  default     = "v1.5"
}

variable "catalog" {
  type        = string
  description = "The catalog source that should be used to deploy the operator"
  default     = "ibm-operator-catalog"
}

variable "catalog_namespace" {
  type        = string
  description = "The namespace where the catalog has been deployed"
  default     = "openshift-marketplace"
}

variable "dpInstanceName" {
  type        = string
  description = "The name of the DataPower instance"
  default     = "dp"
}

variable "dpWebuiConfigMap" {
  type        = string
  description = "The name of the Config map to enable WebUI"
  default     = "dp-webui-config"
}

variable "dpLicense" {
  type        = string
  description = "License string to use"
  default     = "L-RJON-CCCP46"
}

variable "dpLicenseUse" {
  type        = string
  description = "License use - Prod, Non Production etc"
  default     = "nonproduction"
}

variable "memoryLimits" {
  type        = string
  description = "Memory limit for DP containers"
  default     = "4Gi"
}

variable "memoryRequests" {
  type        = string
  description = "Memory requests for DP containers"
  default     = "4Gi"
}

variable "cpuRequests" {
  type        = string
  description = "CPU requests for DP containers"
  default     = "1"
}

variable "passwordSecret" {
  type        = string
  description = "Secret which stores the Admin password. This secret is automatically created."
  default     = "dp-credentials"
}

variable "dpReleaseVersion" {
  type        = string
  description = "Release version for DataPower"
  default     = "10.0-cd"
}

variable "replicas" {
  type        = number
  description = "Number of replicas for DataPower. Choose 1, 3, or 5"
  default     = 1
}

variable "subscription_namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
  default     = "openshift-operators"
}