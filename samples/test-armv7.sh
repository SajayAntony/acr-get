#!/bin/sh

IMAGE_NAME="$LOGIN_URL/$APP_NAME:armv7"

echo `date +%s` > version.txt
docker build -t $IMAGE_NAME -f Dockerfile.armv7 . 
docker push $IMAGE_NAME

