#!/bin/bash


function docker-init-shell () {
    MACHINE_NAME="$1"
    if [ "$MACHINE_NAME" == "" ]; then
        MACHINE_NAME="default"
    fi
    eval "$(docker-machine env $MACHINE_NAME)"
}


function docker-ps-filter-data-containers () {
    if [ "$1" == "" ]; then
        docker ps -a | grep -v 'data_\|data_\|data_' | head -n 30
    else
        docker ps -a | grep -v 'data_\|data_\|data_' | grep $1
    fi;
}


function show-containers () {
    if [ "$1" == "" ]; then
        docker ps -a | head -n 30
    else
        docker ps -a | grep $1
    fi;
}


function docker-images-remove-untagged () {
    docker images -f "dangling=true" -q | xargs docker rmi
}


function stop-containers () {
    # by default - filterout data containers
    docker-ps-filter-data-containers $1
    docker stop $(docker-ps-filter-data-containers $1 | awk '{ print $1 }')
}


function rm-containers () {
    # by default - filterout data containers
    docker-ps-filter-data-containers $1
    docker rm $(docker-ps-filter-data-containers $1 | awk '{ print $1 }')
}


function inspect-container () {
    docker inspect $1
}


function dump-database () {
    CONTAINER_NAME=$1
    if [ "$CONTAINER_NAME" == "" ]; then
        echo 'You need to specify container name'
        return
    fi
    DUMP_FILE=$2
    if [ "$DUMP_FILE" == "" ]; then
        DUMP_FILE=$CONTAINER_NAME"_dump.sql"
    fi
    DB_NAME=$3
    if [ "$DB_NAME" == "" ]; then
        DB_NAME=postgres
    fi
    echo $DUMP_FILE
    docker exec $CONTAINER_NAME su - postgres -c 'pg_dump $DB_NAME' > $DUMP_FILE
}


function go-into () {
    if [ "$2" = "" ]; then
        shell="bash"
    else
        shell="$2"
    fi
    docker exec -it $1 "$shell"
}


function attach-to () {
    docker attach --sig-proxy=false $1
}


function cleanup-containers () {
    docker ps -a | grep 'Exited (' | grep -v data | tail -n +1 | awk '{ print $1}' | xargs docker rm
}
