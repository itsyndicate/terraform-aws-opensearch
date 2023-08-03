# ---------------------------------------------------------------------------------------------------------------------
# This is an example of how to create CloudWatch Log groups dynamically using Terragrunt
# ---------------------------------------------------------------------------------------------------------------------
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/itsyndicate/terraform-aws-cloudwatch/modules/log_group//."
}

inputs = {
  cloudwatch_log_groups = {
    opensearch_application_logs = {
        name = "/aws/OpenSearchService/domains/my-opensearch/application-logs"
        skip_destroy = false
        retention_in_days = 120
    },
    opensearch_index_logs = {
        name = "/aws/OpenSearchService/domains/my-opensearch/index-logs"
        skip_destroy = false
        retention_in_days = 120
    },  
    opensearch_search_logs = {
        name = "/aws/OpenSearchService/domains/my-opensearch/search-logs"
        skip_destroy = false
        retention_in_days = 120
    },    
  }
}
