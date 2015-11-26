---
title: Flaskアプリケーションをgunicornでデプロイする方法
timestamp: 2015-11-26T23:29:21+0900
---

## gunicornの基本

GunicornはRubyのUnicornをモデルとしたpre-fork workerモデルを採用している。単純なアプリケーションなら以下の1行を書けばデプロイ出来る:

```
gunicorn -w 4 -b 127.0.0.1:8080 myproject:app -D
```

カレントディレクトリ以下にあるmyproject.pyに定義されているWSGIに沿ったappオブジェクトをport 8080でデーモンとして起動する。

当然、プロセスがkillされると止まってしまう。本番環境下で再起動した場合に自動的にリスタートしてくれるような状態になっていてほしい。Upstartを使う方法もあるが、筆者は用意に導入できる**Supervisor**を推奨する。

## gunicornをモニタリングする

Ubuntuでは別途ppaを追加することなく以下のコマンドで導入できる:

```
apt-get install supervisor
```

SupervisorはPython 2.x以下でしか動かないので、システムの環境のpythonに面倒を見てもらいたい。そのためpip経由ではなくaptで直接入れている。

gunicorn公式ページを参考にしてこのように設定ファイルを作成していく:

```
[program:yourappname]                                                            
command=/home/username/.pyenv/shims/gunicorn -w 6 serve:app -b 127.0.0.1:8080 
directory=/var/www/yourappname
user=username
autostart=true
autorestart=true
redirect_stderr=true
```

今回はpyenvと連携させて最新版のpythonを動作させたいため、commandの指定が冗長になるが、システムのバージョンのpythonを使う場合`gunicorn`だけでよい。

`/etc/supervisor/conf.d/`直下に`yourappname.conf`など適当な名称をつけて保存する。

sudoで以下を実行する:

```
supervisorctl start yourappname
```

これでモニタリング可能となる。いちいちgunicornプロセスを探しだしてkillしてやる必要がなくなる。めでたしめでたし。

プロダクション環境では、ユーザを別途切り分けてそこにpyenv+virtualenvで下地を構築してその上に依存ライブラリをインストールしてやることが望ましいと思われる。


## /var/www/配下に自動的に保存する

古典的に`rsync`を使う。plan-pyとparamikoを組み合わせて自動的にサーバーの停止からrsync、起動まで行う方法については後日気が向いたら書く。

## 参考文献

1. [Supervisor: A Process Control System &mdash; Supervisor 3.1.3 documentation](http://supervisord.org/)
