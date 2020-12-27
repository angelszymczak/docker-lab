#!/bin/bash

# Let's test a container
docker create --name web01 -P helloworld:latest
docker start web01

# You can see that nginx is running on COMMAND column
docker ps
# CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS         PORTS                   NAMES
# ec29e500e96d   helloworld:latest   "/bin/sh -c 'nginx -…"   29 seconds ago   Up 3 seconds   0.0.0.0:49153->80/tcp   web01

# You can see on docker process that
# - PID 1 initial Bash process triggered by CMD command on Dockerfile 
# - PID 7-11 Nginx processes that are Bash PID 1's son child process
docker exec -it web01 bash
ps aux
# USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root          1  0.0  0.0   4632   828 ?        Ss   15:26   0:00 /bin/sh -c nginx -g 'daemon off;'
# root          7  0.0  0.2 141120 11052 ?        S    15:26   0:00 nginx: master process nginx -g daemon off;
# www-data      8  0.0  0.0 141496  3560 ?        S    15:26   0:00 nginx: worker process
# www-data      9  0.0  0.0 141496  3560 ?        S    15:26   0:00 nginx: worker process
# www-data     10  0.0  0.0 141496  3560 ?        S    15:26   0:00 nginx: worker process
# www-data     11  0.0  0.0 141496  3560 ?        S    15:26   0:00 nginx: worker process
# root         12  1.0  0.0  18512  3288 pts/0    Ss   15:28   0:00 bash
# root         22  0.0  0.0  34408  2880 pts/0    R+   15:28   0:00 ps aux

# Clean it
docker rm web01 -f

# Supervisor is a Control and Monitoring Process System.
# With supervisor we can improve Docker limitation that allow just only one procces running within container.
# In this way supervisor will be main process that will be orchesting between different services that out container needs.
# An Supervisor can monitoring a running container and also can set re-start on container's failures.

# Create supervisor
mkdir supervisor
nano supervisor/supervisor_services.conf
# [program:nginx]
# command=/usr/sbin/nginx -g 'daemon off;'
# autostart=true
# autorestar=true

# Update Dockerfile
nano Dockerfile
# Add supervisor installer
# Update index message 'hello world 4.0'
# Add supervisor services configuration to image fylesystem
# Update CMD to launch docker main process from supervisor

# Build your image
docker build -t helloworld:4.0 .

# Tag new versions
docker tag helloworld:4.0 helloworld:latest 
docker tag helloworld:4.0 angelfreya/helloworld:4.0 
docker tag helloworld:4.0 angelfreya/helloworld:latest

# Push to DockerHub repository
docker push angelfreya/helloworld:4.0 
docker push angelfreya/helloworld:latest

# Let's test our new image with supervisor
docker create --name web01 -P helloworld:latest
docker start web01
curl localhost:49157
# hello world 4.0


# You can see that supervisor is running on COMMAND column
docker ps
# CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS         PORTS                   NAMES
# 2a80aee43093   helloworld:latest   "/bin/sh -c 'supervi…"   10 seconds ago   Up 4 seconds   0.0.0.0:49157->80/tcp   web01

# You can see on docker process that supervisor tis running with PIDon COMMAND column
# - PID 1 initial Supervisor process
# - PID 7 Setup conf supervisor
# - 10-14 Nginx processes are Supervisor childs
docker exec -it web01 bash
ps aux
# USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root          1  0.0  0.0   4632   768 ?        Ss   16:10   0:00 /bin/sh -c supervisord -n -c /etc/supervisor/supervisord.conf
# root          7  0.1  0.5  55464 20264 ?        S    16:10   0:00 /usr/bin/python /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
# root         10  0.0  0.2 141120 10696 ?        S    16:10   0:00 nginx: master process /usr/sbin/nginx -g daemon off;
# www-data     11  0.0  0.0 141496  3584 ?        S    16:10   0:00 nginx: worker process
# www-data     12  0.0  0.0 141496  3584 ?        S    16:10   0:00 nginx: worker process
# www-data     13  0.0  0.0 141496  3584 ?        S    16:10   0:00 nginx: worker process
# www-data     14  0.0  0.0 141496  3584 ?        S    16:10   0:00 nginx: worker process
# root         15  0.0  0.0  18512  3432 pts/0    Ss   16:11   0:00 bash
# root         29  0.0  0.0  34408  2772 pts/0    R+   16:11   0:00 ps aux

# Since Nginx process is monitoring by Supervisor
# if you kill Nginx process, Supervisor process will restart it automartically
ps -A 
# PID TTY          TIME CMD
# 1 ?        00:00:00 sh
# 7 ?        00:00:00 supervisord
# 10 ?        00:00:00 nginx
# 11 ?        00:00:00 nginx
# 12 ?        00:00:00 nginx
# 13 ?        00:00:00 nginx
# 14 ?        00:00:00 nginx
# 31 pts/0    00:00:00 bash
# 42 pts/0    00:00:00 ps
pkill nginx
ps -A
# PID TTY          TIME CMD
# 1 ?        00:00:00 sh
# 7 ?        00:00:00 supervisord
# 31 pts/0    00:00:00 bash
# 44 ?        00:00:00 nginx
# 45 ?        00:00:00 nginx
# 46 ?        00:00:00 nginx
# 47 ?        00:00:00 nginx
# 48 ?        00:00:00 nginx
# 49 pts/0    00:00:00 ps

# Even you can see the processes Supervisor logs (don't confuse with Nginx access logs)
#
tail -f /var/log/supervisor/
# nginx-stderr---supervisor-RgfOou.log  supervisord.log
# nginx-stdout---supervisor-G5D_Th.log  
#
tail -f /var/log/supervisor/*
# ==> /var/log/supervisor/nginx-stderr---supervisor-RgfOou.log <==
#
# ==> /var/log/supervisor/nginx-stdout---supervisor-G5D_Th.log <==
# 
# ==> /var/log/supervisor/supervisord.log <==
# 2020-12-27 16:10:11,578 CRIT Supervisor running as root (no user in config file)
# 2020-12-27 16:10:11,578 INFO Included extra file "/etc/supervisor/conf.d/supervisor_services.conf" during parsing
# 2020-12-27 16:10:11,585 INFO RPC interface 'supervisor' initialized
# 2020-12-27 16:10:11,585 CRIT Server 'unix_http_server' running without any HTTP authentication checking
# 2020-12-27 16:10:11,585 INFO supervisord started with pid 7
# 2020-12-27 16:10:12,591 INFO spawned: 'nginx' with pid 10
# 2020-12-27 16:10:13,664 INFO success: nginx entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
# 2020-12-27 16:17:39,107 INFO exited: nginx (exit status 0; expected)
# 2020-12-27 16:17:40,112 INFO spawned: 'nginx' with pid 44
# 2020-12-27 16:17:41,149 INFO success: nginx entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
# 
# In Nginx access log you can check the previous test 
tail -f /var/log/nginx/*
# ==> /var/log/nginx/access.log <==
# 172.17.0.1 - - [27/Dec/2020:16:22:45 +0000] "GET / HTTP/1.1" 200 16 "-" "curl/7.58.0"
#
# ==> /var/log/nginx/error.log <==
