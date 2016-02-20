---
title: "aiohttpを用いたWebフレームワークmeadを作った"
timestamp: 2016-02-20T21:22:26+0900
---

Python3から強化されたcoroutine機能を使ってウェブフレームワークを作りました．Python 3.5未満の環境では動きません．

バージョン0.0.4で次のコードが動きます．Flaskに似てます．

```python
from mead.server import serve
from mead.objects import Router, JSONObject, response

router = Router()

@router.route("/", methods=["GET"])
def helloworld(context):
    return response(JSONObject({
        "results":"Hello, " + context["params"]["username"]
    }))

if __name__ == '__main__':
    serve(router)
```
位置づけとしては，aiohttpを用いたFlaskの代替品をめざしています．response函数はsingledispatchデコレーターを使って型ごとに異なる振る舞いをします．JSONObject型の値を渡すと自動的にcontent-typeにapplication/jsonをセットしてレスポンスを返します．

[minamorl/mead](https://github.com/minamorl/mead)
