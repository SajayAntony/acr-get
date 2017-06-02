#!/bin/sh
if ! type docker  >/dev/null 2>&1 ; then
  echo "Install docker from docker.com"
  echo "curl -L https://get.docker.com | sh"
  curl -L https://get.docker.com | sh
fi

#Get the registry and application details from the user.

read -p 'Login URL: ' loginurl
read -p 'Application image name($loginurl/appname)' : APP_NAME

IMAGE= "$loginurl/$APP_NAME"

#Docker login into registry 
docker login $loginurl

#Run the image
docker run $IMAGE

watch_for_updates()
{
  docker pull $IMAGE
  CID = $(docker ps | grep $IMAGE| awk '{print $1}') 

  for im in CID
  do
    LATEST=`docker insepct --format "{{.Id}}" $IMAGE`
    RUNNING=`docker inspect --format "{{.Image}}" $im`
    NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    echo "Latest : " $LATEST 
    echo "Running: " $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
        echo "upgrading $NAME"
        stop docker-$NAME
        docker rm -f $NAME
        start docker-$NAME
    fi
  done
}


#Every 10 seconds check for updates 
forever 10 watch_for_updates

