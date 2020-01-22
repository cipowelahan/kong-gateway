#!/bin/bash

echo "Create Migration Konga"

docker run --rm --network kong-net \
    pantsel/konga:latest -c prepare -a postgres -u postgresql://kong:kong@db:5432/konga_db