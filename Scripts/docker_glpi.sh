#!/bin/bash

## VARIAVEIS DE AMBIENTE
MYSQL_DATABASE="$1"
MYSQL_USER="$2"
MYSQL_PASSWORD="$3"

if [ $# -lt 1 ]; then
   echo ""
   echo "Não foi informado os argumentos para a criação do banco de dados!"
   echo ""
   exit 1
fi

## CRIANDO VOLUMES
docker volume ls | grep glpi-files
if [ $? -eq 0 ]; then
	echo ""
else
	docker volume create glpi-files
fi

## CRIAR BANCO DE DADOS NO CONTAINER DB-MYSQL
echo "CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
exit" > /tmp/db.sql

cat /tmp/db.sql | docker exec -i db-mysql mysql -u root --password=eli0606ef >> /dev/null
rm -rf /tmp/db.sql

## CRIANDO CONTAINER GLPI
docker run -dt --name glpi \
  --hostname glpi \
  --restart=always \
  --link db-mysql:mysql \
  --mount type=volume,src=glpi-files,dst=/var/www/html \
  -p 380:80 \
wsiqueira/glpi

