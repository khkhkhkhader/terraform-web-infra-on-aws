
terraform {
  backend "s3" {
    bucket = "my-be-bucket-for-backend"
    region = "us-east-1"
    key    = "my-backend/fstate.tfstate"

   use_lockfile = true
   dynamodb_table = "backend-table"
  
  }
}
