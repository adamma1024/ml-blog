---
layout: post
title: ES6 -- Promise源码解析
subtitle: How to coding Promise Function 🍔
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 前端
tags:
  - ES6
---

## handle

```js
const isFunction = arg => (typeof arg === 'function')
```

<!--more-->
## 优化版
```js
const PENDING = 'PENDING'
const FULFILLED = 'FULFILLED'
const REJECTED = 'REJECTED'
const isFunction = arg => (typeof arg === 'function')

Class MyPromise{
  constructor(handle){
    if(!isFunction(handle)){
      throw('...')
    }

    this._fulfillQueues = []
    this._rejectQueues = []

    this._status = PENDING
    this._value = undefined

    try{
      handle(this._resolve.bind(this), this._reject.bind(this))
    } catch(e){
      this._reject(e)
    }
  }
  _resolve(val){
    if(this._status !== PENDING) return
    this._status = FULFILLED
    const fulfilled = (vals) => {
      let cb
      while(cb = this._fulfillQueues.shift()){
        cb(vals)
      }
    }
    const rejected = (vals) => {
      let cb
      while(cb = this._rejectQueues.shift()){
        cb(vals)
      }
    }

    if(val instanceof MyPromise){
      val.then((value) => {
        this._value = value
        fulfilled(value)
      }, (err) => {
        this._value = err
        rejected(err)
      })
    } else {
      this._value = val
      fulfilled(val)
    }
  }
  _reject(err){
    if(this._status !== PENDING) return
    this._status = REJECTED
    this._value = err
    let cb
    while(cb = this._rejectQueues.shift()){
      cb(err)
    }
  }
  then(onFulfilled, onRejected){
    return new MyPromise((onFulfillNext, onRejectNext)=>{
      if(this._status !== PENDING) return
      const fulfilled = (val) => {
        if(isFunction(onFulfilled)){
          setTimeOut(()=>{
            try{
                let res = onFulfilled(val)
                if(res instanceof MyPromise){
                  res.then(onFulfillNext, onRejectNext)
                } else {
                  onFulfillNext(res)
                }
            } catch (e) {
              onRejectNext(e)
            }
          }, 0)
        } else {
          onFulfillNext(val)
        }
      }
      const rejected = (err) => {
        if(isFunction(onRejected)){
          setTimeOut(() => {
            try{
                let res = onRejected(val)
                if(res instanceof MyPromise){
                  res.then(onFulfillNext, onRejectNext)
                } else {
                  onRejectNext(res)
                }
            } catch (e) {
              onRejectNext(e)
            }
          }, 0)
        } else {
          onRejectNext(val)
        }
      }

      switch(status){
        case PENDING:
          this._fulfillQueues.push(onFulfillNext)
          this._rejectQueues.push(onRejectNext)
          break
        case FULFILLED:
          fulfilled(this._value)
          break
        case REJECTED:
          rejected(this._value)
          break
      }
    })
  }
  catch(onRejected){
    return this.then(undefined, onRejected)
  }
  static resolve(val){
    if(val instanceof MyPromise) return val
    return new MyPromise((res)=>{res(val)})
  }
  static reject(){
    return new MyPromise((resolve ,reject) => reject(value))
  }
  static all(list){
    return new MyPromise((res, rej)=>{
      let values = []
      let count = 0
      for(let [i,p] of list.entries()){
        this.resolve(p).then((val)=>{
          values[i] = val
          count ++
          if(count >= list.lenght) res(values)
        }, err => {
          rej(err)
        })
      }
    })
  }
}

 static finally(func){
   return this.then(
     res => Mypromise.resolve(cb()).then(()=>res),
     rej => MyPromise.reject(cb()).then(() => {throw rej})
   )
  })
 }
```
