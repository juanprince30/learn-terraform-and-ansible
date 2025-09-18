#!/bin/bash

BUCKET_NAME="mon-terraform-state-$(date +%s)"
REGION="eu-west-1"

echo "🚀 Début de la configuration du backend Terraform..."
echo "📦 Bucket: ${BUCKET_NAME}, Région: ${REGION}"
echo

# Créer le bucket S3
if aws s3 mb s3://${BUCKET_NAME} --region ${REGION}; then
  echo "✅ Bucket S3 créé avec succès."
else
  echo "❌ Erreur lors de la création du bucket S3."
  exit 1
fi

# Activer le versioning
if aws s3api put-bucket-versioning \
  --bucket ${BUCKET_NAME} \
  --versioning-configuration Status=Enabled; then
  echo "✅ Versioning activé."
else
  echo "❌ Erreur lors de l’activation du versioning."
  exit 1
fi

# Activer le chiffrement
if aws s3api put-bucket-encryption \
  --bucket ${BUCKET_NAME} \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'; then
  echo "✅ Chiffrement AES256 activé."
else
  echo "❌ Erreur lors de l’activation du chiffrement."
  exit 1
fi

# Créer la table DynamoDB pour le verrouillage
if aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ${REGION}; then
  echo "✅ Table DynamoDB 'terraform-state-lock' créée avec succès."
else
  echo "❌ Erreur lors de la création de la table DynamoDB."
  exit 1
fi

echo
echo "🎉 Backend configuré avec succès !"
echo "   S3 Bucket: ${BUCKET_NAME}"
echo "   DynamoDB Table: terraform-state-lock"
