---
title: Coroutineオブジェクトをユニットテストする 
timestamp: 2016-03-02T15:49:27+0900
---


```python
async def co_func():
    return True
```
```python
import asyncio


def test_co_func():
    async def do():
        resp = await co_func
        assert resp == True

    loop = asyncio.get_event_loop() 
    loop.run_until_complete(do())
```

`aio-libs/aiohttp_session`のテストコードを参考にした．`test_co_func`が内側に`do` coroutineを生成し，`run_until_complete`で呼び出している．assert式をdoの内部で呼び出しているところがポイント．
