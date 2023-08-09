terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.67"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
