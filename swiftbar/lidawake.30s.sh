#!/bin/bash
# <xbar.title>lidawake</xbar.title>
# <xbar.desc>蓋を閉じてもスリープしない時間をメニューバーから設定 (中核は ~/bin/lidawake)</xbar.desc>
# <xbar.version>1.0</xbar.version>
#
# SwiftBar plugin — tmux 側と同じ ~/bin/lidawake を呼ぶだけの薄い入口。
# 有効中はメニューバーに残り時間、ドロップダウンで時間選択 / 解除。
LIDAWAKE="$HOME/bin/lidawake"
st=$("$LIDAWAKE" status 2>/dev/null || echo 0)

if [[ "$st" == "inf" ]]; then
  echo "☕ ∞"
elif [[ "$st" =~ ^[0-9]+$ ]] && (( st > 0 )); then
  h=$(( st / 3600 )); m=$(( (st % 3600 + 59) / 60 ))
  if (( h > 0 )); then t="${h}h${m}m"; else t="${m}m"; fi
  echo "☕ ${t}"
else
  echo "☕"
fi

echo "---"
echo "蓋閉じスリープ抑止 | size=11 color=gray"
for spec in "30分:30m" "1時間:1h" "2時間:2h" "4時間:4h" "8時間:8h" "12時間:12h"; do
  label="${spec%%:*}"; arg="${spec##*:}"
  echo "${label} | bash=\"$LIDAWAKE\" param1=${arg} terminal=false refresh=true"
done
echo "無制限（解除するまで） | bash=\"$LIDAWAKE\" param1=on terminal=false refresh=true"
echo "---"
echo "解除（今すぐ戻す） | bash=\"$LIDAWAKE\" param1=off terminal=false refresh=true"
