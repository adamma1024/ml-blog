#!/bin/bash
#deploy-dev.sh

git pull

# 强制重新编译容器
docker-compose down
docker-compose up -d --force-recreate --build