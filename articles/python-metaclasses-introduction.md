---
title: Pythonメタクラス(metaclasses)入門 
timestamp: 2016-02-11T03:00:47+0900
---


以下の説明はPython 3.5.1環境下を念頭に書かれたものである．

2.x系列と記法が違うので注意．2.x系列については扱わない． 
Pythonには**メタクラス(metaclass)**という機能がある．メタクラスはクラスを生成するクラスである．

Pythonでは，クラス定義が実行される際，次のステップが発生する：

- メタクラスの決定
- クラスの名前空間(namespace)の準備
- クラスの本体部(class body)の実行
- クラスオブジェクトの生成

デフォルトで明示的なメタクラスの指示がない場合，Pythonは`type()`をメタクラスとして利用する．明示的なメタクラスが定義されていてかつ`type()`のインスタンスでない場合，直接的にそれをメタクラスとして利用する．`type()`のインスタンスが明示的に与えられる・継承元のクラスとして与えられると，大本のクラスに遡ってメタクラスを持ってくる．

小難しい話は抜きにして，一般的な(主にライブラリ)開発者にとって，Pythonにおけるメタクラスの最たる用途は，簡潔に言って，クラスの「定義時」にクラスの名前空間をもとにした処理を行うことである．



次のようなclass Aを定義する：

```python
class A(metaclass=MetaA):
  pass
```

次に，Aに対してメタクラスMetaAを定義する：

```python
class MetaA(type):
  def __new__(cls, name, bases, namespace, **kwds):
    return type.__new__(cls, name, bases, namespace)
```

メタクラスの定義には通常`type`を継承する．実際のところ，metaclassはtypeを継承する必要はなく，またクラス自体metaclassとして任意のcallablesを指定することが出来る．つまりクラスだけではなく関数すらmetaclassとして指定できるというわけである．しかし一般的に，関数をmetaclassとして利用する必要性のある局面に迫られることは少ない．

このメタクラスはインスタンスを生成するのみである．メタクラスはクラスを生成するクラスである．さて，typeを継承したクラスは，`type.__new__`と同じ形の`__new__`メソッドを持つ．

これをどのように活用するかを考える．まず，引数namespaceに注目して欲しい．これは何の情報を持っているかというと，生成するclassの名前空間である．すなわち：

```python
class A(metaclass=MetaA):
  foo = 3
  bar = 5
```

この場合，MetaAが保持するnamespaceは次のとおりである(`MetaA.__prepare__`を上書きしない場合，dict型なので順序は問題にしない)：

```python
{
  'foo': 3, 
  'bar': 5, 
  '__module__': '__main__', 
  '__qualname__': 'A'
}
```

つまり，クラスを定義する以前で，これから定義するクラスの名称，基底クラス，名前空間といった情報が手に入るわけである．これはクラス作成者に大して非常に有益な情報である．一番妥当な使い方と思われるのは，与えられた名前空間をベースに事前処理を加える，といった処理を行うことである．

```python
class MetaA(type):
  def __new__(cls, name, bases, namespace, **kwds):
    i = 0
    for k, v in namespace.items():
      if not k.startswith("__"):
        i += int(v)
    print(i)
    return type.__new__(cls, name, bases, namespace)
```

このmetaclass MetaAは，クラス定義時にクラスの名前空間を元に計算を行う．つまり，次のコードが評価された時点で：
```python
class A(metaclass=MetaA):
  foo = 3
  bar = 5
```
次が出力される：
```python
8
```

namespaceは単なるdictである，という話を先ほどしたが，dictであるということはつまり書き換え可能であるということである．クラスの名前空間を弄って，計算結果を出力するだけではなく，計算結果を保持させてみよう．

```python
class MetaA(type):
  def __new__(cls, name, bases, namespace, **kwds):
    i = 0
    for k, v in namespace.items():
      if not k.startswith("__"):
        i += int(v)
    namespace["sum"] = i
    return type.__new__(cls, name, bases, namespace)

class A(metaclass=MetaA):
  foo = 3
  bar = 5
```


```python
print(A.sum)
```

上のコードは読者諸君が期待する通りに動く．

```python
8
```

お分かり頂けだろうか．クラスの定義時に名前空間をいじることが出来るというメタクラスの性質は非常に強力である．これをベースにして派生させていくと様々なことが出来る．例えば，メタクラスの段階で名前空間に存在する特定の型のオブジェクトのリストを名前空間から生成させて保持しておき，他のクラスから利用する，といった活用方法が考えられる．拙作[redis-ormの実装](https://github.com/minamorl/redis-orm/)が参考になるかもしれない．

以上，簡単なメタクラスの導入である．

## 参考文献
1. https://docs.python.org/3/reference/datamodel.html#customizing-class-creation

2. http://blog.ionelmc.ro/2015/02/09/understanding-python-metaclasses/



