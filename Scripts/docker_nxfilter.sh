#!/bin/bash

## CRIANDO CONTAINER NXFILTER
docker run -dt  \
  --name nxfilter \
  -v nxfilter-conf:/nxfilter/conf \
  -v nxfilter-log:/nxfilter/log \
  -v nxfilter-db:/nxfilter/db \
  -p 180:80 \
  -p 1443:443 \
  -p 53:53/udp \
  -p 19002-19004:19002-19004 \
  --restart=always \
wsiqueira/nxfilter

