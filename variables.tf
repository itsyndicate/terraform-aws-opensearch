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

variable "advanced_security_options" {
  type        = any
  description = "Configuration block for fine-grained access control"
  default     = null
}

variable "cluster_config" {
  type        = any
  description = "Configuration block for the cluster of the domain"
  default     = null
}
