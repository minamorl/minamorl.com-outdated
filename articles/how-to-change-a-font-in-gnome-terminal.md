---
title: gnome-terminalからフォントを変更する方法 
timestamp: 2015-08-31T04:13:51+0900
---

Ubuntu 14.04の端末にRicty Diminished入れようとしたら表示されなくて焦った。

fc-listに自分の~/.fonts以下のフォントが存在していることを確認して（されていなければ`fc-list -fv`する）、次のコマンド。

```
gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/font "Ricty Diminished 14"
```

これでRicty Diminishedが使える。なぜ表示されないのかは不明。
