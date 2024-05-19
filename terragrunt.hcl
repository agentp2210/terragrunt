# stage/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tfstate-7d51119d-138f-4098-b94b-9a8247ca8881"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "TFBackendDynamoDBTable"
  }
}