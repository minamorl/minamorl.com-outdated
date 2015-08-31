# minamorl.com

This repo is full sources of my website [http://minamorl.com/](http://minamorl.com/).

[![Circle CI](https://circleci.com/gh/minamorl/minamorl.com.svg?style=svg)](https://circleci.com/gh/minamorl/minamorl.com)

## Requirements

- nodejs
- gulp

## Setup

1. Clone this repo.

2. In working directory, just type:

```
$ sudo npm install
$ gulp
```

Gulp automatically launch `bower install`, compiles all files to dist directory. If all tasks are successfully finished, you can see my site in your browser at localhost:8000.

## Deploying

Deploying is very simple. Just push this repo to github, then CircleCI will run `gulp deploy` task and push to production server.
