---
layout: post
title: 前端知识体系-运行环境
subtitle: base knowleage of runtime env
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 前端
tags:
  - 前端知识体系
---

我们需要理清语言和环境的关系：

> ECMAScript描述了JavaScript语言的语法和基本对象规范  
> 浏览器作为JavaScript的一种运行环境，为它提供了：文档对象模型（DOM），描述处理网页内容的方法和接口、浏览器对象模型（BOM），描述与浏览器进行交互的方法和接口  
> Node也是JavaScript的一种运行环境，为它提供了操作I/O、网络等API

## 浏览器API

1. 浏览器提供的符合W3C标准的DOM操作API、浏览器差异、兼容性
2. 浏览器提供的浏览器对象模型 (BOM)提供的所有全局API、浏览器差异、兼容性
3. 大量DOM操作、海量数据的性能优化(合并操作、`Diff`、`requestAnimationFrame`等) *
4. 浏览器海量数据存储、操作性能优化 `loaclStorage sessionStorage 分布式集群部署`
5. DOM事件流的具体实现机制、不同浏览器的差异、事件代理  `捕获 命中 冒泡 target可返回事件的目标节点（触发该事件的节点） currentTarget返回其事件监听器触发该事件的元素 ie attchEvent addEventListener 第三个参数换成了options，capture once调用后删除 passive永远不会preventDefault()`
6. 前端发起网络请求的几种方式及其底层实现、可以手写原生ajax、fetch、可以熟练使用第三方库 * `fetch('url',{method: 'post',body:{},headers:{'Content-type':"application/json;charset=utf-8"}})` [xhr，ajax](https://blog.csdn.net/qq940853667/article/details/71178236)
7. 浏览器的同源策略，如何避免同源策略，几种方式的异同点以及如何选型 * `同域名 同协议 同端口 JSONP script标签只能get postMessage WebSocket document.domain子域`
8. 浏览器提供的几种存储机制、优缺点、开发中正确的选择 *  `cookie 4K 请求传递 localStorage 永久存储 sessionStorage 关闭页签清空 IndexedDB`
9. 浏览器跨标签通信 * `websocket localstorage SharedWorker 同源的`

<!--more-->
## 浏览器原理 *

1. 各浏览器使用的JavaScript引擎以及它们的异同点、如何在代码中进行区分 `navigator.userAgent`
2. 请求数据到请求结束与服务器进行了几次交互 *  `3+2+4`
3. 可详细描述浏览器从输入URL到页面展现的详细过程 **  [输入URL到页面展现的详细过程](/2019/12/27/2019-08-30-http)
4. 浏览器解析HTML代码的原理，以及构建DOM树的流程 * `html parse 构建dom css parse 构建 cssom js会阻塞dom  符号化及构建树`
5. 浏览器如何解析CSS规则，并将其应用到DOM树上 * `从右往左  选择器权重不同  内联>id>class 伪类 属性>元素 伪元素`
6. 浏览器如何将解析好的带有样式的DOM树进行绘制 * `构建renderTree  回流  重绘`
7. 浏览器的运行机制，如何配置资源异步同步加载 * `css加载阻塞渲染不阻塞dom构建 css的解析会阻塞js的执行，必须等到CSSOM生成后才能执行js html一边解析一边显示 css必须完全解析完毕才能进入生成渲染树环节  js 全阻塞  切分成小的 使用 async preload preload 是告诉浏览器页面必定需要的资源，浏览器一定会加载这些资源prefetch 是告诉浏览器页面可能需要的资源，浏览器不一定会加载这些资源`
8. 浏览器回流与重绘的底层原理，引发原因，如何有效避免 *
9.  浏览器的垃圾回收机制，如何避免内存泄漏 ** `用完的变量 置空  避免定义不必要的全局变量 避免循环依赖`
10. 浏览器采用的缓存方案，如何选择和控制合适的缓存方案 ** [浏览器缓存机制](https://www.jianshu.com/p/54cc04190252)

## Node

[node 源码解读](https://cnodejs.org/topic/5ba4b3978f5b0c1c59ea1080)
1. 理解Node在应用程序中的作用，可以使用Node搭建前端运行环境、使用Node操作文件、操作数据库等等
2. 掌握一种Node开发框架，如Express，Express和Koa的区别
3. 熟练使用Node提供的API如Path、Http、Child Process等并理解其实现原理
4. Node的eventloop、和浏览器的异同  
```js
// node 宏任务 I/O setTimeout setImmediate setInterval 代码
// 微任务 mutationObserve Promise process.nextTick 
// timer、pending callback、Idle/prepare、poll、check、close callback
timer 过程中执行 setTimeout / setInterval 队列
清空微任务队列
pending callback 执行 网络/流/ I/O操作 的错误回调
清空微任务队列
prepare node内部操作  跳过
清空微任务
poll 轮询  执行I/O操作，在开始时先计算setTimeout那些宏任务的阀值，排个队。等执行完一个I/O和回调，就优先执行接近阀值的
清空微任务
check 执行setImmediate队列，也是宏任务但是执行时机是在poll之后，优先于setTimeout 所以Vue更新视图会将它放到setTimeout之前，他要执行更快一些
清空微任务
close callback 执行 socket.close回调

nextTick 优先于其他微任务执行
```
5. Node事件驱动、非阻塞机制的实现原理
