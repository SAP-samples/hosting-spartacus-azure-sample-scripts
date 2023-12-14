#!/bin/sh

# The full name of the repository (ex <registry_name>.azurecr.io)
IMAGE_REPOSITORY=$1

# Tag NodeJs
TAG_IMAGE_NODE="$IMAGE_REPOSITORY/$SPARTACUS_IMAGE_NODE:$SPARTACUS_IMAGE_TAG"
echo "> $0 - tag image: $TAG_IMAGE_NODE"
docker tag $SPARTACUS_IMAGE_NODE $TAG_IMAGE_NODE

# Push NodeJs
echo "> $0 - push image: $TAG_IMAGE_NODE"
docker push $TAG_IMAGE_NODE

# Tag Nginx
TAG_IMAGE_NGINX="$IMAGE_REPOSITORY/$SPARTACUS_IMAGE_NGINX:$SPARTACUS_IMAGE_TAG"
echo "> $0 - tag image: $TAG_IMAGE_NGINX"
docker tag $SPARTACUS_IMAGE_NGINX $TAG_IMAGE_NGINX

# Push Nginx
echo "> $0 - push image: $TAG_IMAGE_NGINX"
docker push $TAG_IMAGE_NGINX


