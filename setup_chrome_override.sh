#!/bin/bash

# このスクリプトは、'run-chrome.sh'を指すローカルな'google-chrome'コマンドをセットアップします。
# PATHの変更を現在のシェルに反映させるためには、単に実行するのではなく、sourceコマンドで読み込む必要があります。
# 使い方: source setup_chrome_override.sh

echo "binディレクトリにgoogle-chromeのシンボリックリンクを作成中..."
# リンクが既に存在する場合に上書きするために -f を使用します。
ln -sf ../run-chrome.sh ./bin/google-chrome

echo "スクリプトに実行権限を付与中..."
chmod +x ./bin/google-chrome
chmod +x ./run-chrome.sh

# binディレクトリへの絶対パスを取得します
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/bin" && pwd)"

# 現在のセッションのPATHの先頭にbinディレクトリを追加します
export PATH="$BIN_DIR:$PATH"

echo "セットアップが完了しました！"
echo "これ以降 'google-chrome' コマンドは、次の場所からスクリプトを実行します: $BIN_DIR"
echo "確認するには、'which google-chrome' を実行してください。"
