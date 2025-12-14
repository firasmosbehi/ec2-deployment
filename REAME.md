# EC2 Deployment

Automated deployment toolkit for provisioning and deploying applications to an **AWS EC2** instance using Terraform, Ansible, and GitHub Actions.

This repository helps you:

- 👷 Provision AWS infrastructure with **Terraform**  
- ⚙️ Configure servers & deploy application with **Ansible**  
- 🚀 Automate CI/CD using **GitHub Actions**  
- 🛠️ Deploy via `deploy.sh` script

---

## 🚀 Features

✔ Terraform infrastructure for AWS EC2  
✔ SSH key management  
✔ Ansible playbooks to bootstrap & deploy  
✔ GitHub workflows for CI/CD  
✔ Simple deployment with `deploy.sh`

---

## 📁 Repository Structure

```txt
ec2-deployment
├── .github/workflows/ # GitHub Actions workflows
├── ansible/ # Ansible playbooks and roles
├── application/ # App code (if included)
├── ressources/ssh-keys/ # SSH keys templates or examples
├── terraform/ # Terraform IaC definitions
├── deploy.sh # Simple deploy script
├── .gitignore
├── LICENSE
└── README.md
```


---

## 🧱 Prerequisites

Before using this project you’ll need:

- 🐧 **Git** installed  
- 🧰 **Terraform** installed (v1.x+)  
- ⚡ **Ansible** installed  
- 🔑 AWS credentials with permissions to create EC2, VPC, IAM, etc.  
- SSH key pair for EC2 access

---

## ⚙️ Setup

### 1. Clone the Repository

```bash
git clone https://github.com/firasmosbehi/ec2-deployment.git
cd ec2-deployment
```

### 💡 Infrastructure — Terraform

Terraform is used to create the AWS environment.

```bash
cd terraform/envs/dev
terraform init
terraform plan
terraform apply
```

Terraform will:

- Create an EC2 instance

- Create VPC, subnets, security groups

- Upload SSH keys (if configured)

Make sure your AWS credentials are configured (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`).

### 📦 Configuration — Ansible

Ansible bootstraps the EC2 instance:

```bash
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
```

Ansible is used to :

- Install docker and docker compose.

- Copy compose files and run them in the target machine

- Apply Nginx configuration

---

## 🚀 Manual Deployment Script

There’s a `deploy.sh` script to copy application files and restart services on the EC2 instance.

```bash
chmod +x deploy.sh
./deploy.sh
```

## 🔁 CI/CD — GitHub Actions

Automate deployment on pushes to `main` (or your branch):

1. checkout the repo

2. Provision infrastructure

3. Apply ansible book

| Secret Name    | Description                       |
| -------------- | --------------------------------- |
| `EC2_HOST`     | EC2 public IP or DNS              |
| `EC2_SSH_KEY`  | Private SSH key                   |
| `EC2_USERNAME` | SSH user (e.g., ubuntu, ec2-user) |

---

## 📜 License

This project is licensed under the MIT License — see the LICENSE file for more details.