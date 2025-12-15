#!/bin/bash

cd `dirname $0`

# 運用するドメインを聞く
echo "Misskeyを運用するドメインを入力してください。(例: mi.example.com)"
read DOMAIN

# セットアップパスワードを聞く
echo "Misskeyの初期セットアップに使うパスワードを入力してください。"
read SETUP_PASSWORD

# Postgresのパスワードを聞く
echo "PostgreSQLのパスワードを入力してください。"
read POSTGRES_PASSWORD

# /misskey/fileの作成
sudo install -m 770 -o 991 -g 991 -d ./misskey/files

# 設定ファイルをコピー
cp ./env/postgres.env.example ./env/postgres.env
cp ./misskey/config/default.yml.example ./misskey/config/default.yml
cp ./compose.yaml.example ./compose.yaml
sudo cp ./nginx/default.conf.example ./nginx/default.conf

# 設定ファイルを書き換え
sed -i -e "s/POSTGRES_PASSWORD=example_password/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/g" ./env/postgres.env
sed -i -e "s/example.tld/$DOMAIN/g; s/# setupPassword: example_password_please_change_this_or_you_will_get_hacked/setupPassword: $SETUP_PASSWORD/g;  s/pass: example_password/pass: $POSTGRES_PASSWORD/g" ./misskey/config/default.yml
sudo sed -i -e "s/example.tld/$DOMAIN/g" ./nginx/default.conf

# Meilisearchの有効化をするか聞く
echo "Meilisearchを有効化しますか？(y/N)"
read answer
if [ "$answer" = "y" ]; then
    bash ./enable_meilisearch.sh
fi

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
echo "CloudflareのオリジンプルにmTLSを使用しますか？(Y/n)"
read answer
if [ "$answer" != "n" ]; then
    # ./nginx/default.confの「# To use mTLS」の後の2行をコメントアウトを解除
    sudo sed -i -e '/# To use mTLS/, +2 s/^#//' ./nginx/default.conf
    sudo curl https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem -o ./nginx/certs/authenticated_origin_pull_ca.pem
fi

# trustProxyについての注意喚起
echo
echo "このリポジトリに付属しているmisskeyの設定では、Cloudflareの背後で公開する前提でtrustProxyを2にしています。"
echo "trustProxyは、Misskeyがリバースプロキシの背後で動作していることを認識するための設定です。"
echo "Misskeyを運用する場合は、./misskey/config/default.ymlのtrustProxyの値をリバースプロキシの段数に変更してください。"
echo "例えばこのリポジトリの想定では、Cloudflare→Nginx(このスクリプトで自動的に構成されています。)→Misskeyの順でリクエストが来るため、trustProxyは2に設定されています。"