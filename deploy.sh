#!/bin/bash
set -e

flag_konga=true
flag_down=false

for arg in "$@"; do
    case $arg in
        --no-konga)
            flag_konga=false
            shift
            ;;
        --down)
            flag_down=true
            shift
            ;;
    esac
done


if [ $flag_down = true ]; then
    echo "remove service... [started]"

    konga=$(printf "$(docker ps -a | grep -w konga)")

    if [ "$konga" != "" ]; then
        echo "progressing on --| removing konga"
        docker stop konga \
            && echo "konga-service stopped" \
            || echo "konga-service failed to stopped"
        docker rm konga \
            && echo "konga-service removed" \
            || echo "konga-service failed to removed"
    fi

    echo "progressing on --| removing kong"
    docker stop kong \
        && echo "kong-service stopped" \
        || echo "kong-service failed to stopped"
    docker rm kong \
        && echo "kong-service removed" \
        || echo "kong-service failed to removed"

    echo "..."

    echo "progressing on --| removing db-stack"
    docker-compose -f stack/db-stack.yml down \
        && echo "db-stack removed!" \
        || echo "failed to remove db-stack"

    echo "..."

    echo "removing unused bridge docker network"
    docker network rm kong-network \
        && echo "unused network has been removed!" \
        || echo "failed to remove docker network bridge kong-local"
    echo "all service has been [down]"
else
    echo "deploy service... [started]"
    echo "creating dynamic bridge docker networks"
    docker network create kong-network \
        && echo "network kong-local successfully created!" \
        || echo "failed to [create] kong-local network"
    
    echo "progressing on --| deploy db-stack"
    docker-compose -f stack/db-stack.yml up -d \
        && echo "db-stack successfully deployed!" \
        || echo "failed to deploy [DB-STACK]"
    
    echo "...checking DB connection:" && \
        sh script/check-connection-db.sh \
        && echo "DB connection is [ready to connect]" \
        || echo "[DB] connection fail!"

    echo "...migrating kong-service:" \
        && sh script/migration-kong.sh \
        && echo "kong-service db migrated!" \
        || echo "[KONG-SERVICE] migrate fails"

    echo "...create kong-service:" \
        && sh script/kong.sh \
        && echo "kong-service created!" \
        || echo "[KONG-SERVICE] create fails"

    if [ $flag_konga = true ]; then
        echo "...migrating konga-service" \
            && sh script/migration-konga.sh \
            && echo "konga-service db migrated!" \
            || echo "[KONGA-SERVICE] migrate fails"

        echo "...create konga-service:" \
            && sh script/konga.sh \
            && echo "konga-service created!" \
            || echo "[KONGA-SERVICE] create fails"   
    fi

    echo "listing service:"
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
fi