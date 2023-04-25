# aws-play terraform stuff

Install Terraform on your local machine or on a CI/CD server.

Run `terraform init` to initialize your Terraform project and download any necessary provider plugins.

Run `terraform plan` to see what changes will be made by the script.

If the plan looks good, run `terraform apply`to apply the changes and create the AWS resources.

Note that running this script will create real AWS resources and may result in charges on your AWS account.
Be sure to clean up the resources when you are finished by running `terraform destroy`.

## Installing Terraform on your local machine

Add the HashiCorp GPG key:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

Add the official HashiCorp Linux repository:


```bash
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

Update the package index and install Terraform:

```bash
sudo apt-get update && sudo apt-get install terraform
```

Verify the installation by running:

```bash
terraform --version
```

## Set up AWS

1. Create an AWS IAM user with programmatic access and attach the necessary policies to the user to allow Terraform to manage your resources. At a minimum, the user should have the "AmazonEC2FullAccess" and "AmazonVPCFullAccess" policies attached. You can create a custom policy if you prefer to limit the user's access to specific resources or actions.

2. Once you have created the user, you will need to obtain the user's access key ID and secret access key. You can find these in the AWS Management Console under the IAM section.

3. Set the access key ID and secret access key as environment variables on your local machine. You can use the following commands in your terminal to set these environment variables (replace `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` with your own credentials):

```bash
export AWS_ACCESS_KEY_ID=ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=SECRET_ACCESS_KEY
```

4. Install the AWS CLI on your local machine. You can download and install the AWS CLI from the AWS website.

```bash
sudo apt-get update && sudo apt-get install awscli
```

5. Verify that the installation was successful by running the following command:

```bash
aws --version
```

6. Run the `aws configure` command in your terminal and provide the access key ID, secret access key, and default region when prompted. This will create a configuration file at `~/.aws/config` on your local machine with your AWS credentials.

7. In your Terraform code, add the following provider block to specify the AWS provider and region:

```terraform
provider "aws" {
  region = "eu-central-1"
}
```

## Storing Terraform state securely, remotely

1. Create an S3 bucket to store your state files. You can do this in the AWS Management Console or with the AWS CLI:

```bash
aws s3api create-bucket --bucket play-aws-terraform-state --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
```

2. Enable versioning on the S3 bucket to track changes to your state files over time:

```bash
aws s3api put-bucket-versioning --bucket play-aws-terraform-state --versioning-configuration Status=Enabled
```

3. Create a DynamoDB table to store Terraform's state locking information. This is necessary to prevent concurrent writes to your state file, which can cause corruption or data loss:

```bash
aws dynamodb create-table --table-name play-aws-terraform-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```

4. Update your Terraform configuration to use remote state. This can be done in the `backend.tf` file:

```terraform
terraform {
  backend "s3" {
    bucket         = "play-aws-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "play-aws-terraform-lock"
  }
}
```


## Set up SSH key-pair to access instances

```bash
aws ec2 create-key-pair --key-name PlayAWSKeyPair --query 'KeyMaterial' --output text > ~/.ssh/PlayAWSKeyPair.pem
chmod 400  ~/.ssh/PlayAWSKeyPair.pem
```

## SSH into an EC2 instance

```bash
ssh -i ~/.ssh/PlayAWSKeyPair.pem ec2-user@<INSTANCE_PUBLIC_IP>
```

> Bear in mind, that different AMI instances have differnet users. For Debian it's `admin`, but for Amazon AMI, it's `ec2-user`, etc...

