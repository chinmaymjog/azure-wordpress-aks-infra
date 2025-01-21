# Authenticating using a Service Principal with a Client Secret

## _Creating a Service Principal using the Azure CLI_

Firstly, login to the Azure CLI using:
```
$ az login
```
Once logged in - it's possible to list the Subscriptions associated with the account via:
```
$ az account list
```

The output will display one or more Subscriptions - with the id field being the subscription_id field referenced above.

Should you have more than one Subscription, you can specify the Subscription to use via the following command:
```
$ az account set --subscription="SUBSCRIPTION_ID"
```

We can now create the Service Principal which will have permissions to manage resources in the specified Subscription using the following command:
```
$ az ad sp create-for-rbac -n k8s-tf --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```

This command will output 5 values:
```
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```
These values map to the Terraform variables like so:

[appId] is the client_id defined above.
[password] is the client_secret defined above.
[tenant] is the tenant_id defined above.

## _Configuring the Service Principal in Terraform_
As we've obtained the credentials for this Service Principal - it's possible to configure them in a few different ways.

When storing the credentials as Environment Variables, for example:
```
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


## _Create storage account to store terraform state file._
Decide in which REGION you want to deploy your infrastructure.
Define RESOURCE\_GROUP, STORAGE_ACCOUNT, CONTAINER to store terraform state file.

```
az group create -l "REGION" -n "RESOURCE_GROUP" --subscription "SUBSCRIPTION_ID"

az storage account create -n "STORAGE_ACCOUNT" -g "RESOURCE_GROUP" -l "REGION"

az storage container create -n "CONTAINER" --account-name "STORAGE_ACCOUNT"
```

# _Terraform and Provider blocks_
The following Terraform and Provider blocks can be specified - where 2.46.0 is the version of the Azure Provider that you'd like to use:
```
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "RESOURCE_GROUP"
    storage_account_name = "STORAGE_ACCOUNT"
    container_name       = "CONTAINER"
    key                  = "var.project.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
```
At this point running either terraform plan or terraform apply should allow Terraform to run using the Service Principal to authenticate.


## Packer version dependancy for terraform

Packer v1.8.4 