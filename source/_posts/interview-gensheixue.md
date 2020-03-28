---
layout: post
title: 2020春季社招真题 -- 跟谁学
subtitle: 高途课堂 
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 面试
tags:
  - 面试
---

## 一面

- `css3`特性
- 深拷贝浅拷贝
- `Vue-router` 机制
- `koa`和`express`区别
- `node`和`js`区别
- `es6+`特性
- 对`教育行业`有什么看法
- 对未来期望

- 编程 十进制转二进制
- 思考 5L杯子 3L杯子 倒出4L 水无限
- xL， yL杯子 倒出 zL水 `leetcode 365` (我的想法是 bfs+回溯，实际上是有公式的贝祖定理 n(x+y)  
`贝祖定理`告诉我们，ax+by=z 有解当且仅当 z 是 x,y 的最大公约数的倍数。因此我们只需要找到 x,y 的最大公约数并判断 z 是否是它的倍数即可。  

## 二面

- 打印结果 考了 `this` 和 `引用赋值`  

```js
Var name = ‘dawang’

var a = {	name: 'xiaowang'}

function callName(){console.log(this.name)}

a.func = callName

Console.log(a.func === callName)

callName()
A.func()
```

- 聊聊`vue生命周期`
- 总体来说比较简单，项目聊了半小时吧大约。

## 三面（前百度T9大佬，刚跳过来，知识面的广度真的强

- 项目介绍
- 微前端具体实现
- 其他大厂的微前端看过么
- 蚂蚁金服的`乾坤`和你们的区别 （ 这个大佬是面试中为数不多提到乾坤的，我一听，这说明真的了解微前端
- 如何解决 `jsEntry` 的缺点 （ 还好我了解的也是比较深刻的，确实这些坑都是自己踩过的
- 微前端：路由问题如何解决
- 微前端：如何解决依赖问题
- 微前端：如何做到应用隔离
- 都有哪些offer了，如果和`字节`待遇一样是否会考虑我们呢 （🙄️

## 总结

- 在`在线教育`领域确实有独到之处

你猜我选谁？🧐
