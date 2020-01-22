#!/bin/bash
set -e

if [ "$1" = "down" ]; then
    echo "remove service... [started]"
    echo "progressing on --| removing kong-stack"
    docker-compose -f kong-stack.yml down \
        && echo "kong-stack removed!" \
        || echo "failed to remove kong-stack"
    echo "..."
    echo "progressing on --| removing db-stack"
    docker-compose -f db-stack.yml down \
        && echo "db-stack removed!" \
        || echo "failed to remove db-stack"
    echo "..."
    echo "removing unused bridge docker network"
    docker network rm kong-local \
        && echo "unused network has been removed!" \
        || echo "failed to remove docker network bridge kong-local"
    echo "all service has been [down]"
else
    echo "deploy service... [started]"
    echo "creating dynamic bridge docker networks"
    docker network create kong-local \
        && echo "network kong-local successfully created!" \
        || echo "failed to [create] kong-local network"
    
    echo "progressing on --| deploy db-stack"
    docker-compose -f db-stack.yml up -d \
        && echo "db-stack successfully deployed!" \
        || echo "failed to deploy [DB-STACK]"
    
    echo "...checking DB connection:" && \
        sh check-connection-db.sh \
        && echo "DB connection is [ready to connect]" \
        || echo "[DB] connection fail!"

    echo "...migrating kong-service:" \
        && sh migration-kong.sh \
        && echo "kong-service db migrated!" \
        || echo "[KONG-SERVICE] migrate fails"
        
    echo "...migrating konga-service" \
        && sh migration-konga.sh \
        && echo "konga-service db migrated!" \
        || echo "[KONGA-SERVICE] migrate fails"

    echo "...progressing on --| kong-stack"
    docker-compose -f kong-stack.yml up -d \
        && echo "kong-stack successfully deployed!" \
        || echo "failed to deploy [KONG-STACK]"

    echo "listing service:"
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi