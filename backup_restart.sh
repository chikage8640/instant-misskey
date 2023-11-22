#!/bin/bash

cd `dirname $0`

# RCLONEの設定名
RCLONE_NAME=r2
# RCLONEのルートディレクトリ名（オブジェクトストレージならバケット名）
RCLONE_ROOT_NAME=misskey-backup

# 引数がmonthly, weekly, dailyのいずれかでなければ終了
if [ "$1" != "monthly" ] && [ "$1" != "weekly" ] && [ "$1" != "daily" ]; then
    echo "Argument must be monthly, weekly or daily."
    exit 1
fi

# イメージをpullしてからコンテナを停止。その後、バックアップを取ってコンテナを再起動。いずれかがコケたら止まるようになっている。
docker compose pull &&\
docker compose build --no-cache warp &&\
docker compose down &&\
echo Backup start... &&\
XZ_OPT=-9 tar -Jcf - . | rclone rcat $RCLONE_NAME:$RCLONE_ROOT_NAME/$1/$(date "+%Y_%m_%d_%H_%M_%S").tar.xz &&\
docker compose up -d
