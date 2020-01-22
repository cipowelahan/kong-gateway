#!/bin/bash

if [ "$1" = "down" ]; then
    echo "down"
    docker-compose -f kong-stack.yml down
    docker-compose -f db-stack.yml down
else
    echo "up"
    docker-compose -f db-stack.yml up -d
    sh check-connection-db.sh
    sh migration-kong.sh
    sh migration-konga.sh
    docker-compose -f kong-stack.yml up -d
fi

