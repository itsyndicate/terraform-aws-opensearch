# ---------------------------------------------------------------------------------------------------------------------
# This is an example of how to parse Secrets manager secrets dynamically using Terragrunt
# ---------------------------------------------------------------------------------------------------------------------
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/itsyndicate/terraform-aws-secrets-manager//."
}

inputs = {
  secret_name = "my-secret"
  secret_keys = [
    "MY_OPENSEARCH_MASTER_USER",
    "MY_OPENSEARCH_MASTER_USER_PASSWORD"
    ]
}