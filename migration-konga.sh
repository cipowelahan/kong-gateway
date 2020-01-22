#!/bin/bash
set -e

echo "Create Migration Konga"

docker run --rm --net kong-local \
    pantsel/konga:latest -c prepare -a postgres -u postgresql://kong:kong@db:5432/konga_db