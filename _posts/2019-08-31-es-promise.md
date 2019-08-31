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

Class MyPromise {
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
Class MyPromise{
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

```js
// 加两个数组当栈
Class MyPromise {
  constructor(){
    // ... 添加队列
    const _fulfilledQueues = []
    const _rejectedQueues = []
  }
  
}
then(onFulfilled, onRejected){
  const {_state, _value} = this 
  return new MyPromise((onFulfilledNext, onRejectedNext)={
    const fulfilled = value => {
      try{
        if(!isFunction(onFulfilled)){
          onFulfilledNext(value)
        } else {
          const res = onFulfilled(value)
          if(res instanceof MyPromise){
            res.then(onFulfilledNext, onRejectedNext)
          } else{
            onFulfilledNext(res)
          }
        }
      } catch(e){
        onRejectedNext(e)
      }
    }
    const rejected = value => {
      try{
        if(!isFunction(onRejected)){
          onRejectedNext(value)
        } else {
          const res = onRejected(value)
          if(res instanceof MyPromise){
            res.then(onFulfilledNext, onRejectedNext)
          } else {
            onRejectedNext(res)
          }
        }
      } catch (e) {
        onRejectedNext(e)
      }
    }
    switch(_state){
      case Pending
        this._fulfilledQueues.push(onFulfilledNext)
        this._rejectedQueues.push(onRejectedNext)
        break
      case Fulfilled
        fulfilled(_value)
        break
      case Rejected
        rejected(_value)
        break
    }
  })
}
```

## 队列运行

```js
_resolve(val){
  const run = () => {
    if(this._status === Pending) return
    this._status = FULFILLED
    const fulfillRun = (value) => {
      let cb
      while(cb = this._fulfilledQueues.shift()){
        cb(value)
      }
    }
    const rejectedRun = (err) =>{
      let cb
      while(cb = this.onRejectedNext.shift()){
        cb(err)
      }
    }
    // 如果val 是 promise
    if(val instanceof MyPromise){
      val.then(value=>{
        this._value = val
        fulfillRun(value)
      }, err=>{
        this._value = err
        rejectedRun(err)
      }rejectedRun)
    } else {
      this._value = val
      fulfillRun(val)
    }
  }
  setTimeOut(run, 0)
}
_rejected(err){
  if(this._status === Pending) return
  const run = () => {
    this._status = Rejected
    this._value = err
    let cb
    while(cb = this._rejectedQueues.shift()){
      cb(err)
    }
  }
  setTimeOut(run, 0)
}
```