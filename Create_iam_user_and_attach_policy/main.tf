provider "aws" {
  region = "us-east-1"
}

# ✅ 1️⃣ Specify the existing bucket name
#so you don’t hardcode "my-existing-bucket" multiple times
locals {
  bucket_name = "my-existing-bucket"
}


# Make sure that if you are creating user using terraform your terraform has the permissions to create user else it gives error
# ✅ 2️⃣ Create the IAM User(This IAM User is for API/CLI access, not for AWS Console sign-in)
#By default, this user has no permissions until you attach a policy
resource "aws_iam_user" "s3_user" {
  name = "s3-user"
}

# ✅ 3️⃣ Create an inline IAM Policy scoped to the existing bucket
resource "aws_iam_policy" "s3_user_policy" {
  name        = "s3-user-policy"
  description = "Allow read and write access to a specific existing S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}

# ✅ 4️⃣ Attach the policy to the user
#Without this, the user has no permissions — policies must be attached to work!
resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_user_policy.arn
}

# ✅ 5️⃣ Create access keys(aws_access_key_id,aws_secret_access_key) for programmatic access
#These are programmatic credentials to use with AWS CLI, SDKs, or tools like Boto3.
#You use them in .aws/credentials or as environment variables.
resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

# ✅ 6️⃣ Output the keys (Be cautious in production!)
#output block lets you print the generated values to your console after terraform apply
#sensitive = true → hides the secret from casual display in CLI output or state files
# (though the state file still stores it in plaintext).
#Copy these immediately after terraform apply — you can’t retrieve the secret again later.

output "aws_access_key_id" {
  value = aws_iam_access_key.s3_user_key.id
}
output "aws_secret_access_key" {
  value     = aws_iam_access_key.s3_user_key.secret
  sensitive = true
}


#terraform plan -out=myplan.tfplan
#terraform apply myplan.tfplan
