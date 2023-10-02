#!/bin/bash

set -x

export TF_LOG="DEBUG"
export TF_LOG_PATH="./terraform.log"

ENV="prod"
TF_PLAN="${ENV}.tfplan"


# Remove existing Terraform artifacts
[ -d .terraform ] && rm -rf .terraform
rm -f *.tfplan
sleep 2

# Format Terraform code
terraform fmt -recursive

# Initialize Terraform
terraform init

# Validate Terraform configuration
terraform validate

terraform plan -out=${TF_PLAN}


# Uncomment the following lines if needed:
 terraform show -json ${TF_PLAN} | jq > ${TF_PLAN}.json
 checkov -f ${TF_PLAN}.json

if [ $? -eq 0 ]
then
    echo "Your configuration is valid"
else
    echo "Your code needs some work!"
    exit 1
fi

terraform plan -out=${TF_PLAN}

if [ ! -f "${TF_PLAN}" ]
then    
   echo "The plan does not exist. Exiting"
fi
# Uncomment the following lines if needed:
 terraform show -json ${TF_PLAN} | jq > ${TF_PLAN}.json
 checkov .