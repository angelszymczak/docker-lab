docker-compose build
docker-compose up -d

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

docker exec -it lab_db_1 bash
mysql -uroot -ppassw0rd

use users;
select * from user; 
# +------+----------+
# | ID   | username |
# +------+----------+
# |    0 | miguel   |
# |    1 | Linus    |
# +------+----------+

insert into user values(2, "Angel");
# Query OK, 1 row affected (0.001 sec)

select * from user; 
# +------+----------+
# | ID   | username |
# +------+----------+
# |    0 | miguel   |
# |    1 | Linus    |
# |    2 | Angel    |
# +------+----------+


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
#	<tr>
#		<td>2</td>
#		<td>Angel</td>
#	</tr>
# </table>
