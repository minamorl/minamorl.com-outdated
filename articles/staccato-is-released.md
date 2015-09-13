---
title: Python向けtwitter API ラッパー「staccato」をリリースした
timestamp: 2015-09-11T17:29:58+0900
---

## staccato

![staccato logo](/bucket/8dabb81766f30e7627b9633acd752a7f05ca63f4.png)

個人で開発している別のプロダクトで使うようのTwitter関係のライブラリを探していて、以前はtweepyという非常に素晴らしいものが存在していたのだが、Python2から移行期に使えなくなり（現在は不明。もしかしたら使えるかも）毎回requestsだよりとはいえほそぼそと手書きする生活を送っていた。

いい加減毎回似たようなコードを書くのもしんどいし、かといってめぼしいライブラリもないため自前で作った。

自分の必要に応じて足していくので開発進度や安定性はあまり重視していない。0.0.3なので長い目で見ていただきたいといった感じ。

[<span class="octicon octicon-link-external"></span> minamorl/staccato](https://github.com/minamorl/staccato/)

```python
import staccato

# oauth1 authentication.
api = staccato.startup()
api.auth(consumer_key, consumer_secret, access_token_key, access_token_secret)

# update status
response = api.statuses_update(status="Hello, world!")

# response object is simply JSON-parsed value.
print(response)

# And you can also do this...
api.statuses_destroy(response['id'])
```

とこのような感じで動く。
