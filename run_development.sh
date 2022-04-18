#!/bin/bash

container_name="development_env"
image='dockerhub.deepglint.com/atlas/developmentkit_advanced'
tag='v0.6-x86_64'

docker rm -f $container_name

docker run -d --name=$container_name -P \
    --security-opt seccomp=unconfined \
    -v /:/host \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ${image}:$tag

docker port $container_name

