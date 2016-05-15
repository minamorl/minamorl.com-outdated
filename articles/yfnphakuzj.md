---
title: "Python Tips: decoratorでデコレートされた関数から元の関数を取り出す" 
timestamp: 2016-05-15T16:37:33+0900
---

次のような簡単なdecoratorと，それによってラップされた`my_func`を考えよう：
```
def deco(func):
    def wrapper(*args, **kwargs):
        print("wrapper is called.")
        func(*args, **kwargs)
    return wrapper


@deco
def my_func():
    print("original function is called.")
```

ここで`my_func()`を呼び出すと何が出力されるだろうか．読者の期待通りである：

```
wrapper is called.
original function is called.
```

これらは俗にデコレータパターンと呼ばれ，特にPythonを用いる上では頻繁に用いられるデザインパターンである．

あまり指摘されることが少ないが，decoratorパターンにはひとつ欠点がある．それは「元の関数をラップする」という性質上，オリジナルの関数にアクセスできなくなるという点である．実際，上述したデコレータは以下の糖衣構文である:

```
def my_func():
    print("original function is called.")
my_func = deco(my_func)
```

## オリジナルの関数を呼びたい

上述の通り，オリジナルの関数を完全に上書きしてしまうという特性上，これはユニットテストを行う上で弊害になることがある．

ここでオリジナルの関数のみを呼ぶためにはどうすればいいだろうか．実は標準ライブラリにある`functools.wraps`を用いれば簡潔に行うことが出来る．`functools.wraps`を用いた完全なコードを示す:

```
import functools


def deco(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print("wrapper is called.")
        func(*args, **kwargs)
    return wrapper


@deco
def my_func():
    print("original function is called.")

my_func.__wrapped__() 
```

`functools.wraps`はオリジナルの関数の`__doc__`や`__name__`といった属性をwrapperに付与することを目的としたdecorator factoryである．それだけでなく，`__wrapped__`という属性を付与する．これはオリジナル関数へのアクセスを提供する．

実際，このコードは以下を出力する：
```
original function is called.
```
