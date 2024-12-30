# crowsnest-demo-podman
A simple demo of Crowsnest functionality using podman.

## Create a network
```$ podman network create crowsnest```

## Check it exists
```
$ podman network ls
NETWORK ID    NAME        DRIVER
2f259bab93aa  podman      bridge
6efc3a8230c1  crowsnest   bridge
```

## Build the app
```
$ podman build -t crowsnest:latest . 
```
(Note: don't forget the . at the end of the above command!)
## Output
```
STEP 1/5: FROM registry.access.redhat.com/ubi9/php-81:latest
STEP 2/5: MAINTAINER Chris Jenkins "chrisj@redhat.com"
--> Using cache aada37655cec7a66ff3745bea051aebb3c6dbdf40b1b810335dc3b2f4eadfd0e
--> aada37655cec
STEP 3/5: EXPOSE 8080
--> Using cache c6d215e24d2958f1b50f41693432787afa42468a70d12448ab80ab25f25a7bd5
--> c6d215e24d29
STEP 4/5: COPY . /opt/app-root/src
--> c916517caea7
STEP 5/5: CMD /bin/bash -c 'php -S 0.0.0.0:8080'
COMMIT crowsnest:latest
--> 29982d8f97ec
Successfully tagged localhost/crowsnest:latest
29982d8f97ece7e5c674bfc19ed380dc7689b3611960c7561608adec6694e64a
```

## Check it built ok
```
$ podman image list | grep crowsnest
localhost/crowsnest                           latest            0b18d14f7740  10 seconds ago  937 MB
```

## Run the Backend App

```
$ podman run -d --rm --name=crowsnest-backend --network crowsnest quay.io/ablock/crowsnest-backend:latest
```

## Run the Frontend App

```
$ podman run -it -p 8080:8080 --network crowsnest -e CROWSNEST_BACKEND=http://crowsnest-backend:8080 localhost/crowsnest
```

[Thu May 30 06:34:02 2024] PHP 8.1.27 Development Server (http://0.0.0.0:8080) started
```

You can then open a browser and navigate to [http://localhost:8080](http://localhost:8080) to open the application.



