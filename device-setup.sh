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
#Check if you need to login
echo Trying to pull image,
if  echo "$(docker pull $IMAGE 2>&1)" | grep -q  "not found" ; then
  echo Could not pull image. Trying to login again. 
  docker login $LOGIN_URL
fi

#Declare container ID
CID=""

get_container_id()
{
    #If docker build is tagging then we don't get the running container
    #so we try again after a few seconds to get the container id again. 
    CID=$(docker ps | grep $IMAGE| awk '{print $1}')   
    if [ -z "$CID" ]; then
      sleep 10 
      CID=$(docker ps | grep $IMAGE| awk '{print $1}') 
    fi 
}


watch_for_updates()
{
  echo Pulling Latest $IMAGE
  get_container_id

  echo "----------------------------------" 
  echo $CID
  echo "----------------------------------" 

  if [ -z "$CID" ]; then
     echo "No running container so running and returning"
     docker run -d $IMAGE
     return;
  fi

  docker pull $IMAGE
  for im in $CID
  do
    LATEST=`docker inspect --format "{{.Id}}" $IMAGE`
    RUNNING=`docker inspect --format "{{.Image}}" $im`
    NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    echo "Latest : " $LATEST 
    echo "Running: " $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
        #We are upgrading the container 
        
        YELLOW='\033[0;33m'
	NC='\033[0m' # No Color
        echo -e "${YELLOW}Upgrading $NAME ${NC}"
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

