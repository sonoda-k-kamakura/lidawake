# lidawake ☕

MacBook の蓋を閉じてもスリープしない時間を、メニューバーから設定できます。時間が来たら自動で元に戻ります。macOS 専用です。

## インストール

コマンドは「ターミナル」アプリで実行します。Spotlight（⌘ + スペース）で「ターミナル」と入力すると開けます。

### 1. Homebrew を用意する

Mac のアプリをコマンドで入れる仕組みです。次を実行して、バージョンが表示されれば入っているので、2 に進んでください。

```sh
brew --version
```

「command not found」と出た場合は、次でインストールします。途中で Mac のパスワードを聞かれ、終わりに表示される「Next steps」の案内に従って設定します。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. SwiftBar をインストールする

メニューバーに ☕ を出すためのアプリです。

```sh
brew install --cask swiftbar
```

### 3. lidawake をインストールする

途中で Mac のパスワードを 1 回聞かれます。これは、スリープ設定の切り替え（`pmset -a disablesleep 0` と `1` の 2 コマンドだけ）を、毎回パスワードを入れずに実行できるようにするためです。許可する内容は `/etc/sudoers.d/lidawake` に書かれ、他のコマンドには影響しません。

```sh
cd "$(mktemp -d)" && curl -L https://github.com/sonoda-k-kamakura/lidawake/archive/refs/heads/main.tar.gz | tar xz && ./lidawake-main/install.sh
```

メニューバーに ☕ が出れば完了です。

## 使い方

☕ をクリックして時間を選びます。「解除」でいつでも元に戻せます。

- ☕ は通常どおり、☕ 45m は抑止中で残り 45 分、☕ ∞ は解除するまで抑止中です。
- 抑止中はバッテリーを消費し、熱がこもります。バッグに入れるときは解除してください。

ターミナルからは `~/bin/lidawake 2h`、`~/bin/lidawake off`、`~/bin/lidawake status` が使えます。

## アンインストール

```sh
~/.lidawake/uninstall.sh
```

## ライセンス

MIT
