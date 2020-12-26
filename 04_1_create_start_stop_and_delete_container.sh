#!/bin/bash

# Basic container commands
echo "Creating container"
container_id=$(docker create helloworld)

echo "Starting container"
docker start $container_id

# KILL -15 SIGNAL -> Ordered turn off -> Save & Close
echo "Stopping container"
docker stop $container_id

echo "Deleting container"
docker rm $container_id


# Deleting started container
echo "Creating a new container"
container_id=$(docker create helloworld)

echo "Starting the new container"
docker start $container_id

echo "Deleting the new started container"
docker rm $container_id -f


