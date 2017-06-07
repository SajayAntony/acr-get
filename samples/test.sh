#!/bin/sh

IMAGE_NAME=$LOGIN_URL/$APP_NAME

echo `date +%s` > version.txt
docker build -t $IMAGE_NAME . 
docker push $IMAGE_NAME

