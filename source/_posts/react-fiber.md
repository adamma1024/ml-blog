---
layout: post
title: 前端知识体系-React源码
subtitle: Fiber+时间分片 解读
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - React
tags:
  - 前端知识体系
---

<!--more-->
## fiber

将 虚拟dom树 转成 单向链表

## requestIdleCallback

[MDN文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/requestIdleCallback)

render   空闲  task 空闲

```js
// 第二个参数 options timeout 超长时间 超过了强制执行 对性能可能不好

const func = (IdleDeadline)=>{
  while(IdleDeadline.timeRemaining() > 1){
    // 执行要做的工作
  }
  // 再塞一次
  requestIdleCallback(func) 
}

requestIdleCallback(func)
```

## 源码

react react-dom（render）复杂的  schduler调度 MessageChannel performance.now 精度比 date。now高


任务分解   树形 变  链表
空闲调度 request
