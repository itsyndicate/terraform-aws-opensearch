locals {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_linked_role ? 1 : 0
  aws_service_name = var.aws_service_name_for_linked_role
}

resource "time_sleep" "role_dependency" {
  count           = var.cognito_enabled ? 1 : 0
  create_duration = "20s"

  triggers = {
    role_arn       = try(aws_iam_role.cognito_es_role[0].arn, null),
    linked_role_id = try(aws_iam_service_linked_role.es[0].id, "11111")
  }
}

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = var.name
  engine_version = var.engine_version

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.internal_user_database_enabled
    anonymous_auth_enabled         = var.anonymous_auth_enabled
    master_user_options {
      master_user_arn      = var.master_user_arn == "" ? try(aws_iam_role.authenticated[0].arn, null) : var.master_user_arn
      master_user_name     = var.internal_user_database_enabled ? var.master_user_name : ""
      master_user_password = var.internal_user_database_enabled ? var.master_password : ""
    }
  }

  advanced_options = var.advanced_options

  dynamic "vpc_options" {
    for_each = var.inside_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.sg_ids
    }
  }

  dynamic "cognito_options" {
    for_each = var.cognito_enabled ? [1] : []
    content {
      enabled          = var.cognito_enabled
      user_pool_id     = var.implicit_create_cognito == true ? aws_cognito_user_pool.user_pool[0].id : var.user_pool_id
      identity_pool_id = var.identity_pool_id == "" && var.implicit_create_cognito == true ? aws_cognito_identity_pool.identity_pool[0].id : var.identity_pool_id
      role_arn         = var.implicit_create_cognito == true ? time_sleep.role_dependency.triggers["role_arn"] : var.cognito_role_arn
    }
  }

  cluster_config {
    instance_type            = var.instance_type
    dedicated_master_enabled = try(var.cluster_config["dedicated_master_enabled"], false)
    dedicated_master_count   = try(var.cluster_config["dedicated_master_count"], 0)
    dedicated_master_type    = try(var.cluster_config["dedicated_master_type"], "t2.small.elasticsearch")
    instance_count           = try(var.cluster_config["instance_count"], 1)
    warm_enabled             = try(var.cluster_config["warm_enabled"], false)
    warm_count               = try(var.cluster_config["warm_enabled"], false) ? try(var.cluster_config["warm_count"], null) : null
    warm_type                = try(var.cluster_config["warm_type"], false) ? try(var.cluster_config["warm_type"], null) : null
    zone_awareness_enabled   = try(var.cluster_config["zone_awareness_enabled"], false)
    dynamic "zone_awareness_config" {
      for_each = try(var.cluster_config["availability_zone_count"], 1) > 1 && try(var.cluster_config["zone_awareness_enabled"], false) ? [1] : []
      content {
        availability_zone_count = try(var.cluster_config["availability_zone_count"], 1)
      }
    }
    cold_storage_options {
      enabled = var.cold_storage_enabled
    }
  }

  encrypt_at_rest {
    enabled    = try(var.encrypt_at_rest["enabled"], false)
    kms_key_id = try(var.encrypt_at_rest["kms_key_id"], "")
  }

  dynamic "log_publishing_options" {
    for_each = try(var.log_publishing_options["audit_logs_enabled"], false) ? [1] : []
    content {
      enabled                  = try(var.log_publishing_options["audit_logs_enabled"], false)
      log_type                 = "AUDIT_LOGS"
      cloudwatch_log_group_arn = try(var.log_publishing_options["audit_logs_cw_log_group_arn"], null)
    }
  }

  dynamic "log_publishing_options" {
    for_each = try(var.log_publishing_options["application_logs_enabled"], false) ? [1] : []
    content {
      enabled                  = try(var.log_publishing_options["application_logs_enabled"], false)
      log_type                 = "ES_APPLICATION_LOGS"
      cloudwatch_log_group_arn = try(var.log_publishing_options["application_logs_cw_log_group_arn"], null)
    }
  }

  dynamic "log_publishing_options" {
    for_each = try(var.log_publishing_options["index_logs_enabled"], false) ? [1] : []
    content {
      enabled                  = try(var.log_publishing_options["index_logs_enabled"], false)
      log_type                 = "INDEX_SLOW_LOGS"
      cloudwatch_log_group_arn = try(var.log_publishing_options["index_logs_cw_log_group_arn"], null)
    }
  }

  dynamic "log_publishing_options" {
    for_each = try(var.log_publishing_options["search_logs_enabled"], false) ? [1] : []
    content {
      enabled                  = try(var.log_publishing_options["search_logs_enabled"], false)
      log_type                 = "SEARCH_SLOW_LOGS"
      cloudwatch_log_group_arn = try(var.log_publishing_options["search_logs_cw_log_group_arn"], null)
    }
  }

  dynamic "ebs_options" {
    for_each = [var.ebs_options]
    iterator = i

    content {
      ebs_enabled = i.value["ebs_enabled"]
      volume_type = i.value["ebs_enabled"] == true ? i.value["volume_type"] : null
      volume_size = i.value["ebs_enabled"] == true ? i.value["volume_size"] : null
      iops        = i.value["volume_type"] == "gp3" ? i.value["iops"] : null
      throughput  = i.value["volume_type"] == "gp3" ? i.value["throughput"] : null
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  access_policies = var.access_policy == null && var.default_policy_for_fine_grained_access_control ? (<<CONFIG
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "es:*",
                "Principal": {
                  "AWS": "*"
                  },
                "Effect": "Allow",
                "Resource": "arn:aws:es:${local.region}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"
            }
        ]
    }
    CONFIG 
  ) : var.access_policy

  domain_endpoint_options {
    enforce_https                   = var.domain_endpoint_options_enforce_https
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
    tls_security_policy             = var.tls_security_policy
  }

  dynamic "auto_tune_options" {
    for_each = [var.auto_tune_options]
    iterator = i

    content {
      desired_state       = i.value["desired_state"]
      rollback_on_disable = i.value["rollback_on_disable"]

      dynamic "maintenance_schedule" {
        for_each = i.value["rollback_on_disable"] == "DEFAULT_ROLLBACK" ? [lookup(i.value, "maintenance_schedule", "")] : []
        iterator = m

        content {
          start_at                       = m.value["start_at"]
          cron_expression_for_recurrence = m.value["cron_expression_for_recurrence"]

          dynamic "duration" {
            for_each = length(lookup(i.value, "duration", "")) == 0 ? [] : [lookup(i.value, "duration", "")]
            iterator = p

            content {
              value = p.value["value"]
              unit  = lookup(p.value, "unit", "HOURS")
            }
          }
        }
      }
    }
  }

  dynamic "off_peak_window_options" {
    for_each = [var.off_peak_window_options]
    iterator = i

    content {
      enabled = i.value["enabled"]

      dynamic "off_peak_window" {
        for_each = length(lookup(i.value, "off_peak_window", "")) == 0 ? [] : [lookup(i.value, "off_peak_window", "")]
        iterator = p

        content {
          dynamic "window_start_time" {
            for_each = length(lookup(p.value, "window_start_time", "")) == 0 ? [] : [lookup(p.value, "window_start_time", "")]
            iterator = m

            content {
              hours   = m.value["hours"]
              minutes = m.value["minutes"]
            }
          }
        }
      }
    }
  }

  tags       = var.tags
  depends_on = [aws_iam_service_linked_role.es[0], time_sleep.role_dependency]
}


resource "aws_route53_record" "domain_record" {
  count      = var.custom_endpoint_enabled && var.create_a_record ? 1 : 0
  zone_id    = var.zone_id
  name       = var.custom_endpoint
  type       = "CNAME"
  ttl        = 60
  records    = [aws_opensearch_domain.opensearch.endpoint]
  depends_on = [aws_opensearch_domain.opensearch]
}
