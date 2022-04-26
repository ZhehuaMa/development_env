#!/bin/bash

https_proxy=''
proxy_auth='https://your_proxy.com:1234'

base_repo='dockerhub.deepglint.com/atlas/developmentkit_base'
base_tag=v0.4-x86_64

advanced_repo='dockerhub.deepglint.com/atlas/developmentkit_advanced'
advanced_tag=v0.6-x86_64

context_path=''
build_arg=''

function get_context_path() {
    context_path=$(echo $1 | awk -F ':' '{print $1}')
    context_path=$(echo $context_path | awk -F '_' '{print $2}')
}

function switch_proxy() {
    if [ -z "$https_proxy" ]
    then
        https_proxy=$proxy_auth
    else
        https_proxy=''
    fi
}

function docker_build() {
    work_dir=$(pwd)/$context_path
    switch_proxy
    set -o pipefail
    docker build --build-arg HTTPS_PROXY=$https_proxy -t $1 -f $work_dir/Dockerfile $work_dir 2>&1 | tee -a $work_dir/docker_build.log
}

function build_image() {
    get_context_path $1
    rm -f $context_path/docker_build.log

    echo "building images $1..."
    docker_build $1

    while [ $? -ne 0 ]
    do
        echo "building images $1 failed, retrying..."
        docker_build $1
    done
    echo "building images $1 success!"
}

build_image $base_repo:$base_tag

sed -i "1s#.*#FROM $base_repo:$base_tag#" $(pwd)/advanced/Dockerfile
build_image $advanced_repo:$advanced_tag

sed -i "s/tag=.*/tag='$advanced_tag'/" $(pwd)/run_development.sh

