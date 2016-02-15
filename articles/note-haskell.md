---
title: "ノート: Haskell"
timestamp: 2016-02-15T16:55:40+0900
---

このノートは個人的な学習のために書かれ，第三者によって読まれることを想定していない．

内容は予告なしに改変され，また，内容の正当性は一切保証しない．

## 状態系Monad

### State monad

getで値を取り出してmodifyで更新：
```
import Control.Monad.State

st :: State Int Int
st = do
  x <- get
  modify (+1)
  modify (+1)
  return x
```

```
runState st 3
```

### Reader monad

```
Prelude Control.Monad.Reader> flip runReader 3 $ do {return "AAA"}
"AAA"
```

`ask`を使った例：
```
Prelude Control.Monad.Reader> flip runReader "BBB" $ do {x <- ask ;return $ "AAA" ++ x} 
"AAABBB"
```

Readerを`>>=`でつなぐ：
```
Prelude Control.Monad.Reader> flip runReader "3" $ do {x <- ask ;
return $ "hoge" ++ x} >>= (\st -> do {x <- ask; return $  x ++ st})
"3hoge3"
```


