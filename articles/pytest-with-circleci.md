---
title: py.testとCircleCI 
timestamp: 2015-09-10T01:46:32+0900
---

py.testとCircleCIによる自動テスト環境の構築に非常に手間取った。

## 環境
- python (3.4.2)

テスト環境は以下の三本柱。

- setuptools
- pytest
- tox

pytestはpython標準のテストツールを置換するためのライブラリ。toxはvirtualenv環境を構築してその中でpytestを走らせてくれる代物。

今回はCircleCIを使う上で基本的にpytestでハマったという話なので読み飛ばしてよい。詳しく知りたい人は公式リファレンスかコメント欄で。

## 課題

さて、早速いくつか壁にぶつかったので実例を見ていただくとしよう。


### 1. CircleCIがpython setup.py installをうまく扱えない

CircleCIは一度テストに使ったインスタンスを使いまわすのだが、`setup.py install` が自動的にタスクとして走る。この際、1度目の実行時には問題がないのだが、キャッシュが効いた状態で行うとpython setup.py installでfailする。

以下はgitsamplerという個人で使ってるコンソールアプリケーションを題材にしています。

[https://circleci.com/gh/minamorl/gitsampler/13](https://circleci.com/gh/minamorl/gitsampler/13)
```
Traceback (most recent call last):
  File "setup.py", line 48, in <module>
    'console_scripts': ['gitsampler = gitsampler.__main__:main']
(中略)
python setup.py install returned exit code 1

zipimport.ZipImportError: bad local file header in 
/home/ubuntu/virtualenvs/venv-3.4.2/lib/python3.4/
site-packages/gitsampler-0.2.2-py3.4.egg Action failed:
python setup.py install
```

はい。これには度肝を抜かれたね。python setup.py install returned exit code 1じゃあないんだよ。

### 2.pytestが不必要なtestsディレクトリを再帰的に探索してしまう

最初原因はtoxかと思ったんだがどうも違うらしいぞということでcircleci側にsshしてログをたどったところ、オリジナルのファイルの他にvenvフォルダが生成されていてこれが邪魔をしていたようである。

[https://circleci.com/gh/minamorl/gitsampler/8](https://circleci.com/gh/minamorl/gitsampler/8)

これを解決する方法はtox側ではなくpytest側でした。ドキュメントを精査すると次のようなオプションがあることがわかります。

[Basic test configuration](https://pytest.org/latest/customize.html#confval-norecursedirs)

## 解決策

新規にsetup.cfg, circle.ymlをそれぞれセットアップしてやる必要がある。

<!-- read more -->

### circle.yml

<script src="https://gist.github.com/minamorl/b1f6d0ac83e277d885d2.js"></script>

dependenciesのpreタスクにある pip uninstall gitsampler -y || true がミソ。

### setup.cfg

<script src="https://gist.github.com/minamorl/8bbb64e4de741cb37a75.js"></script>

norecursedirsにvenvを足すのがミソ。これによってtoxを実行したときのエラーが発生しなくなり幸せになれます。

## 結論

py3.4環境でしかもtoxとpytestという環境ユーザが少ないのかもしれないけどCircleCIもう少し頑張って欲しいと思った。詳細なソースコードが見たい人はminamorl/gitsamplerにあるので見て下さい。
