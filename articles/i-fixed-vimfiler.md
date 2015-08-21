---
title: Vimfilerを治した
timestamp: 2015-08-21T23:09:10+0900
---

Vimfiler、便利に使ってたんだけど、久々に :NeoBundleUpdate を走らせたら動かなくなってしまった。

調べたところ `g:vimfiler_ignore_pattern` が配列を取るように変わってたようなので、原因だった `let g:vimfiler_ignore_pattern = ''` を `let g:vimfiler_ignore_pattern = []` にしたら動いた。

```
let g:vimfiler_as_default_explorer = 1
call vimfiler#custom#profile('default', 'context', {
     \ 'safe' : 0,
     \ 'edit_action' : 'tabopen',
     \ })
let g:vimfiler_ignore_pattern = []
```

ちなみにこのオプションはデフォルトでdotfilesを無視する設定になっている。それを除外する設定が上記。
