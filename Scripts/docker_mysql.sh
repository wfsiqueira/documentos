#!/bin/bash

## CRIANDO VOLUMES
docker volume ls | grep db-mysql
if [ $? -eq 0 ]; then
	echo ""
else
	docker volume create db-mysql
fi

## CRIANDO CONTAINER MYSQL
docker run -d --name db-mysql \
  --restart always \
  -p 3306:3306 \
  --hostname db-mysql \
  --mount type=volume,src=db-mysql,dst=/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=eli0606ef \
mysql:5.7
