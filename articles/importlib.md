---
title: importlibを使ってPythonの単体ファイルをモジュールとして読み込む方法
timestamp: 2015-11-14T21:42:49+0900
---

## Pythonで動的にモジュールをロードする



### 普通の方法

```python
module = importlib.load_module(modulename)
```

これでmodulenameを動的にインポートすることが可能である。

これらはPythonのimport式と実質的にはいくつかの違いを除き類似の働きをする。

したがって、同様にPythonの標準的なimport式と同じく、モジュールに対しても以下のことを要求する。

- 対象に対して`sys.path`にパスが通っている
- `__init__.py`を起点としたディレクトリ構造である

単純に既存ライブラリを文字列からロードするような用途には使えるが、手元のファイルを動的にロードしてモジュールとして読み込むことは不可能である。

ここではその不可能を可能にする。


## importlib.machinery.SourceFileLoaderを使った方法

ここでは表題の単一ファイルを動的にモジュールとしてロードするための方法を提示する。

```python
module= importlib.machinery.SourceFileLoader(modulename, filepath).load_module()
```

importlib.machineryはPython3.3から導入された標準モジュールである。modulenameは自由につけることが可能である。filepathを絶対パスで指定することにより、動的にモジュールを生成して代入することが可能である。

このようにlibimportの暗黒魔術によってimportすることが出来るが暗黒魔術なので安易な利用は避けるべきである。

## 参考文献

1. [31.5. importlib – The implementation of import &mdash; Python 3.4.3 documentation](https://docs.python.org/3.4/library/importlib.html#importlib.machinery.SourceFileLoader)
