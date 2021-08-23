#!/bin/bash

## CRIANDO VOLUMES
docker volume ls | grep portainer_data
if [ $? -eq 0 ]; then
	echo ""
else
	docker volume create portainer_data
fi

## CRIANDO CONTAINER PORTAINER
docker run -d \
  --name portainer \
  --restart=always \
  -p 8000:8000 \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
portainer/portainer
