#!/usr/bin/env bash

set -e;
set -x;

docker build -t esvm-builder-base -f base/Dockerfile base
docker build -t esvm-builder-gradle -f gradle/Dockerfile gradle
docker build -t esvm-builder-maven -f maven/Dockerfile maven
node generate-config.js
docker-compose up --remove-orphans -d
COMPOSE_HTTP_TIMEOUT=1000 docker-compose logs -f