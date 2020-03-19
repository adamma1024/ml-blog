---
layout: post
title: 最准确 简易版 防抖 - 节流 代码
subtitle: 对发错误❌文章的人，要重拳出击
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 手写代码
tags:
  - js
---

> 掘金上`防抖`-`节流`代码有很多，我当时也是看了一篇**star**最多的学的。其余的没太注意  
> 但结果 他写的是  **错误**  的，面试的时候要不是我反应快，真的懂了原理，就被他搞崩了🙀🙀🙀。  
> 反正觉得挺坑人的，发**blog**，如果做不到准确的话那分享出去岂不是**害人**么？  
> **最骚的**是他的那篇文章*点赞数*👍🏻是最多的，你敢信？（这说明有多少人被他坑了。。。）  
> 话不多说,上代码

我会讲解两个方法的思想，记住一定要把握 **思想**！
> ps:那篇文章的防抖没啥问题，节流是有问题的。

<!--more-->
## 代码

```js
// 防抖
// 思想：每次触发，重置定时器⏰
function debounce(func, timer){
    let hasTime = null
    return (...args) => {
        // 防抖的精华在于下面这行代码👇 重置计时器❗️
        clearTimeout(hasTime)
        hasTime = setTimeout(()=>{
            func.call(this, ...args)
        }, timer)
    }
}
// 一定要写测试代码，在控制台跑一跑
var a = ()=>{console.log('aaa')}
var b = debounce(a,2000)
b()
b()
...
```

```js
// 节流
// 思想：每次执行完，才能重置定时器⏰
function throttle(func, timer){
    let bool = false
    return (...args) => {
        if(bool) return
        bool = true
        setTimeout(()=>{
            func.call(this, ...args)
            // 重点在于，执行完才能做下一个❗️
            bool = false
        },timer)
    }
}
// 一定要写测试代码，在控制台跑一跑
var a = ()=>{console.log('aaa')}
var b = throttle(a,2000)
b()
b()
...
```

下面是lodash的源码，嗯lodash的节流使用防抖实现的。因为lodash的防抖功能很强大。可以控制方法在计时开始或结束时执行

源码行数太多，我这是缩略版，[完整版戳我👈🏻](https://github.com/lodash/lodash/blob/master/debounce.js)

```js
// lodash 防抖
function debounced(...args) {
    const time = Date.now()
    const isInvoking = shouldInvoke(time)
    
    lastArgs = args
    lastThis = this
    lastCallTime = time
    
    if (isInvoking) {
      if (timerId === undefined) {
        return leadingEdge(lastCallTime)
      }
      if (maxing) {
        // Handle invocations in a tight loop.
        timerId = startTimer(timerExpired, wait)
        return invokeFunc(lastCallTime)
      }
    }
    if (timerId === undefined) {
      timerId = startTimer(timerExpired, wait)
    }
    return result
}
```

```js
// lodash节流传了俩参数给防抖
function throttle(func, wait, options) {
  let leading = true
  let trailing = true

  if (typeof func !== 'function') {
    throw new TypeError('Expected a function')
  }
  if (isObject(options)) {
    leading = 'leading' in options ? !!options.leading : leading
    trailing = 'trailing' in options ? !!options.trailing : trailing
  }
  // 👇 这里调用了防抖
  return debounce(func, wait, {
    leading,
    trailing,
    'maxWait': wait
  })
}
```

## 总结

> 知之为知之，不知为不知，是知也。

看文章一定要自己动手实验！吃一堑，长一智吧🤮