---
title: Pythonで作るngram全文検索エンジン
timestamp: 2016-02-11T12:56:07+0900
---

Redisをバックエンドにしたn-gram(2-gram)による検索エンジンの実装例．スコアリングなどはまだ行っていないので実用段階ではないが，n-gramという手法について説明を交えつつ具体的なPythonでの実装方法を記述しておこうと思う．

## 転置インデックスとngram

全文検索エンジンを作るにあたって，パフォーマンス向上のために**転置インデックス(inverted index)**の作成は不可欠である．転置インデックスとは，特定の単語から元の文書のリストへの参照である．つまり「今日」という単語を含む文書番号は1と2，というように定義されているものが転置インデックスである．転置インデックスの作成にあたっては，形態素解析による手法とn-gramによる手法の2種類が主流だが，今回はn-gramによる実装を行う．

具体的には転置インデックスの何が嬉しいかというと，検索にかかる負荷が減らせるということが一番である．果たしてなぜそのようなことが可能なのか．具体的に実装のイメージをつかむために手続きを見てみよう．実際の検索の段階では，検索クエリを転置インデックス作成時の分割と同じように分割する．n-gramという手法は，文字列をn文字ずつに区切って分割する手法である．例えば文字列「全文検索エンジン」という文字列をバイグラム(2-gram)によって分割すると次のようになる.：

```
全文
分検
検索
索エ
エン
ンジ
ジン
```

これに対して文書番号を割り当てる．ここではid=1とする．これを永続的なデータとしてデータベースに保持しておく．ここでは仮想的にこのように表記する:

```
全文 ids=[1]
分検 ids=[1]
検索 ids=[1]
索エ ids=[1]
エン ids=[1]
ンジ ids=[1]
ジン ids=[1]
```

id=2の文書は「全文検索」という文字列だけとすると，データベース内は例えば次のようになる：

```
全文 ids=[1, 2]
分検 ids=[1, 2]
検索 ids=[1, 2]
索エ ids=[1, 2]
エン ids=[1]
ンジ ids=[1]
ジン ids=[1]
```

こうして作成されたデータベースに検索クエリ「エンジン」が与えられたとする．クエリ「エンジン」は次のように分割される：

```
エン
ンジ
ジン
```

あとは分割された文字列それぞれに対して検索をかけ，集合idsの積を取ればいい．今回の場合は{1} ∩ {1} ∩ {1} なので{1}である.よって文書1が求める文書である．とこのように三回のデータベースアクセスで済むので効率的である．

## ngram関数の実装

素朴に実装してみよう．与えられた文字列sをn文字で分割するgeneratorは次のように書ける：

```python
def ngram(s, n=2):
    i = 0
    while True:
        yield s[i:i+n]
        i += 1
        if len(s) <= i or len(s[i:i+n]) < n:
            return
```

REPLでの動作結果は次の通りである：

```python
>>> list(ngram("あ"))
['あ']
>>> list(ngram("あい"))
['あい']
>>> list(ngram("あいうえお"))
['あい', 'いう', 'うえ', 'えお']
```

これをRedisと連携させて永続化することを考える．`prefix:{バイグラム}`という形式にして，値にはRedisのリスト型でidの列を保存しておく．

## Redisを用いたデータ永続化

redis-ormで文書のモデルを定義する．説明の簡略化のために文書は文書idと全文データのみを持つものとする．

```python
from redis import StrictRedis
from redisorm.core import Persistent, PersistentData, Column


class Document(PersistentData):
    id = Column()
    fulltext = Column()
```

あとは愚直に実装するだけで完成．

```python
prefix = "sample-search-engine:"

p = Persistent()
doc = Document(fulltext="あいうえおかきくけこ")
p.save(doc)

r = StrictRedis()
for g in ngram(doc.fulltext):
    r.lpush(":".join(prefix, g), doc.id)
```

## 検索部分

ユーザーからの文字列入力に応じて，Redisから一致する文書番号を表示する．
```python
userinput = input()
result = None

for g in ngram(userinput):
    # 検索の初回のみ
    if result is None:
        # 0, -1 -> すべての範囲のリストを取得する
        result = set(r.lindex(":".join(prefix, g), 0, -1))
    else:
        # 結果のsetの積を取る
        result = result & set(r.lindex(":".join(prefix, g), 0, -1))


print(result)
```

お粗末さまでした．

## クローラーと連携した実装

github上で[minamorl/minamo](https://github.com/minamorl/minamo/)というプログラムをほぼ上述したアルゴリズムで実装している．こちらはクローラやパーサなどといったものが一体化しているので幾ばくか複雑だが，実装の内容としてはほぼほぼ同じであると言えるので参考にされたし．
