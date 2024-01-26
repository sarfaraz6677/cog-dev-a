
```markdown
```
# Terraform AWS DocumentDB Cluster Setup

## Overview

This Terraform code automates the provisioning of an AWS DocumentDB cluster along with the necessary VPC infrastructure.

## Prerequisites 

1. [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.

2. AWS CLI configured with necessary credentials.


## Project Structure

-  `main.tf`: Main Terraform configuration file defining AWS resources.

-  `variables.tf`: Input variable definitions.

-  `provider.tf`: AWS provider configuration.

-  `outputs.tf`: Output values from the Terraform configuration.

-  `README.md`: documentation for the project.

```bash
```
## Getting Started 

**1. Clone the repository:**
```bash
git clone https://github.com/sarfaraz6677/cog-dev-a.git
cd cog-dev-a
```
**2. Initialize the Terraform project:**
```bash
terraform init
```
**3. Review and customize the `variables.tf` file to match your requirements.**

**4. Execute Terraform plan:**
```
terraform plan -var-file=./custom.tfvars
```

**5. Apply the changes:**
```bash
terraform apply -var-file=./custom.tfvars -auto-approve
```

## Terraform Modules

  
-  **VPC Module**: Creates the VPC, 1 public subnet and 2 private subnets.

-  **DocumentDB Module**: Sets up the DocumentDB cluster, DocumentDB subnet group, DocumentDB parameter group, DocumentDB cluster instance and security group.

-  **Security Group Module**: Configures security groups for DocumentDB.

## Cleaning Up
**To destroy the resources created by Terraform, run:**

```bash
terraform  destroy  -var-file=./custom.tfvars
```