#!/bin/bash

set -e

# Default variables
ENV="lab"
LOCATION_SHORT="weu"
ACTION="plan"
COMPONENT=""

# Parse arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: ./deploy.sh [component] [action] [env] [location_short]"
    echo "  component: hub, aks, or db"
    echo "  action:    plan, apply, or destroy (default: plan)"
    echo "  env:       environment name (default: lab)"
    echo "  location:  location shortname (default: weu)"
    echo "Example: ./deploy.sh hub apply"
    exit 1
fi

COMPONENT=$1
if [[ -n "$2" ]]; then ACTION=$2; fi
if [[ -n "$3" ]]; then ENV=$3; fi
if [[ -n "$4" ]]; then LOCATION_SHORT=$4; fi

# Function to initialize the environment and Azure login
initiate() {
    if [[ -f ./.env ]]; then
        source ./.env
    else
        echo "Error: .env file not found. Please create one from .env-template."
        exit 1
    fi

    if [[ -f ./global_variables ]]; then
        source ./global_variables
    else
        echo "Error: global_variables file not found."
        exit 1
    fi

    echo "Logging into Azure..."
    az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID" -o none
    az account set -s "$ARM_SUBSCRIPTION_ID"

    echo "Generating global_variables.tfvars..."
    # Generate Terraform variables file safely
    > global_variables.tfvars
    while IFS='=' read -r var value || [[ -n "$var" ]]; do
        # Output clean variables excluding comments and empty lines
        if [[ ! "$var" =~ ^# ]] && [[ -n "$var" ]]; then
            # Evaluate variable placeholders safely (e.g. $project)
            eval_val=$(eval echo "$value")
            # Remove any trailing comments from the line if they exist
            eval_val=$(echo "$eval_val" | sed 's/ *#.*//')
            echo "${var}=\"${eval_val}\"" >> global_variables.tfvars
        fi
    done < global_variables
}

# Function to ensure storage account and container exist
ensure_backend_infra() {
    # Re-evaluate these variables just to be safe
    local rg_name="rg-${project}-hub-${LOCATION_SHORT}"
    local sa_name="st${project}hub${LOCATION_SHORT}"
    local container_name="tfstate-${project}"

    if ! az group show -n "$rg_name" &>/dev/null; then
        echo "Creating resource group: $rg_name"
        az group create -n "$rg_name" -l "$hub_location" -o none
    fi

    if ! az storage account show -n "$sa_name" -g "$rg_name" &>/dev/null; then
        echo "Creating storage account: $sa_name"
        az storage account create -n "$sa_name" -g "$rg_name" -l "$hub_location" --sku Standard_LRS -o none
    fi

    if ! az storage container show --account-name "$sa_name" -n "$container_name" &>/dev/null; then
        echo "Creating storage container: $container_name"
        az storage container create -n "$container_name" --account-name "$sa_name" -o none
    fi
}

terraform_deploy() {
    local component=$1
    local action=$2
    local env=$3
    local location_short=$4

    # The prefix changes if it's the hub or a spoke
    local tf_env=$env
    if [[ "$component" == "hub" ]]; then
        tf_env="hub"
    fi

    local tf_prefix="shared"
    if [[ "$component" != "hub" ]]; then
        tf_prefix=$component
    fi

    local state_key="${component}-${project}-${tf_env}-${location_short}.tfstate"
    local var_file="${tf_prefix}-${tf_env}-${location_short}-terraform.tfvars"

    local rg_name="rg-${project}-hub-${LOCATION_SHORT}"
    local sa_name="st${project}hub${LOCATION_SHORT}"
    local container_name="tfstate-${project}"

    echo "========================================================"
    echo "Running Terraform $action for $component ($env)"
    echo "State Key: $state_key"
    echo "Var File:  $var_file"
    echo "========================================================"

    cd "./$component" || exit 1

    terraform init \
        -backend-config="resource_group_name=${rg_name}" \
        -backend-config="storage_account_name=${sa_name}" \
        -backend-config="container_name=${container_name}" \
        -backend-config="key=${state_key}" -reconfigure

    if [[ "$component" == "hub" ]]; then
        if [[ "$action" == "apply" || "$action" == "destroy" ]]; then
            terraform $action -var-file="$var_file" -var-file=../global_variables.tfvars -auto-approve
        else
            terraform $action -var-file="$var_file" -var-file=../global_variables.tfvars
        fi
    else
        # For non-hub components, we need the hub outputs
        echo "Fetching Hub outputs..."
        terraform -chdir=../hub output > ../global_hub.tfvars
        
        if grep -q "No outputs found" ../global_hub.tfvars; then
            echo "Error: Hub outputs are empty. You must deploy the hub first."
            exit 1
        fi

        # Combine variables
        cat ../global_variables.tfvars ../global_hub.tfvars > ../global_aks.tfvars

        if [[ "$action" == "apply" || "$action" == "destroy" ]]; then
            terraform $action -var-file="$var_file" -var-file=../global_aks.tfvars -auto-approve
        else
            terraform $action -var-file="$var_file" -var-file=../global_aks.tfvars
        fi
    fi
    cd ..
}

# Main script execution
initiate
ensure_backend_infra
terraform_deploy "$COMPONENT" "$ACTION" "$ENV" "$LOCATION_SHORT"