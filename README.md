# Container Autoupdate from a Registry
Devices like Raspberry Pis ,are capable of running containers. The sample helps to run a monitoring agent on the device that launches and application and will autoupdate when the tag is udpated on the registry. 

## Build and push your application 
```
cd app
docker build -t $REGISTRY\app .
docker push $REGISTRY\app
```


## Device setup
Ensure that the device has access to a Docker Registry that is hosting your image. On the device run the following command. 
```
source<(curl -L someurl)
```


You can now try updating the application and once you push the udpate to the registry, you should see that the device downloads the udpate and runs the new container after stopping the old container. 
