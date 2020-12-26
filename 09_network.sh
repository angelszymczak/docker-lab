#!/bin/bash

docker network ls
# =>
# NETWORK ID     NAME      DRIVER    SCOPE
# 5792b740d53a   bridge    bridge    local => bridge: containers can see each other through this network
# f38e9cb8529b   host      host      local => host: containers can see host network through this network
# 0e2a81f827e5   none      null      local => null: containers without internet access, usefull for run arbitrary scripts secure-safe mode.

# Network setup
docker network create web01 --driver bridge
docker network inspect web01

docker network create web02 --driver bridge
docker network inspect web02

# Containers creation
docker create --name web01a --network web01 helloworld
docker create --name web02a --network web02 helloworld
docker create --name web01b --network web01 helloworld

docker start web01a web02a web01b
docker ps

# We can inspect the IP range betwen web01a and web01b are the same
# but web02a can not because is in another range.
docker inspect web01a | grep IPAddress
docker inspect web01b | grep IPAddress
docker inspect web02a | grep IPAddress
 
docker exec -it web01a bash
apt install curl
# here we can curl to previous filtered IPAddress
# and you will get "hello world" from web01b but timeoui from web02a
# so we can isolate containers
# if we have a vulneable app we can add an extra layer security isolate it.


# Cleaning
docker network ls
# NETWORK ID     NAME      DRIVER    SCOPE
# 5792b740d53a   bridge    bridge    local
# f38e9cb8529b   host      host      local
# 0e2a81f827e5   none      null      local
# a7ea5d44fb9d   web01     bridge    local
# 73a61ba0afdc   web02     bridge    local

docker network prune
# WARNING! This will remove all custom networks not used by at least one container.
# Are you sure you want to continue? [y/N] y

docker network ls
# NETWORK ID     NAME      DRIVER    SCOPE
# 5792b740d53a   bridge    bridge    local
# f38e9cb8529b   host      host      local
# 0e2a81f827e5   none      null      local
# a7ea5d44fb9d   web01     bridge    local
# 73a61ba0afdc   web02     bridge    local

docker rm web01a web01b web02a -f
# web01a
# web01b
# web02a

docker network prune
# WARNING! This will remove all custom networks not used by at least one container.
# Are you sure you want to continue? [y/N] y
# Deleted Networks:
# web01
# web02

# default docker networks
docker network ls
# NETWORK ID     NAME      DRIVER    SCOPE
# 5792b740d53a   bridge    bridge    local
# f38e9cb8529b   host      host      local
# 0e2a81f827e5   none      null      local

docker create --name web01 helloworld
# 429fc6a7f5ebd9425418b008c052cf2bbe9f0ec75859095f1734c1cf1a5259e8

docker start web01
# web01

docker inspect web01 | grep IPAddress
#           "SecondaryIPAddresses": null,
#           "IPAddress": "172.17.0.2",
#                   "IPAddress": "172.17.0.2",

docker network create test
# 8fa01e7810b63b03e8d0ded976f7fabb61905082f315315601699cb28fdfc55b

docker inspect test | grep subnet -i
#                   "Subnet": "172.20.0.0/16",

# You can connect container to network
docker network connect test web01
docker inspect web01 | grep IPAddress
#           "SecondaryIPAddresses": null,
#           "IPAddress": "172.17.0.2",
#                   "IPAddress": "172.17.0.2",
#                   "IPAddress": "172.20.0.2",

docker network disconnect test web01
docker inspect web01 | grep IPAddress
#           "SecondaryIPAddresses": null,
#           "IPAddress": "172.17.0.2",
#                   "IPAddress": "172.17.0.2",

docker rm web01 -f
# web01

docker network prune
# WARNING! This will remove all custom networks not used by at least one container.
# Are you sure you want to continue? [y/N] y
# Deleted Networks:
# test


