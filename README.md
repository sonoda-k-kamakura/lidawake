# lidawake ☕

MacBook の蓋を閉じてもスリープしない時間を、メニューバーから設定できます。時間が来たら自動で元に戻ります。macOS 専用です。

## インストール

1. [SwiftBar](https://swiftbar.app) をインストールして起動します。プラグインフォルダを聞かれたら、好きな場所を選んでください。
2. ターミナルで次を実行します。途中で Mac のパスワードを 1 回聞かれます。

   ```sh
   curl -L https://github.com/sonoda-k-kamakura/lidawake/archive/refs/heads/main.tar.gz | tar xz && cd lidawake-main && ./install.sh
   ```

3. メニューバーに ☕ が出れば完了です。

## 使い方

☕ をクリックして時間を選びます。「解除」でいつでも元に戻せます。

- ☕ は通常どおり、☕ 45m は抑止中で残り 45 分、☕ ∞ は解除するまで抑止中です。
- 抑止中はバッテリーを消費し、熱がこもります。バッグに入れるときは解除してください。

ターミナルからは `lidawake 2h`、`lidawake off`、`lidawake status` が使えます。

## アンインストール

インストールしたフォルダで `./uninstall.sh` を実行します。

## 仕組み

パスワードなしで実行できるようにするのは `pmset -a disablesleep 0` と `1` の 2 コマンドだけです。その設定は `/etc/sudoers.d/lidawake` に入ります。

## ライセンス

MIT
