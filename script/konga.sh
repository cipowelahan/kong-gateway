#!/bin/bash
set -e

echo "Create Konga Service"

docker run -d --name konga \
     --network kong-network \
     -e "NODE_ENV=production" \
     -e "TOKEN_SECRET=loli-savior" \
     -e "DB_ADAPTER=postgres" \
     -e "DB_HOST=postgresdb" \
     -e "DB_USER=kong" \
     -e "DB_PASSWORD=kong" \
     -e "DB_DATABASE=konga" \
     -p 1337:1337 \
     pantsel/konga:latest