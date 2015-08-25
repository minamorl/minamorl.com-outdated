---
title: autopep8.vimを作った 
timestamp: 2015-08-25T03:47:51+0900
---

autopep8.vimを作った。

[<span class="octicon octicon-link-external"></span> minamorl/autopep8.vim](https://github.com/minamorl/autopep8.vim)

既にありそうだったが、Vim Script テクニックバイブルに触発されて書いてみた。見ての通りautopep8をvim上から実行するだけの簡易なプラグインである。サンプルでは`<Leader>t`にマッピングしているが、本体では関数を提供しているだけ。使い方次第でバッファの書き込み時に作動させるということも可能である。
