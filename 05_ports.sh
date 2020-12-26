#!/bin/bash
docker rm web01 -f

docker create -p 8080:80 --name web01 helloworld
docker start web01

output=$(curl localhost:8080)
echo "curl localhost:8080"
echo "$output"
