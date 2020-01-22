#!/bin/bash

conn="check"

echo "Waiting Connection ...."

while [ "$conn" != "accepting" ]
do
    conn=$(printf $(docker exec -ti postgres-db pg_isready -U kong | cut -d \- -f 2) -n)
done

echo "Connected To Database..."

sleep 10