#!/bin/bash
# lidawake アンインストーラ — install.sh が入れた 4 点をすべて取り除く。
set -uo pipefail

BIN="$HOME/bin/lidawake"
PLIST_LABEL="com.lidawake.boot-reset"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"
SUDOERS_FILE="/etc/sudoers.d/lidawake"

info() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }

# 抑止が残っていればまず解除（sudoers が生きているうちに実行する）
if [[ -x "$BIN" ]]; then
  info "スリープ抑止を解除"
  "$BIN" off 2>/dev/null || true
fi

info "LaunchAgent を解除"
launchctl bootout "gui/$(id -u)" "$PLIST_PATH" 2>/dev/null || true
rm -f "$PLIST_PATH"

info "SwiftBar プラグインを削除"
plugin_dir="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
[[ -n "$plugin_dir" ]] && rm -f "${plugin_dir/#\~/$HOME}/lidawake.30s.sh"
open -g "swiftbar://refreshallplugins" 2>/dev/null || true

info "sudoers ルールを削除（管理者パスワードを求められます）"
sudo rm -f "$SUDOERS_FILE"

info "中核スクリプトと状態ファイルを削除"
rm -f "$BIN"
rm -rf "$HOME/.cache/lidawake"

info "アンインストール完了"
