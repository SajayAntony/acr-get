# Auto updating container based applications
Devices like Raspberry Pis ,are capable of running containers and can easily update an application that is running as a container using a simple agent. The sample helps to run a monitoring agent on the device that launches an  application and will autoupdate when a the app is udpated on the registry.

## Build and push your application 

You can use the test applciation available under [test/testapp](test/testapp)

```
docker build -t $REGISTRY_HOST\testapp .
docker push $REGISTRY_HOST\testapp
```
> Make sure you have configured the `REGSITRY_HOST` variable to point to the registry you want to push your app to. 

## Device setup
Ensure that the device has access to a Docker Registry that is hosting your image. On the device run the following command. 

```
docker build -t agent .
docker run -it --rm -v /var/run/docker.sock:/var/dun/docker.sock agent
```

## Push an update

Run the [test/update.sh](test/update.sh) script after navigating into the test directory to change the version of the application and push the updated app. 


## Container Upgrade

Once you push your application you should see that the agent detects a new image and stops the current container and relaunches the container with the newly downloaded image.


