#!/bin/sh

#######################################
# Script
#######################################

# Label used as part of the hostname (e.g. https://DNS_LABEL.LOCATION.cloudapp.azure.com)
DNS_LABEL=$1
if [ -z "$DNS_LABEL" ]
then
      echo "DNS label is empty"
      exit 1
fi

# Current Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Install Spartacus SSR
echo "\n> install spartacus-ssr"
helm install spartacus-ssr $PATH_SCRIPT/../../helm/spartacus-ssr-chart \
    -n spartacus-ssr --create-namespace \
    -f $PATH_SCRIPT/values.yaml

# Install Certificate (JetStack)
helm repo add jetstack https://charts.jetstack.io

echo "\n> install helm: cert-manager"
helm install cert-manager jetstack/cert-manager \
    -n spartacus-ingress --create-namespace \
    --set installCRDs=true

# Install Ingress
helm repo add kubernetes-community https://kubernetes.github.io/ingress-nginx

echo "\n> install helm: spartacus-ingress"
helm install spartacus-ingress kubernetes-community/ingress-nginx \
    -n spartacus-ingress --create-namespace \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="$DNS_LABEL" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"="/healthz"
