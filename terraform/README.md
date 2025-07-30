# Deploy Vulnerable Windows Server

A simple deployment of a vulnerable Windows 2016 Server.

---

## HOWTO

This guide assumes that the following tests are run on a workstation and not using a pipeline system.

### Prerequisites

**NOTE:** This guide uses IAM users. This is not recommended for everyday use or in production environments! When using pipelines or in a secure environment, use alternative approaches such as authenticating runners or actions using OIDC and using IAM roles for them.

* AWS Access/Secret [keypair](https://docs.aws.amazon.com/keyspaces/latest/devguide/create.keypair.html) for a service account
* Terraform is [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* S3 bucket to host the `backend.tf` file
* Preexisting VPC, subnet, EC2 instance role, and SSH keypair

Follow these steps to deploy a Windows server with misconfigurations:

1. Clone this repository.
2. Navigate to the `terraform` directory.
3. Fill in values for the variables in `terraform.tfvars`.
4. Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables, like so:

   ```bash
   export AWS_ACCESS_KEY_ID=""
   export AWS_SECRET_ACCESS_KEY=""
   ```

5. Initiate Terraform directory with your backend bucket, like so:

   ```bash
   terraform init \
       -backend-config="bucket=awesome-tfstate-bucket" \
       -backend-config="key=optional/directory/terraform.tfstate" \
       -backend-config="region=us-east-2"
   terraform plan # This is optional especially if running in a pipeline
   terraform apply # Use flag -auto-approve if running in a pipeline
   ```

---

## Upcoming Changes

* Terraform code for VPC, subnet, EC2 instance role, and SSH keypair to be added.
* Ensure that this project works with a pipeline configured with OIDC.
* More resources via Terraform to cover wider variety of use cases.
* Integrate this repository with `cortexcli` to demonstrate code scanning capabilities.
