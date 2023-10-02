#!/bin/sh

# Current Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Upgrade Spartacus SSR
echo "\n> install spartacus-ssr"
helm upgrade spartacus-ssr $PATH_SCRIPT/../../helm/spartacus-ssr-chart \
    -n spartacus-ssr \
    -f $PATH_SCRIPT/values.yaml
