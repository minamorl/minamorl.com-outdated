---
title: Gulpを用いてmarkdownから静的HTMLファイルの生成を行う
timestamp: 2015-07-31T11:22:58+0900
---

## モチベーション

staticなWebサイトジェネレータを探していたが何となく既存のものを使いたくなかったので、Gulpから直接生成する手段はないか検討していた

つまり

```
gulp markdown
```

と入力しただけで`/articles/**/*.md`ファイルから、markdownをコンパイルした状態で自動的にJadeテンプレートを適応し、`/dist/articles/**/*.html`ファイルを生成してほしい。

## このサイトの実装

```coffeescript
gulp        = require 'gulp'
frontMatter = require 'gulp-front-matter'
layout      = require 'gulp-layout'
markdown    = require 'gulp-markdown'
jade        = require 'gulp-jade'
tap         = require 'gulp-tap'
path        = require 'path'

// ...

gulp.task 'markdown', ->
  defaultLayout =
    layout: "templates/article.jade"
  gulp.src 'articles/**/*.md'
    .pipe frontMatter()
    .pipe markdown()
    .pipe layout ((file) ->
      merge(defaultLayout, file.frontMatter)
    )
    .pipe tap((file) ->
      extname = path.extname(path)
      name =
        dirname:  path.dirname(file.path),
        basename: path.basename(file.path, extname),
      file.path = path.join name.dirname, file.frontMatter.timestamp + "-" + name.basename
    )
    .pipe gulp.dest('./dist/articles')
```

gulp-front-matterはmarkdownファイルからYAML front matterをparseしてfile.frontMatterに格納して返してくれる。あとはmarkdownに処理させてlayoutからJadeをぶん投げて保存するだけ。

tap内の処理はrename時にfrontMatterの情報を使いたかったからで、普通はgulp-renameでも使えばいいと思います。

## 結論

普通にJekyllとかそのへんのジェネレータ使ったほうが幸せになれる。
