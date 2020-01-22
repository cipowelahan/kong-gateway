#!/bin/bash
set -e

echo "Create Migration Kong"

docker run --rm --net kong-local \
    -e KONG_DATABASE="postgres" \
    -e KONG_PG_HOST="db" \
    -e KONG_PG_DATABASE="kong" \
    -e KONG_PG_USER="kong" \
    -e KONG_PG_PASSWORD="kong" \
    kong:latest kong migrations bootstrap