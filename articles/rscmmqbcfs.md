---
title: "Python Tips: dictをvalueでソートする" 
timestamp: 2016-06-12T16:29:12+0900
---

## 概略

```python
d = {1: 1, 2: 5, 3: 4, 4: 1}
sorted(d, key=d.get)
```

このようにkeyにd.getを与えることにより，次を得ることが出来る：

```python
[1, 4, 3, 2]
```

## 実用例：再頻出の単語のカウント
```python
l = ["a", "b", "c", "d", "a"]
d = dict()
for x in l:
  d[x] = d.get(x, 0) + 1
word = sorted(d, key=d.get)[-1]
print(word)
```
