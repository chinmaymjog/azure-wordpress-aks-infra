#!/bin/bash

# Function to initialize the environment and Azure login
initiate() {
    source ./.env
    source ./global_variables

    az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID" -o none
    az account set -s "$ARM_SUBSCRIPTION_ID"

    # Generate Terraform variables file from global variables
    awk -F "=" '!/^$/ && !/^#/' global_variables | while read -r line; do
        var=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2)
        echo "$var = \"$(eval echo "$value")\""
    done > global_variables.tfvars
}

# Function to create a resource group if it doesn't exist
create_resource_group() {
    local rg_name=$1
    local rg_location=$2

    if ! az group show -n "$rg_name" &>/dev/null; then
        echo "Creating resource group: $rg_name"
        az group create -n "$rg_name" -l "$rg_location" -o none
    else
        echo "Resource group $rg_name already exists."
    fi
}

# Function to create a storage account if it doesn't exist
create_storage_account() {
    local sa_name=$1
    local rg_name=$2
    local sa_location=$3

    if ! az storage account show -n "$sa_name" -g "$rg_name" &>/dev/null; then
        echo "Creating storage account: $sa_name"
        az storage account create -n "$sa_name" -g "$rg_name" -l "$sa_location" -o none
    else
        echo "Storage account $sa_name already exists."
    fi
}

# Function to create a storage container if it doesn't exist
create_storage_container() {
    local container_name=$1
    local sa_name=$2

    if ! az storage container show --account-name "$sa_name" -n "$container_name" &>/dev/null; then
        echo "Creating storage container: $container_name"
        az storage container create -n "$container_name" --account-name "$sa_name" -o none
    else
        echo "Storage container $container_name already exists."
    fi
}

terraform_deploy() {
    local component=$1
    local env=$2
    local location=$3
    local action=${4:-plan}

    cd "./$component" || exit
    terraform init \
        -backend-config="resource_group_name=$hub_rgname" \
        -backend-config="storage_account_name=$tf_staccount" \
        -backend-config="container_name=$tf_container" \
        -backend-config="key=$component-$project-$env-$location.tfstate" -reconfigure

    if [ $env == "hub" ]; then
        terraform $action -var-file=shared-hub-weu-terraform.tfvars -var-file=../global_variables.tfvars # -auto-approve
    else
        terraform -chdir=../hub output > ../global_hub.tfvars
        is_empty=$(cat ../global_hub.tfvars | grep "No outputs found")
        if [ -z "$is_empty" ]; then
            cat ../global_variables.tfvars ../global_hub.tfvars > ../global_aks.tfvars
            terraform $action -var-file="$component-$env-$location-terraform.tfvars" -var-file=../global_aks.tfvars # -auto-approve
        else
            echo "Hub outputs are empty. Cannot proceed with $component deployment."
            exit 1
        fi
    fi
    cd ..
}

# Main script execution starts here
initiate

# Hub resources creation
create_resource_group "$hub_rgname" "$hub_location"
create_storage_account "$tf_staccount" "$hub_rgname" "$hub_location"
create_storage_container "$tf_container" "$tf_staccount"

# Terraform initialization and apply for Hub
terraform_deploy "hub" "hub" "weu" "plan"

terraform_deploy "aks" "lab" "weu" "plan"
terraform_deploy "db" "lab" "weu" "plan"