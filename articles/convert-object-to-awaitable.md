---
title: 任意のオブジェクトをawaitableにする 
timestamp: 2016-03-02T15:14:47+0900
---

任意のオブジェクトをawaitableにするコード：
```python
def awaitable(obj):
    async def justreturn():
        return obj

    return justreturn()
```

```python
async def co():
    r = await awaitable({})
    r # => {}
```

コルーチンのユニットテストを書くときに引数をawaitしたいシチュエーションがあったので作成した．
