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

# Main script execution starts here
initiate

# # Hub resources creation
# create_resource_group "$hub_rgname" "$hub_location"
# create_storage_account "$tf_staccount" "$hub_rgname" "$hub_location"
# create_storage_container "$tf_container" "$tf_staccount"

# # Terraform initialization and apply for Hub
# cd ./hub || exit
# terraform init \
#     -backend-config="resource_group_name=$hub_rgname" \
#     -backend-config="storage_account_name=$tf_staccount" \
#     -backend-config="container_name=$tf_container" \
#     -backend-config="key=$project-$hub_env-$hub_location_short.tfstate"

# terraform apply -var-file=hub-terraform.tfvars -var-file=../global_variables.tfvars # -auto-approve
# cd ..

# # Terraform initialization and apply for AKS
# cd ./aks || exit
# terraform -chdir=../hub output > ../global_hub.tfvars
# cat ../global_variables.tfvars ../global_hub.tfvars > ../global_aks.tfvars

# aks_env="lab"
# aks_location_short="weu"
# terraform init \
#     -backend-config="resource_group_name=$hub_rgname" \
#     -backend-config="storage_account_name=$tf_staccount" \
#     -backend-config="container_name=$tf_container" \
#     -backend-config="key=aks-$project-$aks_env-$aks_location_short.tfstate"

# terraform plan -var-file="aks-$aks_env-$aks_location_short-terraform.tfvars" -var-file=../global_aks.tfvars # -auto-approve
# cd ..

# Terraform initialization and apply for database
cd ./database || exit
terraform -chdir=../hub output > ../global_hub.tfvars
cat ../global_variables.tfvars ../global_hub.tfvars > ../global_aks.tfvars

db_env="lab"
db_location_short="weu"
terraform init \
    -backend-config="resource_group_name=$hub_rgname" \
    -backend-config="storage_account_name=$tf_staccount" \
    -backend-config="container_name=$tf_container" \
    -backend-config="key=aks-$project-$db_env-$db_location_short.tfstate"

terraform plan -var-file="db-$db_env-$db_location_short-terraform.tfvars" -var-file=../global_aks.tfvars # -auto-approve
cd ..
