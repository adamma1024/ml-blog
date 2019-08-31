---
layout: post
title: ES6 -- Promise源码解析
subtitle: How to coding Promise Function 🍔
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
tags:
  - ES6
---

## handle

```js
const isFunction = arg => (typeof arg === 'function')

Class Promise {
  constructor(handle){
    if (!isFunction(handle)){
      throw('argument must be a Function!')
    }
  }
}
```

## 定义状态，修改状态

```js
// 定义状态
const Pending = 'Pending'
const Fulfilled = 'Fulfilled'
const Rejected = 'Rejected'

// 修改状态
Class Promise{
  constructor(handle){
    if(!isFunction(handle)){
      throw('...')
    }
    // 添加状态
    this._state = Pending
    // 添加值
    this._value = null
    try{
      handle(this._resolve.bind(this),this._reject.bind(this))
    } catch (err) {
      this._reject(err)
    }
  }

  _resolve (res) {
    if(this._state !== Pending) return
    this._state = FulFailed
    this._value = res
  }

  _reject (err) {
    if(this._state !== Pending) return
    this._state = Failed
    this._value = err
  }
}
```

## then