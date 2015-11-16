---
title: kirari.ch リリース 
timestamp: 2015-11-15T23:21:57+0900
---
[kirari.ch](http://kirarich.com/) というサービスを作った。

先日作ったredis-ormによって実装された古き良き掲示板もとい副産物である。

Pythonが好きで仕方が無いためgunicorn+Flask+redis-ormの構成でAPI側を組んで、フロントはreactでゴリ押しした。シングルページアプリケーションとして実装しているため、フロントエンドは完全に静的ページである。

擬似ルーティング周りをreact-routerを使わずに手作りしているので地味に面倒だった。拘った箇所はHistory APIとhashで擬似的にページ遷移を実現している部分である。 

またアプリケーションを配置するためだけにplan-pyというタスクランナーを書いた。
