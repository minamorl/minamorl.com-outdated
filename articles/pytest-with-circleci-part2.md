---
title: 続・py.testとCircleCI
timestamp: 2015-09-15T04:48:25+0900
---

[前回の記事](/articles/2015-09-10T01:46:32+0900-pytest-with-circleci.html)の続き。

## 公式に連絡した結果、その顛末

CircleCIに直接問い合わせのメールを送った結果、次のような返信が帰ってきた。

> Hi there,
> 
> Thank you for sharing your finding.
> 
> We cache the packages because that makes your builds significantly faster. Looks the installation failed because of this bug in setuptools which has been already fixed.
> 
> Can you add this to your circle.yml?
>
 ``` 
 dependencies:
   pre:
     - sudo pip install --upgrade setuptools
 ``` 
>
> That should install setuptools where the bug was fixed.
> 
> The behavior that pytest runs all tests unver the directory is very worth to note in our doc. Thank you for pointing this out!

本文で指摘されているthis bugは[setuptools/issues/168](https://bitbucket.org/pypa/setuptools/issues/168)のこと。

## sudo pip installは動かない

確かに文献に上げられている通り、setuptools側の不具合らしいことが分かったのでさっそくテストしてみる。あとこれサポートに返信しておいたがCircleCIはpyvenv上に環境を構築して動いているためsudoは不要。

```
dependencies:
  pre:
    - pip install --upgrade setuptools
```

これで邪悪なコードを一つ取り除けた。嬉しい。

## CircleCIの対応について

返事は迅速で的確、非常に丁寧な印象を受けた。

素晴らしいサービスだと思う。
