---
title: redis-orm v0.1.0 Released 
timestamp: 2015-12-10T22:12:12+0900
---

## What is 'redis-orm'

Simple object-relation mapper inspired by redis-py and SQLAlchermy. Redis is a in-memory database system. It is simple, fast, but it only provides primitive interfaces. **redis-orm** solves this problem as a Pythonic-way.

It uses redis hashes effectively, provides many useful functions, automatic conversions between User-defined classes and Redis hashes, and so on.

## How can I download it?

You can download via pip. Just type:

```
pip install redis-orm
```

## How it works

For first, you may declare your class which you want to persistent as derivered from `redisorm.core.PersistentData`. For example, we want to define User class like as above:

```
class User(redisorm.core.PersistentData):
  def __self__(self, id=None, username=None, password=password):
    self.id = id
    self.username = username
    self.password = password
```

As you can see, you must define `id` argument. Okay, so lets save this one to Redis server:

```
p = redisorm.core.Persistent()

p.save(User(username="abc", password="def"))
```

**redis-orm **automatically detects inside `__init__`, and cast every arguments declared in constructor into string, then save it into Redis server. So  lets read this one from server.

```
user = p.load(User)
user.id # => 0
user.username # => abc
user.password # => def
```

For more details, please [read the docs](https://github.com/minamorl/redis-orm/).
