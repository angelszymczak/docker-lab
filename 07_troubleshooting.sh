#!/bin/bash

docker run --name web01 -d -P helloworld

# A container is nothing more than a process that runs in an image context
docker exec web01 ls
docker exec web01 ps


# To have an interactive output
docker run -it web01 bash
