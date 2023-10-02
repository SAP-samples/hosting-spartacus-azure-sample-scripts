#!/bin/bash

# Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PATH_PROJECT="$PATH_SCRIPT/../../.."

# Build NodeJS image
echo "> $0 - building image: $SPARTACUS_IMAGE_NODE"
docker build \
  -f ./seh/docker/node/spartacus-node.dockerfile \
  --build-arg SPARTACUS_APP_NAME=$SPARTACUS_APP_NAME \
  -t "$SPARTACUS_IMAGE_NODE" \
  $PATH_PROJECT

# Build Nginx image
echo "> $0 - building image: $SPARTACUS_IMAGE_NGINX"
docker build \
  -f ./seh/docker/nginx/spartacus-nginx.dockerfile \
  --build-arg SPARTACUS_APP_NAME=$SPARTACUS_APP_NAME \
  --build-arg SPARTACUS_SSR_IMAGE=$SPARTACUS_IMAGE_NODE \
  -t "$SPARTACUS_IMAGE_NGINX" \
  $PATH_PROJECT

