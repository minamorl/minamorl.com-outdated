---
title: 初心者のためのFlaskの手習い 
timestamp: 2015-11-18T12:09:23+0900
---

Flask初心者のための導入の手引である。

## Flaskとは何なのか

Flaskとは簡単に言ってしまえば薄いwerkzeugのラッパーである。werkzeugはWSGI開発のためのユーティリティツール群である。Flaskによって開発されるアプリケーションはWSGIアプリケーションとして動作する。

Railsなどのフルスタックフレームワークと異なり、フレームワークにデータ永続化のための手段は持っていないため、そういった部分はSQLAlchemyなどと組み合わせて行う。自動生成されるコードは一切ない。migrationなどは手動で実装することとなる。ディレクトリ構成もすべて自分で行う。

また、テンプレートからの生成は主にJinjaなどと連携して行う。これはつまるところ、Flaskは文字列を返すし適切なレスポンスヘッダを返すことができるが、返す文字列についてはユーザーに一任される。

直感的に説明するとルーターとして機能する。`http://example.com/`としたとき、indexに対応する関数を読み出すと言った処理を簡潔に行うのがFlaskの主たる機能である。

このようにコンセプトとしては非常に明快でシンプルである。以上がマイクロフレームワークと呼ばれる所以である。基本的にHTTPサーバの応答は一定程度の理解を必要としている。


## プロダクション環境の構成

Flaskは単体でwerkzeug互換のサーバとして動作するが、単体で動かすにはプロダクション環境においては少々非力である。

したがってサービスを作り始める前にどのような環境で動作させるかを考えておくとよい。

本番環境の構成を先に考えていく。WSGIの動作環境は基本的には以下の中から選べばよい。


- mod_wsgi
- Gunicorn
- Gevent
- uWSGI

筆者はgunicornを推奨する。基本的には個人の好みに依存する。

## プロジェクトのフォルダ管理

基本的に好きな`project_name`ディレクトリを作成し、ディレクトリ直下に`app.py`など好きな名前で配置すればいい。

```
% tree flasksample       
flasksample
└── serve.py

0 directories, 1 file
```

## 最小限のアプリケーション

```
% cat flasksample/serve.py 
from flask import Flask
app = Flask(__name__)
PORT = 8080

@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run(port=PORT)
```

port番号は自分の好きなものを入力する。明示しないときのデフォルトは8000番である。

まずこの時点で`python serve.py`するとサーバが立ち上がり、`http://127.0.0.1:8080/`へアクセスすると`Hello World!`が表示されるはずである。

## 本番環境の構築(gunicorn編)

まず本番環境に`pip install gunicorn`でgunicornを入れる。

```
% cd flasksample
% gunicorn -w 4 serve:app --port 8080
```

これでgunicornがport8080でワーカー4つで立ち上がる。

daemonとして働かせたい場合は`gunicorn -w 4 serve:app --port 8080 -D`とする。終了の方法は`killall gunicorn`などする以外方法がない。これについては監視ツールを別途導入することで解決することができる。

gunicornはnginxなどからプロキシを貼って利用することが推奨されている。nginxにリバースプロキシを貼る設定をする。

## 終わりに

Flask本体のソースコードは以下で公開されている。

[flask/app.py](https://github.com/mitsuhiko/flask/blob/master/flask/app.py)

以上が大まかなFlaskの説明である。Flaskは柔軟である。用途に合わせれば非常に優秀なフレームワークである。PythonによるWebアプリケーション開発はWSGIの難易度の高さにより敬遠されがちであるが、WSGIアプリケーションのデプロイの難易度の高さを乗り越えてぜひとも幅広いユーザに使われて欲しい。

## 参考文献
1. http://flask.pocoo.org/docs/0.10/deploying/
2. http://docs.gunicorn.org/en/latest/install.html

