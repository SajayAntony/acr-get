#!/bin/sh
echo Running script
VERSION=$(cat version.txt)

while true
do 
  echo $VERSION `date` 
  sleep 1
done
