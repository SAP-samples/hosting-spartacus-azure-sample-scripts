# Dockerize Spartacus
This project build two docker images for Spartacus:
- `nginx` - The nginx docker image used to offload static contents.
- `nodejs` - The nodejs docker image used for the server side rendering (SSR).

## Prepare the environment
Export the following environment variable:
```
export SPARTACUS_APP_NAME=<the name of the spartacus application defined in the package.json>
export SPARTACUS_IMAGE_NODE=<the target name of the nodejs image>
export SPARTACUS_IMAGE_NGINX=<the target name of the nginx image>
export STARTACUS_IMAGE_TAG=<the docker tag of the image>
```
Or use [this](./scripts/env.sh) script to automatically set it up:
```
. ./scripts/env.sh
```
**NOTE**: adjust the value to reflect the project's settings.

## Build the spartacus images
Execute [this](./scripts/build.sh) script to build the docker images:
```
./scripts/build.sh
```
The building process is going to generate locally the two images:
- $SPARTACUS_IMAGE_NODE - The nodejs image used to serve the SSR version of Spartacus.
- $SPARTACUS_IMAGE_NGINX - The nginx image used as ambassador for the nodejs server.

**NOTE**: adjust the building step to reflect the building process of your Spartacus project.

## Test the Spartacus images
The images built in the previous step can be tested using [docker compose](./docker-compose.yaml).

Excute [this](./scripts/compose.sh) script to run locally the spartacus stack:
```
./scripts/compose.sh up
```
The following endpoints are exposed:
- http://localhost:18080 - nginx entry point (offload static content)
- http://localhost:18081/healthz - nginx health check.
- http://localhost:14000 - nodejs entry point (SSR)

## Tag & Push the spartacus images
The images built in the previous step can be pushed to a remote image repository using [this](./scripts/push.sh) utility script:
```
./scripts/push.sh <repository_url>
```
**NOTE:** Depending on the target repository a specific authentication step is required before pushing any image; here some example:
- Azure Container Registry - [authenticate by CLI](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli#log-in-to-a-registry)
- Azure Container Registry - [authenticate by Service Principal](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes)
- Docker Hub - [authenticate by Docker Login](https://docs.docker.com/engine/reference/commandline/login/)
