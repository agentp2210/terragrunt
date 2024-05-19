#!/bin/bash
cd "$(dirname "$0")"

# Create a bucket for tfstate
if [ -z $(aws s3 ls --output text | awk '{print $3}' | grep tfstate-) ]; then
    aws s3 mb s3://tfstate-$(uuidgen | tr A-Z a-z)
fi
# Replace the bucket name in terragrunt.hcl
old_bucket=$(grep tfstate- "../terragrunt.hcl" | tr -d '"' | awk '{print $3}')
new_bucket=$(aws s3 ls --output text | awk '{print $3}' | grep tfstate-)
sed -i -e "s/$old_bucket/$new_bucket/g" "../terragrunt.hcl"

# Create Dynamodb table for locking
table=$(aws dynamodb list-tables --query "TableNames" --output text)
if [ -z $table ]; then
    aws dynamodb create-table \
        --table-name TFBackendDynamoDBTable \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --tags Key=Project,Value=Terraform >/dev/null
fi

#Remove old TF Backend if exist
echo "Removing existing tfstate"

environments=["dev", "prod"]

for env in $environments; do
    if test -d "../$env/.terraform"; then
        rm -rf "../$env/.terraform"
    fi

    if [ -f "../$env/.terraform.lock.hcl" ]; then
        rm "../$env/.terraform.lock.hcl"
    fi
done

