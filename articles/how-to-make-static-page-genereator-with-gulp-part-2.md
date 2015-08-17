---
title: Gulpを用いてmarkdownから静的HTMLファイルの生成を行う(パート2)
timestamp: 2015-08-18T04:14:34+0900
---

このサイトのコードをgithub上で公開した。 

[minamorl/minamorl.com - github.com](https://github.com/minamorl/minamorl.com)

前回の投稿から色々と変更点は出ているが大まかな点についてはあまり変化がない。[gulpfile.coffee](https://github.com/minamorl/minamorl.com/blob/master/gulpfile.coffee)を参照してほしい。

## gulp-webserverの導入

Gulp側でテスト用のサーバを用意に構築することが出来るライブラリ。現状livereloadに対応していてまともに動くのはこれ一択という感じ。

[gulp-webserver](https://www.npmjs.com/package/gulp-webserver)

実際にこのサイト上で使われているものと同様のものを掲載する
```coffeescript
gulp.task 'serve', ->
  gulp.watch './sass/**/*.sass', ->
    runSequence 'sass', 'compress'
  gulp.watch ['./templates/**/*.jade', './articles/**/*.md'], ->
    runSequence 'build', 'compress'
  gulp.src 'dist'
    .pipe webserver
      livereload: true,
      proxies:[
        source: '/bucket',
        target: 'http://minamorl.com/bucket',
      ]
```

gulp.srcからwebserverにpipeを渡してやるだけで動くので導入は非常に楽。proxies以下の設定は無視しても良い。このサイトの場合本番環境下に直接画像ファイルを設置しているので、デフォルトの設定で相対パス指定が効かず不便である。そのためプロキシを設置して迂回している。

プロキシの設定はあまりサンプルがなかったが簡単だった。

見れば分かるとおり、gulp.watch以下で自分の記事情報を監視して、変更があればbuildタスクに投げている。そうすると自動でgulp-webserverのlivereloadが働く。少なくともSassまわりの開発効率は上がった気がする。

## circleciとの連携

今回はgithub上で公開したのに合わせて、gulpによるタスク実行から本番環境へのデプロイまでをcircleciへ任せることにしたので備忘録。

### 利点: なぜcircleciを使うのか

- deployタスクでのdist配下の生成をCircleCI側に委ねることができるため、自前のリポジトリの管理下から削除できる

明らかにdistが気持ち悪い存在だというのは自覚していて、circleciを経由することでgit pushするたびに自動で仮想環境下でnpmの依存関係のインストールが走るので、環境移行が楽になった。githubからリポジトリをcloneできれば常に同じ環境を生成できる。少なくともnpm周りの依存関係でコケないという安心感を得られる。

### circle.ymlを書く

ここは情報が少なくて苦戦した。

circleciは自動的に`npm install`を走らせてくれるがそのままの状態だと当然testがないと怒られてしまう。

まず、distを生成してもらうためにpackage.jsonに以下のような記述をする。

```json
  "scripts": {
    "test": "gulp deploy"
  },
```

gulp deployとなっているのは自分の環境に合わせて読み替えてほしい。

このように設定しておくことでcircleci側が自動的に`npm test`コマンドを走らせる。npm testはjsonに記載されたコードを実行するだけ。

リモートに適当なbareリポジトリを設置してそこにmasterブランチをpushする設定が以下。

```
deployment:
  production:
    branch: master
    commands:
      - git add dist
      - git config --global user.email "minamorl@users.noreply.github.com"
      - git config --global user.name "minamorl"
      - git commit -m "[circleci]"
      - git push -f ${SSH_SERVER} master
```

目的はダミーのコミットを生成すること。まず上から順にタスクが実行される。`git add dist`は当然`npm test`が*実行された後*に動くため問題なく動く。

次がハマりどころで、`git config`でuser.nameとuser.emailを指定しないとエラー吐いてコケる。キレそう。

git commit -mでコミットを作る。あとは本番のベアリポジトリにpushするだけ。circleci側でenvの設定ができるので今回は`SSH_SERVER`という名前で環境変数を作りハードコーディングを避けた。

## まとめ

gulpで静的ページを作るの、本当に心の底からおすすめしない。もっと[HugoとかいうGoで書かれたモダンでイケイケなもの](http://gohugo.io/)があるのでそれ使ってくださいという感じ。

あと今回肝心のbareリポジトリ側の設定について書かなかったのだが、post-receive hookを設置することによって自動でpullする設定については後日気が向いたら書く。
