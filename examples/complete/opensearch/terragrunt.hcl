# ---------------------------------------------------------------------------------------------------------------------
# This is an example of how to create OpenSearch domain using Terragrunt
# ---------------------------------------------------------------------------------------------------------------------
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/itsyndicate/terraform-aws-opensearch//."
}

dependency "opensearch_security_group" {
  config_path = "../opensearch_security_group"
}

dependency "opensearch_log_groups" {
  config_path = "../opensearch_log_groups"
}

dependency "secrets_manager" {
  config_path = "../secrets_manager"
}

inputs = {
  region = "us-east-2"

  engine_version = "OpenSearch_2.5"

  name = "my-opensearch"

  domain_endpoint_options_enforce_https = true
  tls_security_policy                   = "Policy-Min-TLS-1-2-2019-07"

  node_to_node_encryption = {
    enabled = true
  }
  
  encrypt_at_rest = {
    enabled = true
  }

  ebs_options = {
    ebs_enabled = true
    volume_size = 75
    volume_type = "gp3"
    iops        = 3000
    throughput = 125
  }

  vpc_options = {
    subnet_ids         = ["YOUR_VPC_SUBNET_1", "YOUR_VPC_SUBNET_2"] # Use |dependency| block to include this attribute as output values from your VPC Terragrunt module
    security_group_ids = ["${dependency.opensearch_security_group.outputs.security_group_id}"]
  }

  default_policy_for_fine_grained_access_control = true

  advanced_security_options = {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options            = {
      master_user_name     = "${dependency.secrets_manager.outputs.retrieved_secrets.MY_OPENSEARCH_MASTER_USER}"
      master_user_password = "${dependency.secrets_manager.outputs.retrieved_secrets.MY_OPENSEARCH_MASTER_USER_PASSWORD}"
    }
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "override_main_response_version"         = "false"
  }

  cluster_config = {
    instance_count         = 2
    instance_type          = "m6g.large.search"
    zone_awareness_enabled = true

    zone_awareness_config  = {
      availability_zone_count = 2
    }

    cold_storage_options = {
      enabled = false
    }
  }

  auto_tune_options = {
    desired_state       = "ENABLED"
    rollback_on_disable = "NO_ROLLBACK"
  }

  off_peak_window_options = {
    enabled         = true
    off_peak_window = {
      window_start_time = {
        hours   = "03"
        minutes = "01"
      }
    }
  }

  log_publishing_options = {
    application_logs_enabled = true
    index_logs_enabled       = true
    search_logs_enabled      = true

    application_logs_cw_log_group_arn = "${dependency.opensearch_log_groups.outputs.cloudwatch_log_group_arns[0]}"
    index_logs_cw_log_group_arn       = "${dependency.opensearch_log_groups.outputs.cloudwatch_log_group_arns[1]}"
    search_logs_cw_log_group_arn      = "${dependency.opensearch_log_groups.outputs.cloudwatch_log_group_arns[2]}"
  }

  create_a_record         = false
  create_linked_role      = false
  custom_endpoint_enabled = false
  cognito_enabled         = false
  implicit_create_cognito = false
}
