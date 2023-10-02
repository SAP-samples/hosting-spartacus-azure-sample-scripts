#!/bin/sh

#######################################
# Script
#######################################

echo "\n> uninstall cert manager"
helm uninstall cert-manager -n spartacus-ingress 

echo "\n> uninstall helm: spartacus-ingress"
helm uninstall spartacus-ingress -n spartacus-ingress 

echo "\n> uninstall spartacus-ssr"
helm uninstall spartacus-ssr -n spartacus-ssr 
