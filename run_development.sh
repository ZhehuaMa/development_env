#!/bin/bash

container_name="development_env"

docker rm -f $container_name

docker run -d --name=$container_name -P \
    --security-opt seccomp=unconfined \
    -v /:/host \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    dockerhub.deepglint.com/atlas/developmentkit_advanced:v0.4-x86_64

docker port $container_name

