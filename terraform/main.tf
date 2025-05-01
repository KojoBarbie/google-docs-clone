terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "database" {
  source = "./modules/database"

  document_table_name = "docs_documents"
  session_table_name  = "docs_sessions"
  history_table_name  = "docs_history"
  tags = {
    Project = "GoogleDocsClone"
    Environment = "dev"
  }
}

# module "api" {
#   source = "./modules/api"
# }
# module "cache" {
#   source = "./modules/cache"
# }
# module "network" {
#   source = "./modules/network"
# } 