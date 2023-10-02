#!/bin/sh

# Current Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Uninstall Ingress
echo "\n> uninstall helm: spartacus-ingress"
helm uninstall spartacus-ingress -n spartacus-ingress 

# Uninstall Spartacus SSR
echo "\n> uninstall spartacus-ssr"
helm uninstall spartacus-ssr -n spartacus-ssr 
