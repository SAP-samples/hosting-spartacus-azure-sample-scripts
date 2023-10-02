#!/bin/sh

# Path
PATH_SCRIPT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PATH_PROJECT="$PATH_SCRIPT/../../.."

# Build NodeJS image
echo "> $0 - compose spartacus stack: ${@:1}"
docker compose \
    -f $PATH_SCRIPT/../docker-compose.yaml \
    ${@:1}

