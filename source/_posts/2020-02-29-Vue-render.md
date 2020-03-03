---
layout: post
title: 前端知识体系-Vue源码
subtitle: 简写Vue -- Compile
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 前端
tags:
  - 前端知识体系
---

## $mount & mountComponent

platforms/web/runtime/index.js Vue.prototype.$mount 

core/instance/lifecycle.js  mountComponent 定义

<!--more-->
## globalApi & lifecycleMixin & Vue 构造函数

core/instance/index.js Vue 构造函数(调 init) lifecycleMixin 调用
core/instance/lifecycle.js  lifecycleMixin 定义 Vue.prototype._update定义
core/global/index.js initGlobalApi -> Vue.mixin 混入

## 覆盖 Vue.prototype.$mount

platforms/web/runtime/entry-runtime-with-compiler.js Vue.prototype.$mount 覆盖 （入口）

## mountComponent 调用 执行渲染和更新

new Vue -> _init -> $mount -> complier -> new Watcher -> render -> update