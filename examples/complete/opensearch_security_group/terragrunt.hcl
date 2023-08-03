# ---------------------------------------------------------------------------------------------------------------------
# This is an example of how to create Security group for OpenSearch domain using Terragrunt
# ---------------------------------------------------------------------------------------------------------------------

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//.?version=5.1.0"
}

inputs = {

  vpc_id = "YOUR_VPC_ID" # Use |dependency| block to include this attribute as output value from your VPC Terragrunt module

  name            = "my-opensearch-sg"
  use_name_prefix = false
  description     = "my-opensearch-sg"

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      description = "Allow access from the test VPC"
      cidr_blocks = "YOUR_VPC_CIDR_BLOCK" # Use |dependency| block to include this attribute as output value from your VPC Terragrunt module
    },
    {
      rule        = "https-443-tcp"
      description = "Allow access from the test VPC"
      cidr_blocks = "YOUR_VPC_CIDR_BLOCK" # Use |dependency| block to include this attribute as output value from your VPC Terragrunt module
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    },
  ]

}
