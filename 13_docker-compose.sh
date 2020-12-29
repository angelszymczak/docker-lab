#!/bin/bash

docker images
# REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
# helloworld   4.0       448225be5114   36 hours ago   192MB
# helloworld   latest    448225be5114   36 hours ago   192MB
# ubuntu       18.04     2c047404e52d   4 weeks ago    63.3MB

docker-compose up
# Creating network "helloworld_default" with the default driver
# Pulling web (nginx:latest)...
# latest: Pulling from library/nginx
# 6ec7b7d162b2: Pull complete
# cb420a90068e: Pull complete
# 2766c0bf2b07: Pull complete
# e05167b6a99d: Pull complete
# 70ac9d795e79: Pull complete
# Digest: sha256:4cf620a5c81390ee209398ecc18e5fb9dd0f5155cd82adcbae532fec94006fb9
# Status: Downloaded newer image for nginx:latest
# Creating helloworld_web_1 ... done
# Attaching to helloworld_web_1
# web_1  | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
# web_1  | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
# web_1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
# web_1  | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
# web_1  | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
# web_1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
# web_1  | /docker-entrypoint.sh: Configuration complete; ready for start up

# Docker before download the nginx image
docker images
# REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
# helloworld   4.0       448225be5114   36 hours ago   192MB
# helloworld   latest    448225be5114   36 hours ago   192MB
# nginx        latest    ae2feff98a0c   13 days ago    133MB <----
# ubuntu       18.04     2c047404e52d   4 weeks ago    63.3MB

docker ps -a
# CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                      PORTS                  NAMES
# fd45bb50842c   nginx:latest        "/docker-entrypoint.…"   57 seconds ago   Up 56 seconds               0.0.0.0:8080->80/tcp   helloworld_web_1 <--
#
# The container name was formed by {directory_pattern_name}_{service_name}_{1:+}

# As you can see, the build image has a downloaded Ngnix welcome page that was defined on the docker-conpose.yml (saved as .)
curl localhost:8080
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>

docker-compose logs -f
# web_1  | 172.18.0.1 - - [29/Dec/2020:04:37:47 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.58.0" "-"

docker-compose stop
# Stopping helloworld_web_1 ... done

docker-compose rm
# Going to remove helloworld_web_1
# Are you sure? [yN] y <---------------------------
# Removing helloworld_web_1 ... done

# We added a single helloworld Dockerfile inside ./code/ directory, it Dockerfile has simliar helloworld:2.0 code
docker-compose build
# Building web
# Step 1/5 : FROM ubuntu:18.04
#  ---> 2c047404e52d
# Step 2/5 : RUN apt-get update
#  ---> Using cache
#  ---> 013a33707b28
# Step 3/5 : RUN apt-get install nginx -y
#  ---> Using cache
#  ---> 617e354f22bf
# Step 4/5 : RUN echo 'hello world' > /var/www/html/index.html
#  ---> Running in 1ff30224d662
# Removing intermediate container 1ff30224d662
#  ---> 7a582ef7474d
# Step 5/5 : CMD nginx -g 'daemon off;'
#  ---> Running in 0929f2431b58
# Removing intermediate container 0929f2431b58
#  ---> 91fe6c9a7dc9
#
# Successfully built 91fe6c9a7dc9
# Successfully tagged helloworld_web:latest

docker images
# REPOSITORY       TAG       IMAGE ID       CREATED         SIZE
# helloworld_web   latest    91fe6c9a7dc9   2 minutes ago   158MB <-----
# helloworld       4.0       448225be5114   37 hours ago    192MB
# helloworld       latest    448225be5114   37 hours ago    192MB
# nginx            latest    ae2feff98a0c   13 days ago     133MB
# ubuntu           18.04     2c047404e52d   4 weeks ago     63.3MB
#
# The image name was formed by {directory_pattern_name}_{service_name} (without index number, it will be added on container running)

docker-compose up -d
# Creating helloworld_web_1 ... done

docker ps -a
# CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                      PORTS                  NAMES
# ae15673e4fc2   helloworld_web      "/bin/sh -c 'nginx -…"   37 minutes ago   Up 37 minutes               0.0.0.0:8080->80/tcp   helloworld_web_1
# 2a80aee43093   helloworld:latest   "/bin/sh -c 'supervi…"   37 hours ago     Exited (137) 25 hours ago                          web01

# Response from custom ./code/Dockerfile
curl localhost:8080
# hello world

