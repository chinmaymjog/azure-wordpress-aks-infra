#!/bin/bash

# #################### CREATE HUB RESOURCES ##############
source ./.env
source ./global_variables

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID -o none
az account set -s $ARM_SUBSCRIPTION_ID

cd ./landing_zone
az group list --output table | grep $hub_rgname
if [ $? -ne 0 ] 
then

    echo "creating $hub_rgname, $tf_staccount & $tf_container  to store terraform state files"
    az group create -n $hub_rgname -l $hub_location
    sleep 15
    az storage account create -n $tf_staccount -g $hub_rgname -l $hub_location
    sleep 15
    az storage container create -n $tf_container --account-name $tf_staccount

else

    echo "$hub_rgname resource group exists"
    az storage account list -g $hub_rgname -o table | grep $tf_staccount
    if [ $? -ne 0 ]
    then
    echo "creating $tf_staccount storage account"
    az storage account create -n $tf_staccount -g $hub_rgname -l $hub_location
    else
    echo "$tf_staccount storage account exists"
    fi

    az storage container list --auth-mode login  --account-name $tf_staccount -o table | grep $tf_container
    if [ $? -ne 0 ]
    then
    echo "creating $tf_container tf_container"
    az storage container create --auth-mode login -n $tf_container --account-name $tf_staccount
    else
    echo "$tf_container tf_container exists"
    fi
fi

awk -F "=" '!/^$/ && !/^#/' ../global_variables | while read line; do var=$(echo $line | cut -d'=' -f1); value=$(echo $line | cut -d'=' -f2);  echo $var" = ""\"$(eval echo $value)\""; done > ../global_variables.tfvars
terraform init -backend-config="resource_group_name=$hub_rgname" -backend-config="storage_account_name=$tf_staccount" -backend-config="container_name=$tf_container" --upgrade
terraform apply -var-file=hub-terraform.tfvars -var-file=../global_variables.tfvars -auto-approve
cd ..
#################### END HUB RESOURCES ##############

#################### CREATE AKS RESOURCES ##############

source ./.env
source ./global_variables

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID -o none
az account set -s $ARM_SUBSCRIPTION_ID

cd ./kubernetes
awk -F "=" '!/^$/ && !/^#/' ../global_variables | while read line; do var=$(echo $line | cut -d'=' -f1); value=$(echo $line | cut -d'=' -f2);  echo $var" = ""\"$(eval echo $value)\""; done > ../global_variables.tfvars
terraform -chdir=../landing_zone output > ../global_hub.tfvars
cat ../global_variables.tfvars ../global_hub.tfvars > ../global_aks.tfvars

aks_env=lab
aks_location_short=weu
terraform init -backend-config="resource_group_name=$hub_rgname" -backend-config="storage_account_name=$tf_staccount" -backend-config="container_name=$tf_container" -backend-config="key=aks-$project-$aks_env-$aks_location_short.tfstate" --reconfigure
terraform apply -var-file=$aks_env-$aks_location_short-terraform.tfvars -var-file=../global_aks.tfvars #-auto-approve
# terraform -chdir=../landing_zone output
#################### END AKS RESOURCES ##############