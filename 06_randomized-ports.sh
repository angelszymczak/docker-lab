#!/bin/bash
docker rm web01 -f

docker run -d -P --name web01 helloworld
docker start web01

docker inspect web01
docker rm -f web01
