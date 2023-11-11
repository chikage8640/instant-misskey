#!/bin/bash

cd `dirname $0`

# 運用するドメインを聞く
echo "Misskeyを運用するドメインを入力してください。(例: mi.example.com)"
read DOMAIN

# Meilisearchのindexを聞く
echo "Meilisearchのindexを入力してください。(例: mi-example-com)"
read MEILISEARCH_INDEX

# Postgresのパスワードを聞く
echo "PostgreSQLのパスワードを入力してください。"
read POSTGRES_PASSWORD

# UUIDを生成
UUID=$(cat /proc/sys/kernel/random/uuid)

# 設定ファイルをコピー
cp ./env/meilisearch.env.example ./env/meilisearch.env
cp ./env/postgres.env.example ./env/postgres.env
cp ./misskey/config/default.yml.example ./misskey/config/default.yml
sudo cp ./nginx/default.conf.example ./nginx/default.conf

# 設定ファイルを書き換え
sed -i -e "s/meilisearch-UUID/$UUID/g" ./env/meilisearch.env
sed -i -e "s/POSTGRES_PASSWORD=example_password/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/g" ./env/postgres.env
sed -i -e "s/example.tld/$DOMAIN/g" ./misskey/config/default.yml
sed -i -e "s/example-tld/$MEILISEARCH_INDEX/g" ./misskey/config/default.yml
sed -i -e "s/meilisearch-UUID/$UUID/g" ./misskey/config/default.yml
sed -i -e "s/pass: example_password/pass: $POSTGRES_PASSWORD/g" ./misskey/config/default.yml
sudo sed -i -e "s/example.tld/$DOMAIN/g" ./nginx/default.conf

# 証明書のディレクトリを作成
sudo mkdir -p ./nginx/certs

# 証明書を開く
echo "SSL証明書を編集しますか？(Y/n)"
read answer
if [ "$answer" != "n" ]; then
    read -p "サーバー証明書を開きます。(キーを押して続行)"
    sudo nano ./nginx/certs/fullchain.pem
    sudo chmod 600 ./nginx/certs/fullchain.pem
    read -p "プライベートキーを開きます。(キーを押して続行)"
    sudo nano ./nginx/certs/privkey.pem
    sudo chmod 600 ./nginx/certs/privkey.pem
fi

# Cloudflareのオリジンプル用証明書のダウンロード
echo "Cloudflareのオリジンプル用証明書をダウンロードしますか？(Y/n)"
read answer
if [ "$answer" != "n" ]; then
    sudo curl https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem -o ./nginx/certs/authenticated_origin_pull_ca.pem
fi

