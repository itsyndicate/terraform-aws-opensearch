terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
