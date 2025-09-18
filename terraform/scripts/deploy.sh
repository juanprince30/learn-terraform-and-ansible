#!/bin/bash
set -e

# --------------------------
# Configuration
# --------------------------
ENVIRONMENT=${1:-dev}
ACTION=${2:-plan}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# --------------------------
# Couleurs pour les messages
# --------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --------------------------
# Fonctions utilitaires
# --------------------------
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# --------------------------
# Validation des prérequis
# --------------------------
check_prerequisites() {
    log_info "Vérification des prérequis..."

    if ! command -v terraform &> /dev/null; then
        log_error "Terraform n'est pas installé"
        exit 1
    fi

    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI n'est pas installé"
        exit 1
    fi

    if [[ ! -f "${PROJECT_DIR}/${ENVIRONMENT}.tfvars" ]]; then
        log_error "Fichier de variables ${ENVIRONMENT}.tfvars introuvable"
        exit 1
    fi
}

# --------------------------
# Initialisation Terraform
# --------------------------
terraform_init() {
    log_info "Initialisation de Terraform..."
    cd "$PROJECT_DIR" || exit 1
    terraform init -upgrade
}

# --------------------------
# Validation de la configuration
# --------------------------
terraform_validate() {
    log_info "Validation de la configuration..."
    terraform validate
    terraform fmt -check -recursive
}

# --------------------------
# Plan Terraform
# --------------------------
terraform_plan() {
    log_info "Génération du plan Terraform..."
    terraform plan \
        -var-file="environments/${ENVIRONMENT}.tfvars" \
        -out="terraform.tfplan"
}

# --------------------------
# Application des changements
# --------------------------
terraform_apply() {
    log_info "Application des changements..."
    terraform apply "terraform.tfplan"
}

# --------------------------
# Destruction de l'infrastructure
# --------------------------
terraform_destroy() {
    log_warn "Destruction de l'infrastructure ${ENVIRONMENT}..."
    read -rp "Êtes-vous sûr? (yes/no): " REPLY
    if [[ "$REPLY" == "yes" ]]; then
        terraform destroy \
            -var-file="environments/${ENVIRONMENT}.tfvars" \
            -auto-approve
    else
        log_info "Destruction annulée"
    fi
}

# --------------------------
# Script principal
# --------------------------
main() {
    log_info "Déploiement Terraform - Environnement: ${ENVIRONMENT}, Action: ${ACTION}"

    check_prerequisites
    terraform_init
    terraform_validate

    case "$ACTION" in
        "plan")
            terraform_plan
            ;;
        "apply")
            terraform_plan
            terraform_apply
            ;;
        "destroy")
            terraform_destroy
            ;;
        *)
            log_error "Action non reconnue: $ACTION"
            echo "Actions disponibles: plan, apply, destroy"
            exit 1
            ;;
    esac

    log_info "Déploiement terminé avec succès!"
}

# --------------------------
# Exécution du script principal
# --------------------------
main "$@"
