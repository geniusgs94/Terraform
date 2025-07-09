# ----------------------------------------------
# Step 1: Install Terraform
#   - Download from: https://developer.hashicorp.com/terraform/downloads
#   - Verify:        terraform --version

# Step 2: Install AWS CLI
#   - Download from: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html
#   - Verify:        aws --version

# Step 3: Create an IAM User in AWS Console
#   - Go to: https://console.aws.amazon.com/iam
#   - Create user (e.g., terraform-s3-access) with "Programmatic access"
#   - Attach policy: AmazonS3FullAccess (or a custom limited-access policy)

# Step 4: Save Access Key ID and Secret Access Key
#   - Copy or download credentials securely when user is created

# Step 5: Configure AWS CLI
#   - Run: aws configure
#   - This sets up:
#       C:\Users\<YourName>\.aws\credentials
#       C:\Users\<YourName>\.aws\config

# Step 6: Write Terraform configuration
# ----------------------------------------------

provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

# Format: resource "<PROVIDER>_<RESOURCE_TYPE>" "<INTERNAL_NAME>"
resource "aws_s3_bucket" "my_bucket" {
  bucket = "gaurav-terraform-demo-bucket-12345"  # Must be globally unique
  # No ACL block needed — by default, the bucket is private
}

# ----------------------------------------------
# Step 7: Deploy the Infrastructure
#   - Open PowerShell in the folder containing this file (e.g., main.tf)
#   - Run these commands:
#       terraform init
#       terraform plan
#       terraform apply
#   - Type "yes" when prompted to confirm
# ----------------------------------------------
