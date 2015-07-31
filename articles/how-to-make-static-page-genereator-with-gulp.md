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
del         = require 'del'
bower       = require 'gulp-bower'
flatten     = require 'gulp-flatten'
uglify      = require 'gulp-uglify'
cond        = require 'gulp-if'
gutil       = require 'gulp-util'
sass        = require 'gulp-sass'
runSequence = require 'run-sequence'
merge       = require 'merge'
frontMatter = require 'gulp-front-matter'
layout      = require 'gulp-layout'
markdown    = require 'gulp-markdown'
jade        = require 'gulp-jade'
fs          = require 'fs'
rename      = require 'gulp-rename'
tap         = require 'gulp-tap'
path        = require 'path'
marked      = require 'marked'

gulp.task 'markdown', ->
  defaultLayout =
    layout: "templates/article.jade"
  merged = {}
  gulp.src 'articles/**/*.md'
    .pipe frontMatter()
    .pipe markdown()
    .pipe layout ((file) ->
      merge(defaultLayout, file.frontMatter)
    )
    .pipe tap((file) ->
      console.log file.path
      extname = path.extname(path)
      name =
        dirname:  path.dirname(file.path),
        basename: path.basename(file.path, extname),
      file.path = path.join name.dirname, file.frontMatter.timestamp + "-" + name.basename
      console.log file.path
    )
    .pipe gulp.dest('./dist/articles')
```
