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

## CRIAR BANCO DE DADOS NO CONTAINER DB-MYSQL
echo "CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
exit" > /tmp/db.sql

cat /tmp/db.sql | docker exec -i db-mysql mysql -u root --password=eli0606ef >> /dev/null
rm -rf /tmp/db.sql

## CRIANDO CONTAINER ZABBIX SERVER
docker run -d --name zabbix-server \
  --hostname zabbix-server \
  --restart always \
  -p 10051:10051 \
  --link db-mysql:mysql \
  -e DB_SERVER_HOST="mysql" \
  -e DB_SERVER_PORT="3306" \
  -e MYSQL_USER="root" \
  -e MYSQL_PASSWORD="eli0606ef" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  --mount type=volume,src=zabbix-server-files,dst=/usr/lib/zabbix \
zabbix/zabbix-server-mysql

## CRIANDO CONTAINER ZABBIX WEB
docker run -d --name zabbix-web \
  --restart always \
  -p 280:80 \
  -p 2443:443 \
  --link db-mysql:mysql \
  --link zabbix-server:zbxserver \
  -e DB_SERVER_HOST="mysql" \
  -e DB_SERVER_PORT="3306" \
  -e MYSQL_USER="root" \
  -e MYSQL_PASSWORD="eli0606ef" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e ZBX_SERVER_HOST="zbxserver" \
  -e PHP_TZ="America/Sao_Paulo" \
zabbix/zabbix-web-apache-mysql

## CRIANDO CONTAINER ZABBIX AGENT
docker run -d --name zabbix-agent \
  --hostname "$(hostname)" \
  --privileged \
  -v /:/rootfs \
  -v /var/run:/var/run \
  --restart always \
  -p 10050:10050 \
  -e ZBX_HOSTNAME="$(hostname)" \
  --link zabbix-server:zbxserver \
  -e ZBX_SERVER_HOST="zbxserver" \
zabbix/zabbix-agent

## CRIANDO CONTAINER DO GRAFANA
docker run -d --name grafana \
  --restart always \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
grafana/grafana
