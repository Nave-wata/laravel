FROM php:8.3-fpm-bullseye

WORKDIR /var/www/html

ENV LANG="C.UTF-8"
ENV TZ="Asia/Tokyo"

RUN \
    # 各種パッケージのインストール
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libzip-dev \
        screen \
        sudo \
    ; \
    # キャッシュ削除
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* \
    ; \
    \
    # PHP拡張機能のインストール \
    docker-php-ext-install \
        pdo_mysql \
        zip \
    ; \
    \
    # 開発ユーザーの作成
    useradd -m -s /bin/bash dev ; \
    usermod -aG sudo dev \
    ; \
    \
    # 開発ユーザに sudo 権限を付与
    echo "" >> /etc/sudoers ; \
    echo "# Don't require password for sudo command for dev user" >> /etc/sudoers ; \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# composer, node のコピー
COPY --from=node:20.10.0-slim /usr/local /usr/local
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# 設定ファイルをコピー
COPY ./docker/app/php/php.ini  /usr/local/etc/php/php.ini
COPY ./docker/app/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# コンテナ作成時に実行するスクリプトをコピー
COPY ./docker/app/bin/containerCreate.sh /usr/local/bin/containerCreate.sh

# コンテナ起動時に実行するスクリプトをコピー
COPY ./docker/app/bin/containerStart.sh /usr/local/bin/containerStart.sh

# コピーしたスクリプトに実行権限を付与
RUN chmod +x /usr/local/bin/containerCreate.sh ; \
    chmod +x /usr/local/bin/containerStart.sh

# 開発ユーザーに切り替え
USER dev

# コンテナ起動時に実行するスクリプトを実行
CMD ["/bin/bash", "-c", "containerStart.sh"]
