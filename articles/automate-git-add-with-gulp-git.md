---
title: git-addをgulp-gitを用いて自動化する
timestamp: 2015-08-06T01:02:34+0900
---

## モチベーション

このサイトはgulpを用いてmarkdownファイルからすべて静的ファイルが自動生成されているが、articles以下のファイルを更新したあとgulpコマンドを実行したとき、いちいち手動で`git add articles`などとやるのは煩わしい。

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">今のサイト、distフォルダ以下をデプロイしたいんだけどarticlesとdistを両方addするの毎回忘れる</p>&mdash; みなもーる (@minamorl) <a href="https://twitter.com/minamorl/status/628947062860574720">2015, 8月 5</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">bareリポジトリからpost-receiveでgulp実行してページ生成するの一瞬考えたけどサーバー側にnpm入れたり色々と最悪な感じしかしないからこの案はやめだな 全部git関係はgulp-gitに収めてgulp経由でしか触らないとか</p>&mdash; みなもーる (@minamorl) <a href="https://twitter.com/minamorl/status/628947551220137984">2015, 8月 5</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr">折衷案としてgulpのタスクからページ生成～git.addまでを実行するようにしてコミットしてプッシュする流れは手動でやることにした</p>&mdash; みなもーる (@minamorl) <a href="https://twitter.com/minamorl/status/628955502387462144">2015, 8月 5</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

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
