#!/bin/bash
set -e 

BUCKET_NAME="mon-terraform-state-$(date +%s)"
REGION="eu-west-1"

# Créer le bucket S3
aws s3 mb s3://${BUCKET_NAME} --region ${REGION}

# Activer le versioning
aws s3api put-bucket-versioning \
  --bucket ${BUCKET_NAME} \
  --versioning-configuration Status=Enabled

# Activer le chiffrement
aws s3api put-bucket-encryption \
  --bucket ${BUCKET_NAME} \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Créer la table DynamoDB pour le verrouillage
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region ${REGION}

echo "✅ Backend configuré :"
echo "   Bucket: ${BUCKET_NAME}"
echo "   Table DynamoDB: terraform-state-lock"
