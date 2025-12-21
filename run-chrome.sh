#!/bin/bash

# 無限ループを防ぐため、実際のgoogle-chromeをフルパスで呼び出します。
# また、このスクリプトに渡されたすべての引数（"$@"）を実際のchromeコマンドに渡します。
/usr/bin/google-chrome --disable-gpu --disable-dev-shm-usage "$@"
