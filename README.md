# instant-misskey

これは、[Misskey Advent Calendar 2023](https://adventar.org/calendars/8742) 23日目の記事([ねこでもわかるMisskeyサーバーの建て方](https://blog.chikage.net/misskey-advent-calender-2023/))のためのリポジトリです。

2025年11月22日追記：このリポジトリは作者のやる気の問題で放置され気味です。自己責任で利用してください。

## 使い方

```
git clone https://github.com/chikage8640/instant-misskey.git
cd instant-misskey
./config.sh
sudo docker compose up -d
```

あとはDNSの設定とかいろいろしてください。詳しいことは本編の記事に書いてあります。

## 謝辞
このソースを書くに当たって、様々なMisskey関連リソースを使用させていただきました。  
MisskeyはAGPL-3.0で、Misskey HubはMIT Licenseの下で公開されているとのことですが、ライセンスの掲示に加えて、全てのMisskey開発に携わる方への敬意をこの場を借りて示させていただきます。

このプロジェクトに含まれる/nginx/default.configは、[Nginxの設定 | Misskey Hub](https://misskey-hub.net/docs/admin/nginx.html)をベースとし、mTLS・SSLの設定を書き加えて使用させていただいています。  

Misskey Hub
https://misskey-hub.net/
https://github.com/misskey-dev/misskey-hub

MIT License

Copyright (c) 2021 2022 2023 syuilo and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
