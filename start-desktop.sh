#!/bin/bash
set -e

export DISPLAY=:0

echo "🚀 Starting virtual desktop environment..."
echo "Press Ctrl+C to stop everything cleanly."

# 終了時に全プロセスを安全に止める関数
cleanup() {
  echo ""
  echo "🛑 Stopping all processes..."
  pkill Xvfb || true
  pkill x11vnc || true
  pkill websockify || true
  pkill xfce4 || true
  echo "✅ All stopped. Bye!"
  exit 0
}
trap cleanup SIGINT SIGTERM

# 仮想ディスプレイ起動
Xvfb :0 -screen 0 1280x800x16 &
sleep 2

# デスクトップ起動（dbus経由）
if ! command -v dbus-launch >/dev/null 2>&1; then
  echo "Installing dbus-x11..."
  sudo apt update && sudo apt install -y dbus-x11
fi
dbus-launch startxfce4 &
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
