#!/bin/bash
set -e

conn="check"

echo "Waiting Connection ...."

while [ "$conn" != "accepting" ]
do
    conn=$(echo $(docker exec -ti postgres-db pg_isready -U kong | awk '{print $3}' | sed 's/ //g'))
    sleep 1
done

sleep 5