#!/usr/bin/env bash

# containerCreate.shが存在していれば実行（コンテナ作成時に実行）
if [ -e "/usr/local/bin/containerCreate.sh" ]; then
    # 繰り返し
    while true; do
        # db:3306の接続を確認
        curl db:3306
        if [ $? -eq 1 ]; then
            break
        fi

        # 1秒待機
        sleep 1
    done

    # containerCreate.shを実行
    /usr/local/bin/containerCreate.sh

    # containerCreate.shをロック
    sudo mv /usr/local/bin/containerCreate.sh /usr/local/bin/containerCreate.sh.lock
    sudo chmod 644 /usr/local/bin/containerCreate.sh.lock
fi

# 死んだセッションを削除
screen -wipe

# vite セッションを作成
screen -dmS vite

# vite セッションで開発 Node サーバーを起動
screen -S vite -X stuff ' \
    cd /var/www/html
    npm run dev
'

/usr/local/bin/docker-php-entrypoint php-fpm
