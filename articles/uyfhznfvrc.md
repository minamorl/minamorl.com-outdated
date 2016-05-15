---
title: "Python Tips: import式と__init__.py" 
timestamp: 2016-05-15T16:20:03+0900
---

## importの意外な落とし穴

次のようなディレクトリ構造のモジュールを考える

```
.
├── main.py
└── my_awesome_module
    ├── __init__.py
    └── a.py
```

main.pyの中からモジュール`my_awesome_module`をimportする:

```python
import my_awesome_module
```

さて，次はコードは通るだろうか？

```
my_awesome_module.a
```

次が返ってくる．
```
% python main.py
Traceback (most recent call last):
  File "main.py", line 3, in <module>
      my_awesome_module.a
AttributeError: module 'my_awesome_module' has no attribute 'a'
```

ではこれはどうなるだろうか:
```python
import my_awesome_module.a

my_awesome_module.a
```

プログラムは正常終了する．

## import式とディレクトリ

この挙動は一見するとわかりづらいが，次のように考えればいい．Pythonのimport式はディレクトリを対象にした時，原則として対象ファイルの`__init__.py`のみを読み込む．

ではここで最初のプログラムを通すにはどうすればいいだろうか？ 答えはこうだ．`__init__.py`でimportしてやればいい:

```python
# __init__.py
from . import b
```

これで無事に通すことができた．

同じディレクトリ下のコードを全て読み出したい場合は`from . import *`すればよい．
