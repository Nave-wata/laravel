# laravel-template

Docker (docker compose) を使用した Laravel の開発環境テンプレートです。

## 使い方

### リポジトリの作成

1. **`Use this template`** -> **`Create a new repository`** でこのテンプレートをコピーしてリポジトリを作成
2. **`Include all branches`** にチェック
3. リポジトリ名などを入力後、**`Create repository`**

### ローカル環境の構築

1. [リポジトリの作成](#リポジトリの作成) 手順でコピーしたリポジトリをローカルにクローン

```bash
git clone <https://... | git@github.com:...>
```

2. クローンしたリポジトリに移動
```bash
cd <リポジトリ名>
```

3. `11.x` ブランチに切り替え
```bash
git checkout 11.x
```

4. アプリケーションを起動
```bash
docker compose up -d
```

アプリケーション: http://localhost
phpmyadmin: http://localhost:8080

### オプション

[Laravel 11.x がサポート](https://laravel.com/docs/11.x/releases#support-policy)する以下のPHPバージョンが利用できます。

- PHP 8.2（初期値）
- PHP 8.3

これらのバージョンは対象の docker compose ファイルを指定してコマンドを実行することで切り替えが可能です。
docker compose ファイルは以下の通りです。

```bash
docker/
...
├── compose.php8_2.yaml
├── compose.php8_3.yaml
```

PHPバージョンの切り替えには以下2つの方法が利用できます。

#### デフォルトの docker compose ファイルを書き換える方法

`docker compose` コマンド実行時には、`docker-compose.yaml (compose.yaml)` ファイルが自動的に指定した状態でコマンドが実行されます。
また、この場合、`docker-compose.override.yaml (compose.override.yaml)` ファイルも自動的に読み込まれ、内容が上書きされます。
この動作を利用して、以下のような手順で利用するPHPのバージョンを切り替えることができます。

1. `docker/compose.<使用したいPHPバージョン>.yaml` のファイル（中身）をコピー
2. プロジェクトルートに `compose.yaml` というファイルに貼り付け
3. 使用したいPHPバージョンで環境が利用できるようになる

#### docker compose ファイルを指定する方法

docker compose コマンドを実行する際に、以下のようにファイルを指定します。
この場合、コマンドのたびに `docker-compose.yaml (compose.yaml)` ファイルを指定する必要があります。

```bash
docker compose -f ./docker/compose.php8_2.yaml -f ./compose.override.yaml up -d
docker compose -f ./docker/compose.php8_3.yaml -f ./compose.override.yaml up -d
...
```
