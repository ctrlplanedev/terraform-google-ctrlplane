# terraform-google-ctrlplane

This module creates a reslient and fault tolerant Ctrlplane installation using
Google Kubernetes Engine (GKE) as the computing environment and the following
services for storing data:

- CloudSQL for PostgreSQL
- Memorystore for Redis
- Cloud Storage

## Compatibility

This module is meant for use with Terraform 1.0+ and tested using Terraform
1.6.

## Usage

There are examples included in the examples folder but simple usage is as
follows:

```hcl
module "ctrlplane" {
  source    = "sizzldev/ctrlplane/google"
  namespace = "ctrlplane"
  domains   = ["<fqdn>"]
}
```

Then perform the following commands on the root folder:

1. `terraform init` to get the plugins
2. `terraform plan` to see the infrastructure plan
3. `terraform apply` to apply the infrastructure build
4. `terraform destroy` to destroy the built infrastructure

## Install

**Terraform**

Be sure you have the correct Terraform version, you can choose the binary here:

- https://releases.hashicorp.com/terraform/

## File structure

The project has the following folders and files:

- `/`: root folder
- `/examples`: examples for using this module
- `/helpers`: Helper scripts
- `/test`: Folders with files for testing the module (see Testing section on
  this file)
- `/main.tf`: main file for this module, contains all the resources to create
- `/variables.tf`: all the variables for the module
- `/output.tf`: the outputs of the module
- `/README.md`: this file
