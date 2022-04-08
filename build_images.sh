#!/bin/bash

base_repo='dockerhub.deepglint.com/atlas/developmentkit_base'
base_tag=v0.1-x86_64

advanced_repo='dockerhub.deepglint.com/atlas/developmentkit_advanced'
advanced_tag=v0.4-x86_64

context_path=''

function get_context_path() {
    context_path=$(echo $1 | awk -F ':' '{print $1}')
    context_path=$(echo $context_path | awk -F '_' '{print $2}')
}

function docker_build() {
    work_dir=$(pwd)/${context_path}
    set -o pipefail
    docker build -t $1 -f ${work_dir}/Dockerfile $work_dir 2>&1 | tee ${work_dir}/docker_build.log
}

function build_image() {
    get_context_path $1

    echo "building images ${1}..."
    docker_build $1

    while [ $? -ne 0 ]
    do
        echo "building images $1 failed, retrying..."
        docker_build $1
    done
    echo "building images $1 success!"
}

build_image ${base_repo}:${base_tag}

sed -i "1s/.*/FROM ${base_repo}:${base_tag}/" $(pwd)/advanced/Dockerfile
build_image ${advanced_repo}:${advanced_tag}
