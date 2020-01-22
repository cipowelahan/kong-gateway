#!/bin/bash
set -e

echo "Create Migration Konga"

docker run --rm --network kong-network \
    pantsel/konga:latest \
    -c prepare \
    -a postgres \
    -u postgresql://kong:kong@postgresdb:5432/konga