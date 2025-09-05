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

# --- EC2に付けるIAMロール（SSM接続のため） ---
data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service", identifiers = ["ec2.amazonaws.com"] }
  }
}

resource "aws_iam_role" "runner_role" {
  name               = "${local.name_prefix}-runner-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "runner_profile" {
  name = "${local.name_prefix}-runner-profile"
  role = aws_iam_role.runner_role.name
}
