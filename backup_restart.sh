#!/bin/bash

cd `dirname $0`

# 引数が空なら終了する
if [ "$1" = "" ]; then
    echo "引数が空です。"
    exit 1
fi

# イメージをpullしてからコンテナを停止。その後、バックアップを取ってコンテナを再起動。いずれかがコケたら止まるようになっている。
docker compose pull &&\
docker compose build --no-cache warp &&\
docker compose down &&\
echo Backup start... &&\
XZ_OPT=-9 tar -Jcf - . | rclone rcat $1/$(date "+%Y_%m_%d_%H_%M_%S").tar.xz &&\
docker compose up -d
