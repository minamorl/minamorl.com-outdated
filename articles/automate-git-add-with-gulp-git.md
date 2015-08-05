---
title: git-addをgulp-gitを用いて自動化する
timestamp: 2015-08-06T01:02:34+0900
---

## モチベーション

このサイトはgulpを用いてmarkdownファイルからすべて静的ファイルが自動生成されているが、articles以下のファイルを更新したあとgulpコマンドを実行したとき、いちいち手動で`git add articles`などとやるのは煩わしい。

したがって自動でarticles以下のファイルとdist以下のファイルをコミット対象に追加してほしい。

## サンプル

```sh
sudo npm install gulp-git --save-dev
```

とした後、gulpfile.coffeeに次のように追加する。

```coffeescript
git = require 'gulp-git'

gulp.task 'git-add', ->
  gulp.src ['./articles/**/*.md', './dist/**/*']
    .pipe git.add()
```

このようにシンプルなタスクを生成しgulpのデフォルトタスクに追加してやると想定通りの挙動が得られる。
