---
title: Gulpを用いてmarkdownから静的HTMLファイルの生成を行う
timestamp: 2015-07-31T11:22:58+0900
---

## モチベーション

staticなWebサイトジェネレータを探していたが何となく既存のものを使いたくなかったので、Gulpから直接生成する手段はないか検討していた

目標としては

```
gulp markdown
```

と入力しただけで/articles/**/*.mdファイルを自動的にJadeテンプレートを適応した状態で/dist/articles/**/*.htmlファイルを生成する。
