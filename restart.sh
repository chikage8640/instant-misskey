#!/bin/bash

cd `dirname $0`

docker compose down
docker compose pull
docker compose up -d
