---
layout: post
title: 学习笔记 -- react
subtitle: 学习react的第N天
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - react
tags:
  - react
---

## setState 同步异步

### 同步

#### 传入函数

```js
setState((newState)=>{
  return {
    counter: newState + 1
  }
})
```