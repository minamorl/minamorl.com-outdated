---
title: Twitter Summary Cardの画像が表示されない問題を解決する方法 
timestamp: 2015-09-16T05:40:00+0900
---

ドハマりした。

- TwitterのSummaryカードタイプには120x120px 以上の画像を表示できない
- 透過pngはあんまり上手く行かないっぽい（少なくともValidatorでは汚く表示された）
- 画像パスは相対パスではなくドメインから指定する

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">ちゃんとカードにアイコン表示されてるはず <a href="http://t.co/LLs7IsxqvL">http://t.co/LLs7IsxqvL</a></p>&mdash; ❋ (@minamorl) <a href="https://twitter.com/minamorl/status/643886576146100224">2015, 9月 15</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

以上、レポっす。
