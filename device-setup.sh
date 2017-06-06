#!/bin/sh
if ! type docker  >/dev/null 2>&1 ; then
  echo "Install docker from docker.com"
  echo "curl -L https://get.docker.com | sh"
  curl -L https://get.docker.com | sh
fi

#Get the registry and application details from the user.

read -p 'Login URL: ' LOGIN_URL
read -p 'Image name $(LOGIN_URL)/image: ' APP_NAME

IMAGE="$LOGIN_URL/$APP_NAME"

#Docker login into registry 
#TODO:  check if you need to login
#docker login $LOGIN_URL

watch_for_updates()
{
  echo Pulling Latest $IMAGE
  docker pull $IMAGE
  CID=$(docker ps | grep $IMAGE| awk '{print $1}') 

  if [ -z "$CID" ]; then
     echo "No running container so running and returning"
     docker run -d $IMAGE
     return;
  fi

  for im in $CID
  do
    LATEST=`docker inspect --format "{{.Id}}" $IMAGE`
    RUNNING=`docker inspect --format "{{.Image}}" $im`
    NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    echo "Latest : " $LATEST 
    echo "Running: " $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
        echo "upgrading $NAME"
        docker stop $NAME
        docker rm -f $NAME
        docker run -d $NAME
    fi
  done
}


#Every 10 seconds check for updates 
while true
do
   watch_for_updates
   sleep 10
done 

