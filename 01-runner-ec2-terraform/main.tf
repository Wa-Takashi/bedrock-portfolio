terraform {
    required_version = ">=1.6.0"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws" {
    region = "ap-northeast-1" # 東京リージョン
}

locals {
  name_prefix = "learn-bedrock"
  tags = {
    Project = local.name_prefix
  }
}