#!/bin/bash

# Create new volume
docker volume create my-volume

# List volumes
docker volume ls

# Inspect created volume
docker volume inspect my-volume
# =>
#[
#    {
#        "CreatedAt": "2020-12-26T05:06:11-08:00",
#        "Driver": "local",
#        "Labels": {},
#        "Mountpoint": "/var/lib/docker/volumes/my-volume/_data",
#        "Name": "my-volume",
#        "Options": {},
#        "Scope": "local"
#    }
#]

# By the Mountpoint we can see where is the shared data, it should looks empty
sudo ls /var/lib/docker/volumes/my-volume/_data

# The start the container with attached volume to container
docker create -P --mount source=my-volume,target=/var/www/html --name web01 helloworld:latest
docker start web01

# And we can see the container creation with attached volume was placed new files
sudo ls /var/lib/docker/volumes/my-volume/_data
# =>
# index.html  index.nginx-debian.html

# Start container
docker port web01

# Since we used -P param we don't know which port open is container running
host1=$(docker port web01 80/tcp)
curl $host1

# Since you can see where is data, you can edit index.html to "hello world from volume"
sudo echo "hello world from volume" | sudo tee /var/lib/docker/volumes/my-volume/_data/index.html
curl $host1

# We can delete started container but the data was been persisted on volume
docker rm web01 -f
sudo ls /var/lib/docker/volumes/my-volume/_data
# =>
# index.html  index.nginx-debian.html

# Then we can create and start new container and attached this volume with previous data
docker create -P --mount source=my-volume,target=/var/www/html --name web02 helloworld:latest
host1=$(docker port web02 80/tcp)
curl $host1

# Prune delete all volume that not been using
docker volume create my-volume-2
docker volume create my-volume-3

docker volume ls
# =>
# DRIVER    VOLUME NAME
# local     my-volume
# local     my-volume-2
# local     my-volume-3

docker volume prune
# =>
# WARNING! This will remove all local volumes not used by at least one container.
# Are you sure you want to continue? [y/N] y
# Deleted Volumes:
# my-volume-2
# my-volume-3
#
# Total reclaimed space: 0B

# clean
docker rm web02
docker volume rm my-volume

