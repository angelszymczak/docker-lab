#!/bin/bash
docker create --name web01 helloworld
docker start web01
docker inspect web01
