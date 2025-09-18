/* # Variables globales
variable "environment" {
  description = "Nom de l'environnement (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment doit être dev, staging, ou prod."
  }
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "mon-projet"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 20
    error_message = "Le nom du projet doit faire entre 1 et 20 caractères."
  }
}

variable "aws_region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-1"
}

# Variables de configuration
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "Blocs CIDR autorisés pour SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_monitoring" {
  description = "Activer la surveillance CloudWatch"
  type        = bool
  default     = true
}

# Variables complexes
variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    Owner      = "DevOps Team"
    CostCenter = "IT"
  }
}

variable "database_config" {
  description = "Configuration de la base de données"
  type = object({
    engine         = string
    engine_version = string
    instance_class = string
    storage_gb     = number
  })
  default = {
    engine         = "postgres"
    engine_version = "13.7"
    instance_class = "db.t3.micro"
    storage_gb     = 20
  }
}
 */