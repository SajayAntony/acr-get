#!/bin/sh

IMAGE_NAME="$REGISTRY_HOST/testapp"

echo `date +%s` > testapp/version.txt
docker build -t $IMAGE_NAME testapp/. 
docker push $IMAGE_NAME

