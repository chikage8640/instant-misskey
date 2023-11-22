#!/bin/bash

cd `dirname $0`

docker compose pull && \
docker compose build --no-cache warp &&\
docker compose down && \
docker compose up -d
