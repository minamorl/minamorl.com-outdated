---
title: 今年のまとめ 
timestamp: 2015-12-16T17:47:49+0900
---

## 今年作ったもの

1月にchrolixというウェブサービスを作るお手伝いをしていたんですが、それきりしばらくプログラミングなんてやめていました。でも急に自分のブログが欲しくなったんで始めることにしました。たしか今年の7月くらいです。それからなし崩し的にいろいろ作りました:

- minamorl.com
- everything
- everything-interface
- plan.py
- redis-orm
- autopep8.vim
- staccato

せっかくなので今年のまとめも兼ねて作ったものの説明をします

<!-- read more -->

### minamorl.com

[minamorl/minamorl.com](https://github.com/minamorl/minamorl.com)

見ての通りこのWebサイトのソースコードです。

一見ブログに見える当サイトですが、一般的なブログと違ってただの静的ページです。つまりデータベースの読み出しなどは一切していません。本当にhtml+cssのシンプルなページです。ただ、一般的なhtmlベースのサイトには欠点があります。デザインの変更のたびにすべてのページを書き換える必要があるということです。これを解決するのが静的ページジェネレータ(static page generator)といわれるものです。

ご存知の方も多いと思いますが、静的ページジェネレータとは何をやってくれるかというと、htmlファイルをテンプレートとして、シンプルなテキストファイルから生成するというものです。テンプレートに文字列を埋め込んでいくような仕組みです。さて、今回は静的ページジェネレータごと1から作成しました。理由は自分でも作れると思ったからです。

例えば[Flaskアプリケーションをgunicornでデプロイする(よりよい)方法](http://minamorl.com/articles/2015-11-26T23:29:21+0900-deploy-your-flask-app-with-gunicorn.html)という記事では、元々は次のようなデータで書かれています

[https://raw.githubusercontent.com/minamorl/minamorl.com/master/articles/deploy-your-flask-app-with-gunicorn.md](https://raw.githubusercontent.com/minamorl/minamorl.com/master/articles/deploy-your-flask-app-with-gunicorn.md)

これを事前に指定したテンプレートファイルから自動でブログ記事にします。

nodejsベースです。gulp+webpackで作りました。

### plan.py

さて、作ったminamorl.comですが、だんだん記事を手動でサーバーにアップロードするのが億劫になりました（一瞬でなりました）

そこでpythonを使ってアップロードするスクリプトを書き始めました。決められたタスクを実行する、つまり**タスクランナー**と言われるツールです。

毎回３行くらい手打ちするのが面倒だったので、`plan dist`と打ったらサーバーにアップロードしてほしくなったのですが、あんまりいいのがないので自分で作りました。

あとはアップロード前のプレビュー機能とかもいちいちコマンド覚えるのが面倒くさいので`plan a`とか打ったら勝手にやってほしいなって思いました。それで出来たのがこれです。

[minamorl/plan.py](https://github.com/minamorl/plan.py)

### kirarich.com (everything/everything-interface)

突然Twitterがクソに感じたので、やけくそになってにちゃんねるとWikipediaのフレーバーを混ぜて[kirarich.com](https://kirarich.com/)というサービスを作りました。そのソースコードのサーバーサイドがeverything、見た目のほうがeverything-interfaceです。

plan.pyのおかげでテストから本番サーバーへのデプロイ（要するにアップロード+後処理）が一瞬で出来るようになりました。ありがたいありがたい。

[minamorl/everything](https://github.com/minamorl/everything)
[minamorl/everything-interface](https://github.com/minamorl/everything-interface)

あとネイティブクライアントも作りました。面倒くさいのでソースコードは公開していません。botも作りましたが同じく公開していません。

### redis-orm

きらりちゃんねるはredisで動いています。

**redis**というデータベースサーバーがありまして、Pythonという言語からredisへデータを保存する方法があるのですが、原始的すぎたのでより書きやすい方法で実装する必要が出てきました。似たようなものは機能が必要以上だったり必要以下だったりしたのでやけくそになって自分で作りました。

きらりちゃんねるのユーザー情報や、スレッドの書き込みといったすべてのデータがredis-ormを使うことによって劇的に簡単に保存できるようになりました。

[minamorl/redis-orm](https://github.com/minamorl/redis-orm)

### staccato

**staccato**はTwitterのAPIをPythonから叩くためのツールです。既存のものが気に入らなかったのでやけくそになって作りました。

[minamorl/staccato](https://github.com/minamorl/staccato)

Pythonからユーザーストリームの取得から何から全部出来るようになりとても快適になりました。今後きらりちゃんねるのbotやデータ解析用途で使うつもりです。

### autopep8.vim

Pythonのソースコードをvimというテキストエディタから綺麗にするためのプログラムです。すぐ汚く書いてしまうので自動整形してもらえて助かっています。

[minamorl/autopep8.vim](https://github.com/minamorl/autopep8.vim)

## まとめ

ざっとこんな感じです。来年の抱負はありません。

趣味のプログラミングの成果としてはそれなりではないかと思っています。
