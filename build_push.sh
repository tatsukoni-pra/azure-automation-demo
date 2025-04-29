# bin/bash

set -e

# Need to exec From Console
# az login
# az acr login --name acrtatsukonidemo

AZURE_CONTAINER_REGISTRY=acrtatsukonidemo.azurecr.io
REPOSITORY_NAME=servicebus-receiver
CONTAINER_IMAGE_TAG=$(date +%Y%m%d%H%M%S)-abcdefghijklmnopqrstuvwxyz

docker build --platform linux/amd64 --build-arg IMAGE_TAG=$CONTAINER_IMAGE_TAG -t $AZURE_CONTAINER_REGISTRY/$REPOSITORY_NAME:$CONTAINER_IMAGE_TAG .
docker push $AZURE_CONTAINER_REGISTRY/$REPOSITORY_NAME:$CONTAINER_IMAGE_TAG
