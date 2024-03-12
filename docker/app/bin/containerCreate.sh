#!/usr/bin/env bash

# .envファイルが存在しない場合
if [ ! -e "/var/www/html/.env" ]; then
    cp /var/www/html/.env.example /var/www/html/.env
fi

# 開発で使用するPHPやNodeのパッケージのインストール
composer install
npm install

# laravel を動作させるためのコマンドの実行
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan storage:link
