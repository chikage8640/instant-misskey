#!/bin/bash

cd `dirname $0`

# Meilisearchのindexを聞く
echo "Meilisearchのindexを入力してください。(例: mi-example-com)"
read MEILISEARCH_INDEX

# UUIDを生成
UUID=$(cat /proc/sys/kernel/random/uuid)

# 設定ファイルをコピー
cp ./env/meilisearch.env.example ./env/meilisearch.env

# Meilisearchを有効化（コメントアウト解除）
sed -i -e '/#meilisearch:/, +5 s/^#//' ./misskey/config/default.yml
sed -i -e '/#  meilisearch:/, +12 s/^#//' ./compose.yaml

# 設定ファイルを書き換え
sed -i -e "s/meilisearch-UUID/$UUID/g" ./env/meilisearch.env
sed -i -e "s/  provider: sqlLike/  provider: meilisearch/g" ./misskey/config/default.yml
sed -i -e "s/example-tld/$MEILISEARCH_INDEX/g" ./misskey/config/default.yml
sed -i -e "s/meilisearch-UUID/$UUID/g" ./misskey/config/default.yml
