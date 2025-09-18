terraform {
 backend "s3" {
 bucket = "mon-terraform-state-1756763870"        
 key = "infrastructure/terraform.tfstate"
 region = "eu-west-1"
 # Table DynamoDB pour le verrouillage d'état
 dynamodb_table = "terraform-state-lock"
 # Chiffrement de l'état
 encrypt = true
 }
 # Optionnel : utiliser un profil AWS spécifique
 # profile = "mon-profil"
 }
