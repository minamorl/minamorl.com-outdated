---
title: "git push すると Warning: Permanently added '...' (ECDSA) to the list of known hosts.と怒られる"
timestamp: 2015-09-18T07:20:11+0900
---

## 黙らせる方法

~/.ssh/configにLogLevel ERRORを設定してやればよい。git単体のオプションとしてはない模様。git 2.xならあるかも。

## circle.ymlから設定する

今のところこういう感じの設定で動いた。

<script src="https://gist.github.com/minamorl/2eb34d0cfd2b83f6056c.js"></script>
