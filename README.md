# instant-misskey

これは、[Misskey Advent Calendar 2023](https://adventar.org/calendars/8742) 23日目の記事([なんもわからんけどMisskeyのサーバーを建てたい人のための話](https://blog.chikage.net/misskey-advent-calender-2023/))のためのプロジェクトです。  

## 使い方

```
git clone --recursive https://github.com/chikage8640/instant-misskey.git
cd instant-misskey
./config.sh
sudo docker compose up -d
```

あとはDNSの設定とかいろいろしてください。詳しいことは本編の記事に書いてあります。

## Meilisearchについて
Meilisearchは使わない前提で組んでいます。  
もし使う場合にはenable_meilisearch.shで有効化できますが、git pullできなくなるので自分で面倒見れる人だけでお願いします。