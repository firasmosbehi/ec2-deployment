#!/bin/bash
set -e   # Exit immediately if a command fails
set -u   # Treat unset variables as an error

# === Force UTF-8 for sed on macOS ===
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo "=== Step 1: Terraform Init & Apply ==="
cd terraform/envs/dev

terraform init
terraform apply -auto-approve

# Get all Terraform outputs in JSON
TF_OUTPUT_JSON=$(terraform output -json)

cd ../../..

# === Step 2: Replace placeholders in all project files ===
echo "=== Replacing Terraform output placeholders in project files ==="

# Loop through all outputs
echo "$TF_OUTPUT_JSON" | jq -r 'to_entries[] | "\(.key)=\(.value.value)"' | while IFS='=' read -r key value; do
    echo "Replacing placeholder \${$key} with $value"

    # Find all text files (skip binary files)
    find ansible -type f ! -name "*.png" ! -name "*.jpg" ! -name "*.zip" ! -path "./terraform/*" | while IFS= read -r file; do
        # macOS-safe sed replacement with temporary backup
        sed -i.bak "s|\${$key}|$value|g" "$file" || echo "Skipped $file due to encoding issues"
        rm -f "${file}.bak"
    done
done

echo "$TF_OUTPUT_JSON" | jq -r 'to_entries[] | "\(.key)=\(.value.value)"' | while IFS='=' read -r key value; do
    echo "Replacing placeholder \${$key} with $value"

    # Find all text files (skip binary files)
    find application -type f ! -name "*.png" ! -name "*.jpg" ! -name "*.zip" ! -path "./terraform/*" | while IFS= read -r file; do
        # macOS-safe sed replacement with temporary backup
        sed -i.bak "s|\${$key}|$value|g" "$file" || echo "Skipped $file due to encoding issues"
        rm -f "${file}.bak"
    done
done

echo "=== Step 4: Run Ansible Playbook ==="
ansible-playbook -i ansible/inventory/dev.ini ansible/playbooks/deploy.yml

echo "=== Deployment Complete ✅ ==="
