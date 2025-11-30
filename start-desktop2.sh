#!/bin/bash
set -e

# 依存関係のチェックとインストール
# xfce4 を lxqt に変更
REQUIRED_PACKAGES="xvfb lxqt x11vnc websockify novnc dbus-x11"
PACKAGES_TO_INSTALL=""

for pkg in $REQUIRED_PACKAGES; do
  # パッケージ名とコマンド名が違う場合に対応
  if [ "$pkg" = "lxqt" ]; then
    command_to_check="startlxqt"
  elif [ "$pkg" = "dbus-x11" ]; then
    command_to_check="dbus-launch"
  else
    command_to_check="$pkg"
  fi
  
  if ! command -v $command_to_check &> /dev/null; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL $pkg"
  fi
done

if [ -n "$PACKAGES_TO_INSTALL" ]; then
  echo "📦 必要なパッケージをインストールしています... ($PACKAGES_TO_INSTALL )"
  sudo apt-get update
  sudo apt-get install -y $PACKAGES_TO_INSTALL
  echo "✅ インストールが完了しました。"
fi

export DISPLAY=:0

echo "🚀 Starting virtual desktop environment (LXQt)..."
echo "Press Ctrl+C to stop everything cleanly."

# 終了時に全プロセスを安全に止める関数
cleanup() {
  echo ""
  echo "🛑 Stopping all processes..."
  pkill Xvfb || true
  pkill x11vnc || true
  pkill websockify || true
  # xfce4 を lxqt-session に変更
  pkill lxqt-session || true
  echo "✅ All stopped. Bye!"
  exit 0
}
trap cleanup SIGINT SIGTERM

# 仮想ディスプレイ起動
Xvfb :0 -screen 0 1280x800x16 &
sleep 2

# デスクトップ起動（dbus経由）
# startxfce4 を startlxqt に変更
dbus-launch startlxqt &
sleep 5

# VNCサーバー起動
x11vnc -display :0 -forever -nopw -listen localhost -xkb &
sleep 2

# noVNC起動
echo "🌐 Launching noVNC on port 6080..."
websockify --web /usr/share/novnc/ 6080 localhost:5900 &

echo "✅ Desktop running! Access it via:"
echo "👉 https://<your-codespace>-6080.app.github.dev/vnc.html"
echo "💡 Press Ctrl+C here to stop when finished."

# wait でバックグラウンドジョブを監視
wait
