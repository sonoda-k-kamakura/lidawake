#!/bin/bash
# lidawake インストーラ
# 中核スクリプト / sudoers ルール / 起動時リセット LaunchAgent / SwiftBar プラグイン / アンインストーラ
# の 5 点をこの順にセットアップする。再実行しても安全（冪等）。
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"
PLIST_LABEL="com.lidawake.boot-reset"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"
SUDOERS_FILE="/etc/sudoers.d/lidawake"
HOME_DIR="$HOME/.lidawake"

info()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m警告:\033[0m %s\n' "$*"; }
abort() { printf '\033[1;31mエラー:\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || abort "macOS 専用です"

# ----- 1. 中核スクリプト -----
info "中核スクリプトを ${BIN_DIR}/lidawake へインストール"
mkdir -p "$BIN_DIR"
install -m 0755 "$REPO_DIR/bin/lidawake" "$BIN_DIR/lidawake"

# ----- 2. sudoers ルール -----
# pmset disablesleep の on/off の 2 コマンドだけをパスワード無しで許可する。
# それ以外の sudo 権限は一切広げない。
info "sudoers ルールを ${SUDOERS_FILE} へインストール（管理者パスワードを求められます）"
tmp_sudoers="$(mktemp)"
trap 'rm -f "$tmp_sudoers"' EXIT
cat > "$tmp_sudoers" <<EOF
# lidawake: 蓋閉じスリープ抑止の切り替えのみパスワード無しで許可
$USER ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0
EOF
sudo visudo -c -f "$tmp_sudoers" >/dev/null || abort "sudoers の構文チェックに失敗しました"
sudo install -m 0440 -o root -g wheel "$tmp_sudoers" "$SUDOERS_FILE"

# ----- 3. 起動時リセット LaunchAgent -----
# 再起動をまたいで disablesleep=1 が残らないよう、ログイン時に状態を掃除する。
info "起動時リセット用 LaunchAgent を登録 (${PLIST_LABEL})"
mkdir -p "$HOME/Library/LaunchAgents"
sed "s|__HOME__|$HOME|g" "$REPO_DIR/launchd/${PLIST_LABEL}.plist.template" > "$PLIST_PATH"
launchctl bootout "gui/$(id -u)" "$PLIST_PATH" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"

# ----- 4. SwiftBar プラグイン -----
plugin_dir="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
if [[ -z "$plugin_dir" ]]; then
  plugin_dir="$HOME/Library/Application Support/SwiftBar/Plugins"
  info "SwiftBar のプラグインフォルダを ${plugin_dir} に設定"
  mkdir -p "$plugin_dir"
  defaults write com.ameba.SwiftBar PluginDirectory -string "$plugin_dir"
fi
plugin_dir="${plugin_dir/#\~/$HOME}"
info "SwiftBar プラグインを ${plugin_dir}/ へインストール"
install -m 0755 "$REPO_DIR/swiftbar/lidawake.30s.sh" "$plugin_dir/lidawake.30s.sh"
open -g -a SwiftBar 2>/dev/null || warn "SwiftBar が見つかりません。brew install --cask swiftbar でインストールしてください"
open -g "swiftbar://refreshallplugins" 2>/dev/null || true

# ----- 5. アンインストーラ -----
# ダウンロードしたフォルダを消しても、どこからでも同じ場所で消せるようにする。
mkdir -p "$HOME_DIR"
install -m 0755 "$REPO_DIR/uninstall.sh" "$HOME_DIR/uninstall.sh"

# ----- 動作確認 -----
info "動作確認: lidawake status"
st="$("$BIN_DIR/lidawake" status)"
info "status = ${st}（0 なら未抑止で正常）"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) warn "${BIN_DIR} が PATH に入っていません。CLI で使う場合は ~/.zshrc 等に追加してください:"
     warn '  export PATH="$HOME/bin:$PATH"' ;;
esac

info "インストール完了 🎉 メニューバーの ☕ から操作できます"
