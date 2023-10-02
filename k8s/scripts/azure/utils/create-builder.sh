#!/bin/sh

#######################################
# Environment Variables
#######################################

# The azure subscription to use.
# SUBSCRIPTION_ID="" 

# The azure location for the resources.
# LOCATION=""

# The name of the resource group (e.g. builder)
# RESOURCE_GROUP_NAME=""

# The IP space available to the Virtual Network (e.g. 10.2.0.0/16 = 65536 addresses)
# VNET_ADDRESS_SPACE=""

# The IP space available to the Subnet (VMSS) (e.g. 10.2.1.0/24 = 251 addresses)
# SNET_ADDRESS_SPACE=""

# The name of the Azure Container Registry (e.g sehacr)
# ACR_NAME=""

# The VM size (e.g. Standard_B4ms for a dev env)
# VMSS_SKU=""

# The VM admin username
# VMSS_ADMIN_USERNAME=""

# The VM admin password
# VMSS_ADMIN_PASSWORD=""

# The number of VMs in the Scaling Set (ex 2)
# VMSS_COUNT=""

#######################################
# Environment Constants
#######################################
VMSS_IMAGE="Canonical:UbuntuServer:18.04-LTS:latest"

LB_SKU="Basic"

ACR_SKU="Basic"

#######################################
# Environment Derived
#######################################
VNET_NAME="$RESOURCE_GROUP_NAME-vnet"

SNET_NAME="$RESOURCE_GROUP_NAME-snet"

VMSS_NAME="$RESOURCE_GROUP_NAME-vmss"

LB_NAME="$RESOURCE_GROUP_NAME-lb"

NSG_NAME="$RESOURCE_GROUP_NAME-nsg"

VNET_PEER_NAME="$RESOURCE_GROUP_NAME-vnet"

#######################################
# Script
#######################################

echo "\n> use subscription: $SUBSCRIPTION_ID"
az account set -s $SUBSCRIPTION_ID

echo "\n> create resource group: $RESOURCE_GROUP_NAME"
az group create -n $RESOURCE_GROUP_NAME -l $LOCATION

echo "\n> create virtual network: $VNET_NAME"
az network vnet create \
    --name $VNET_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --address-prefix $VNET_ADDRESS_SPACE

echo "\n> create network security group: $NSG_NAME"
az network nsg create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $NSG_NAME \

NSG_ID=$(az network nsg show --resource-group $RESOURCE_GROUP_NAME --name $NSG_NAME --query id -o tsv)

echo "\n> create subnet: $SNET_NAME"
az network vnet subnet create \
    --name $SNET_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name $VNET_NAME \
    --address-prefix $SNET_ADDRESS_SPACE \
    --network-security-group $NSG_ID


echo "\n> create container registry: $ACR_NAME"
az acr create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $ACR_NAME \
    --sku $ACR_SKU

SNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP_NAME --vnet-name $VNET_NAME --name $SNET_NAME --query id -o tsv)

Do I need NSG at subnet level????
echo "\n> create VM Scaling Set: $RESOURCE_GROUP_NAME"
az vmss create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $VMSS_NAME \
  --orchestration-mode Flexible \
  --image $VMSS_IMAGE \
  --upgrade-policy-mode automatic \
  --instance-count $VMSS_COUNT \
  --admin-username $VMSS_ADMIN_USERNAME \
  --admin-password $VMSS_ADMIN_PASSWORD \
  --load-balancer $LB_NAME \
  --lb-sku $LB_SKU \
  --vm-sku $VMSS_SKU \
  --subnet $SNET_ID \
  --nsg $NSG_NAME \
  --generate-ssh-keys


echo "\n> create LB rule: $RESOURCE_GROUP_NAME"
az network lb rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name "$LB_NAME-sshTraffic" \
  --lb-name $LB_NAME \
  --backend-port 22 \
  --frontend-port 22 \
  --protocol tcp
