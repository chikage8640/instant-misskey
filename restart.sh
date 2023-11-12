#!/bin/bash

cd `dirname $0`

docker compose pull && \
docker compose down && \
docker compose up -d
