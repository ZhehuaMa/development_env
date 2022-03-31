#!/bin/bash

container_name="development_env"

docker rm -f $container_name

docker run -d -P --name=$container_name \
    -v /:/host \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    dockerhub.deepglint.com/atlas/developmentkit_advanced:v0.3-x86_64

docker port $container_name

