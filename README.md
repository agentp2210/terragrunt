# Terragrunt basic

## Generate backend, provider automatically

The terragrunt in the parent folder include the function path_relative_to_include() so it will automatically generate the path

The terragrunt in subfolders will generate the backend thanks to the function find_in_parent_folders()

1. Create an S3 bucket and a DynamoDB table
``` shell
aws configure
./scritps/create-backend.sh
```

2. Check the terragrunt.hcl in the parent folder and subfolders to see how it links
``` shell
cat terragrunt.hcl
cat dev/terragrunt.hcl
cat prod/terragrunt.hcl
``` 

3. Go to the subfolders (dev or prod) and run terrgrunt apply
``` shell
cd ./dev
terragrunt apply --auto-approve
```

4. Check the backend.tf and provider.tf generated in the subfolders
``` shell
cat backend.tf
cat provider.tf
```

5. Go to the AWS portal and check the backend path created in the s3 bucket


## Use input block

Instead of using .tfvars file and specify it when running Terraform command with -var-file, we can specify the variables in terragrunt.hcl

1. Check the input block in terragrunt.hcl