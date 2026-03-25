# REMOTE S3 BACKEND CONFIGURATION
# To enable S3 backend, create the resources and uncomment below:
#
# terraform {
#   backend "s3" {
#     bucket         = "cloudelligent-terraform-state"
#     key            = "task3/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
#
# To create S3 backend resources, run:
# aws s3api create-bucket --bucket cloudelligent-terraform-state --region us-east-1
# aws s3api put-bucket-versioning --bucket cloudelligent-terraform-state --versioning-configuration Status=Enabled
# aws dynamodb create-table --table-name terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region us-east-1
