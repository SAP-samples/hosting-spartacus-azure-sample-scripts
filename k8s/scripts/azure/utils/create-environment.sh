#!/bin/sh

#######################################
# Environment Variables
#######################################

# The azure subscription to use.
# SUBSCRIPTION_ID="" 

# The resource group location (e.g. westeurope)
# LOCATION=""

# The name of the resource group (e.g. seh-env)
# RESOURCE_GROUP_NAME=""

# The VM size of the node pool (e.g. Standard_B4ms for a dev env)
# AKS_SIZE=""

# The number of node to be created (ex. 1)
# AKS_NODE=""

# The min number of nodes (ex. 1)
# AKS_MIN_NODE=""

# The max value of nodes (ex. 3)
# AKS_MAX_NODE=""

#######################################
# Environment Derived
#######################################

AKS_NAME="$RESOURCE_GROUP_NAME-aks"

#######################################
# Script
#######################################

echo "\n> use subscription: $SUBSCRIPTION_ID"
az account set -s $SUBSCRIPTION_ID

echo "\n> create resource group: $RESOURCE_GROUP_NAME"
az group create -n $RESOURCE_GROUP_NAME -l $LOCATION

echo "\n> create aks cluster: $AKS_NAME"
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AKS_NAME \
    -s $AKS_SIZE \
    -c $AKS_NODE \
    -a monitoring \
    --generate-ssh-keys \
    --enable-cluster-autoscaler --min-count $AKS_MIN_NODE --max-count $AKS_MAX_NODE \
    --cluster-autoscaler-profile scale-down-unneeded-time=5m max-node-provision-time=5m \
    --network-plugin kubenet  

