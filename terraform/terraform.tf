# terraform.tf - Configuration globale
 terraform {
  # Version minimale requise
  required_version = ">= 1.0"
  
 }
 # Configuration des providers par défaut
 /* provider "aws" {
  region = var.aws_region
  
  # Tags par défaut
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Project     = var.project_name
    }
  }
 }
 */