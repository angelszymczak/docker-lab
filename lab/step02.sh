#!/bin/bash

docker build -t python .

docker run --network lab -e db_host=db01 -e db_user=root -e MYSQL_ROOT_PASSWORD=passw0rd -e db_name=users --name python --rm -p 5000:5000 python:latest
#  * Serving Flask app "app" (lazy loading)
# * Environment: production
#   WARNING: This is a development server. Do not use it in a production deployment.
#   Use a production WSGI server instead.
# * Debug mode: off
# * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)

curl localhost:5000
# <table border="1">
#	<tr>
#		<td>ID</td>
#		<td>Name</td>
#	</tr>
#	<tr>
#		<td>0</td>
#		<td>miguel</td>
#	</tr>
#	<tr>
#		<td>1</td>
#		<td>Linus</td>
#	</tr>
# </table>

docker run -it --network lab --name test --rm mariadb mysql -hdb01 -uroot -ppassw0rd
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
# 1 row in set (0.000 sec)
# 
# MariaDB [users]> insert into user values(2, "warren");
# Query OK, 1 row affected (0.002 sec)
# 
# MariaDB [users]> select * from user;
# +------+----------+
# | ID   | username |
# +------+----------+
# |    0 | miguel   |
# |    1 | Linus    |
# |    2 | warren   |
# +------+----------+
# 3 rows in set (0.001 sec)
# 
# MariaDB [users]> exit
# Bye

angel@ubuntu:~/docker-lab/02_docker-getting-started/helloworld/lab/app$ docker stop python
# python

angel@ubuntu:~/docker-lab/02_docker-getting-started/helloworld/lab/app$ docker rm  db01 -f
# db01
