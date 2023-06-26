variable "region" {
  description = "AWS region."
  type        = string
}

variable "engine_version" {
  description = "Engine version of elasticsearch."
  type        = string
  default     = "OpenSearch_1.3"
}

variable "name" {
  description = "Name of OpenSerach domain and suffix of all other resources."
  type        = string
}


variable "master_user_name" {
  description = "Master username for accessing OpenSerach."
  type        = string
  default     = "admin"
}


variable "master_password" {
  description = "Master password for accessing OpenSearch. If not specified password will be randomly generated. Password will be stored in AWS `System Manager` -> `Parameter Store` "
  type        = string
  default     = ""
}

variable "master_user_arn" {
  description = "Master user ARN for accessing OpenSearch. If this is set, `advanced_security_options_enabled` must be set to true and  `internal_user_database_enabled` should be set to false."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type."
  type        = string
  default     = "t3.small.search"
}

variable "domain_endpoint_options_enforce_https" {
  description = "Enforce https."
  type        = bool
  default     = true
}


variable "custom_endpoint_enabled" {
  description = "If custom endpoint is enabled."
  type        = bool
  default     = false
}

variable "custom_endpoint" {
  description = "Custom endpoint https."
  type        = string
  default     = ""
}

variable "custom_endpoint_certificate_arn" {
  description = "Custom endpoint certificate."
  type        = string
  default     = null
}

variable "access_policy" {
  description = "Access policy to OpenSearch. If `default_policy_for_fine_grained_access_control` is enabled, this policy would be overwritten."
  type        = string
  default     = null
}

variable "tls_security_policy" {
  description = "TLS security policy."
  type        = string
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "cognito_enabled" {
  description = "Cognito authentification enabled for OpenSearch."
  type        = bool
  default     = false
}

variable "zone_id" {
  type        = string
  description = "Route 53 Zone id."
  default     = ""
}

variable "advanced_security_options_enabled" {
  type        = bool
  description = "If advanced security options is enabled."
  default     = false
}


variable "identity_pool_id" {
  type        = string
  description = "Cognito identity pool id."
  default     = ""
}

variable "user_pool_id" {
  type        = string
  description = "Cognito user pool id."
  default     = ""
}

variable "cognito_role_arn" {
  type        = string
  description = "Cognito role ARN. We need to enable `advanced_security_options_enabled`."
  default     = ""
}


variable "implicit_create_cognito" {
  type        = bool
  description = "Cognito will be created inside module. If this is not enables and we want cognito authentication, we need to create cognito resources outside of module."
  default     = true
}

variable "internal_user_database_enabled" {
  type        = bool
  description = "Internal user database enabled. This should be enabled if we want authentication with master username and master password."
  default     = false
}

variable "anonymous_auth_enabled" {
  type        = bool
  description = "Whether Anonymous auth is enabled. Enables fine-grained access control on an existing domain"
  default     = true
}

variable "create_a_record" {
  type        = bool
  description = "Create A record for custom domain."
  default     = true
}

variable "aws_service_name_for_linked_role" {
  type        = string
  description = "AWS service name for linked role."
  default     = "opensearchservice.amazonaws.com"
}


variable "default_policy_for_fine_grained_access_control" {
  type        = bool
  description = "Default policy for fine grained access control would be created."
  default     = false
}

variable "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options."
  type        = map(string)
  default     = {}
}

variable "cluster_config" {
  description = "Auto tune options from documentation."
  type        = any
  default     = {}
}

variable "log_publishing_options" {
  description = "Encrypt at rest."
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags."
  type        = map(any)
  default     = {}
}

variable "create_linked_role" {
  type        = bool
  default     = true
  description = "Should linked role be created"
}

variable "auto_tune_options" {
  type        = any
  description = "Configuration block for the Auto-Tune options of the domain"
  default     = null
}

variable "off_peak_window_options" {
  type        = any
  description = "Configuration to add Off Peak update options"
  default     = null
}

variable "cold_storage_enabled" {
  type        = bool
  description = "Whether to enable cold storage"
  default     = false
}

variable "ebs_options" {
  type        = any
  description = "Configuration block for EBS related options, may be required based on chosen instance size"
  default     = null
}

variable "node_to_node_encryption" {
  type        = any
  description = "Configuration block for node-to-node encryption options"
  default     = null
}

variable "vpc_options" {
  type        = any
  description = "Configuration block for VPC related options. Adding or removing this configuration forces a new resource"
  default     = null
}

variable "encrypt_at_rest" {
  type        = any
  description = "Configuration block for encrypt at rest options. Only available for certain instance types"
  default     = null
}
