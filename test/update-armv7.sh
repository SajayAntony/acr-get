#!/bin/sh

IMAGE_NAME="$REGISTRY_HOST/testapp:armv7"

echo `date +%s` > testapp/version.txt
docker build -t $IMAGE_NAME -f Dockerfile.armv7 . 
docker push $IMAGE_NAME

