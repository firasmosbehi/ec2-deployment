#!/bin/bash
set -e   # Exit immediately if a command fails
set -u   # Treat unset variables as an error

echo "=== Step 1: Terraform Init & Apply ==="
cd terraform/envs/dev

terraform init
terraform apply -auto-approve

# Get all outputs in "json" format
TF_OUTPUT_JSON=$(terraform output -json)

cd ../../..

# Loop through each Terraform output
echo "$TF_OUTPUT_JSON" | jq -r 'to_entries[] | "\(.key)=\(.value.value)"' | while IFS='=' read -r key value; do
    echo "Replacing placeholder \${$key} with $value"

    # Use 'sed' to replace all occurrences in all files (recursively)
    find "$PROJECT_DIR" -type f -exec sed -i "s|\${$key}|$value|g" {} +
done

echo "=== Step 3: Run Ansible Playbook ==="

ansible-playbook -i $INVENTORY_FILE ansible/playbooks/deploy.yml

echo "=== Deployment Complete ✅ ==="
