---
title: Migrating to ES6 with Babel from CoffeeScript
timestamp: 2015-12-01T04:29:14+0900
---
Recently I decided to migrate my React projects from CoffeeScript to another alt JS. After some consideration, comparing Babel and TypeScript, and then I choose to use Babel. 

It made me nervous to write all source code written with old-aged, mature language to be replaced with better newest, awesome, cool languages.

**THAT IS RIDICUOUS.** Yeah I knew that. 

## Why I choose Babel, not TypeScript?

If you have ever made prototype.js project, then you knew same anxious of mine. To rewrite something old to new one is greatly painful.

Babel is simple polyfills of ECMAScript, so that I sure it will be next de fact standard. TypeScript is nice offer, but I don't chose it because I afraid same situation will be occurred at CoffeeScript. ECMAScript has no types, offers no type annotations like that Python 3.5+ do as a language specification.

Transforming from CoffeeScrip to ES6 took hours, but I finally made it and it works fine. Here's my work: [minamorl/everything-interface](http://github.com/minamorl/everything-interface/)

## Working React with ES6+

In my product, I use webpack to automate JS compilaton process.

Babel supports React JSX filetype as a default, so that it is not so hard to integrate react with ES6+ style. If you start React with ES6 style, you should check [this page](https://facebook.github.io/react/docs/reusable-components.html#es6-classes).

If you want to use babel with webpack, you need install `babel-loader` from npm. You shoud see official reference, especially [this section](https://github.com/babel/babel-loader#options) is helpful.

