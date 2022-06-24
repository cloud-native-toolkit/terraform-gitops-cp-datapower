
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
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

variable "entitlement_key" {
  type        = string
  description = "The entitlement key required to access Cloud Pak images"
  sensitive   = true
}