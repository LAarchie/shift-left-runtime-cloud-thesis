#!/bin/bash
# Load AWS Keys from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi


# 1. IaC Scanning - Checkov, tfsec, KICS
echo "IaC Scans: "
docker run --rm -v $(pwd):/tf bridgecrew/checkov:latest -d /tf/iac/s3 --output json > results/iac/checkov_s3.json
docker run --rm -v $(pwd):/src aquasec/tfsec:latest /src/iac/s3 --format json > results/iac/tfsec_s3.json
docker run --rm -v $(pwd):/path checkmarx/kics:latest scan -p /path/iac/s3 -o /path/results/iac/kics_s3.json


# 2. Infrastructure
cd iac/s3
terraform init && terraform apply -auto-approve
cd ../..



# 3. Prowler (Runtime scanning) - using AWS Keys from file
docker run --rm -ti \
    --env-file .env \
    -v $(pwd)/results/runtime:/shared \
    prowlercloud/prowler:latest \
    aws --services s3 --output-formats json-asff --output-directory /shared
    


# 4. Cleaning
cd iac/s3
terraform destroy -auto-approve
cd ../..