#!/bin/sh

# Current Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Add repository
echo "\n> add helm repository for ingress"
helm repo add kubernetes-community https://kubernetes.github.io/ingress-nginx

# Install Spartacus SSR
echo "\n> install spartacus-ssr"
helm install spartacus-ssr $PATH_SCRIPT/../../helm/spartacus-ssr-chart \
    -n spartacus-ssr --create-namespace \
    -f $PATH_SCRIPT/values.yaml

# Install Ingress
echo "\n> install helm: spartacus-ingress"
helm install spartacus-ingress kubernetes-community/ingress-nginx \
    -n spartacus-ingress \
    --create-namespace
