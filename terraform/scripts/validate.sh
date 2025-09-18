#!/bin/bash
 set -e
 echo "=== Validation de la configuration Terraform ==="
 # Format du code
 echo "Formatage du code..."
 terraform fmt -recursive
 # Validation de la syntaxe
 echo "Validation de la syntaxe..."
 terraform validate
 # Vérification de sécurité avec tfsec (si installé)
 if command -v tfsec &> /dev/null; then
    echo "Analyse de sécurité..."
    tfsec .
 else
    echo "tfsec non installé, analyse de sécurité ignorée"
 fi
 # Vérification avec checkov (si installé)
 if command -v checkov &> /dev/null; then
    echo "Analyse avec Checkov..."
    checkov -d . --framework terraform
 else
    echo "checkov non installé, analyse ignorée"
 fi
 echo "Validation terminée!"
