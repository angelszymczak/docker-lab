#!/bin/bash

docker create --name test -P -e var1=value1 -e var2=value2 angelfreya/helloworld:latest
# =>
# d131c51c09a9099494ca1ccf5708e32505ed7eed1f06dbaff42ed32b43090e5b

docker start test
# =>
# test

# Notice that env command was executed by bash
docker exec -it test env
# =>
# HOSTNAME=d131c51c09a9
# PWD=/
# HOME=/root
# var1=value1
# var2=value2
# TERM=xterm
# SHLVL=1
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# _=/usr/bin/env

docker rm test -f
