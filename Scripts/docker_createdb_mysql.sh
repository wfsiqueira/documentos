#!/bin/bash

MYSQL_DATABASE="$1"
MYSQL_USER="$2"
MYSQL_PASSWORD="$3"

if [ $# -lt 1 ]; then
   echo ""
   echo "Não foi informado os argumentos para a criação do banco de dados!"
   echo "   Use ./docker_createdb_mysql.sh $database $user $password"
   echo ""
   exit 1
fi

echo "CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
exit" > /tmp/db.sql

cat /tmp/db.sql | docker exec -i db-mysql mysql -u root --password=eli0606ef >> /dev/null
rm -rf /tmp/db.sql
