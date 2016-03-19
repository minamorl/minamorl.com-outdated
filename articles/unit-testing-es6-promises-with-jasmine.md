---
title: Unit Testing ES6 Promises with Jasmine
timestamp: 2016-03-20T02:22:54+0900
---

From Version 2.0, jasmine provides asynchronous support for testing asynchronous tasks. `beforeEach`, `it`, and `afterEach` takes one optional argument `done`, which provides the way to notify the async task is completed.

This is a small example for testing Promise object with Jasmine (This code will only work on babel with ES6 polyfills):

```javascript
describe("Sample spec", () => {
  it('should be pass', done => {
    new Promise((resolve, reject) => {
      resolve()
    }).then(() => {
      // Finish up the test.
      done()
    })
  }
})
```

Jasmine will stop the spec execuation until `done()` is called. If `done()` is never called, jasmine will wait 5 seconds by a default. This value is provided by `jasmine.DEFAULT_TIMEOUT_INTERVAL`. These specification are noted on [the official document](http://jasmine.github.io/2.0/introduction.html#section-41).
