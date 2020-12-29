#!/bin/bash

docker network create lab
# 4faccf1ff03054d0c56daeeea9c6b1eb05e1904770d0841c0969d615ae963767

# We can set environment variables from container running
docker run --net lab --name db01 -e MYSQL_ROOT_PASSWORD=passw0rd -d mariadb:latest
# Unable to find image 'mariadb:latest' locally
# latest: Pulling from library/mariadb
# da7391352a9b: Pull complete 
# 14428a6d4bcd: Pull complete 
# 2c2d948710f2: Pull complete 
# 22776aa82430: Pull complete 
# 90e64230d63d: Pull complete 
# f30861f14a10: Pull complete 
# e8e9e6a3da24: Pull complete 
# 420a23f08c41: Pull complete 
# bd73f23de482: Pull complete 
# a8690a3260b7: Pull complete 
# 4202ba90333a: Pull complete 
# a33f860b4aa6: Pull complete 
# Digest: sha256:cdc553f0515a8d41264f0855120874e86761f7c69407b5cfbe49283dc195bea8
# Status: Downloaded newer image for mariadb:latest
# c23f81e96fa59390d6ca2d69030c4aeae02a11be88fce11150fb85df4d785be3

docker ps
# CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS      NAMES
# c23f81e96fa5   mariadb:latest   "docker-entrypoint.s…"   18 seconds ago   Up 16 seconds   3306/tcp   db01

docker exec -it db01 bash
env | grep MYSQL_ROOT_PASSWORD
# MYSQL_ROOT_PASSWORD=passw0rd

env | grep MARIADB            
# MARIADB_VERSION=1:10.5.8+maria~focal
# MARIADB_MAJOR=10.5

mysql -uroot -ppassw0rd
# Welcome to the MariaDB monitor.  Commands end with ; or \g.
# Your MariaDB connection id is 3
# Server version: 10.5.8-MariaDB-1:10.5.8+maria~focal mariadb.org binary distribution
#
# Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
#
# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
#
# Ctrl-C -- exit!
# Aborted

# We can connect to db01 mysql database from different ways
docker run -it --network lab --name test --rm mariadb mysql -hdb01 -uroot -ppassw0rd
# Welcome to the MariaDB monitor.  Commands end with ; or \g.
# Your MariaDB connection id is 3
# Server version: 10.5.8-MariaDB-1:10.5.8+maria~focal mariadb.org binary distribution
#
# Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
#
# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
#
# Ctrl-C -- exit!
# Aborted

# The MYSQL_ROOT_PASSWORD will be read from container env vars, and the command will import a single users db
docker exec -i db01 sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < dump/users.sql
docker run -it --network lab --name test --rm mariadb mysql -hdb01 -uroot -ppassw0rd
show databases;
# +--------------------+
# | Database           |
# +--------------------+
# | information_schema |
# | mysql              |
# | performance_schema |
# | users              |
# +--------------------+
# 4 rows in set (0.001 sec)
#
# MariaDB [(none)]> use users;
# Reading table information for completion of table and column names
# You can turn off this feature to get a quicker startup with -A
# 
# Database changed
# MariaDB [users]> show tables;        
# +-----------------+
# | Tables_in_users |
# +-----------------+
# | user            |
# +-----------------+
# 1 row in set (0.001 sec)
# 
# MariaDB [users]> select * from user;
# +------+----------+
# | ID   | username |
# +------+----------+
# |    0 | miguel   |
# |    1 | Linus    |
# +------+----------+
# 2 rows in set (0.001 sec)

