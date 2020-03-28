---
layout: post
title: 2020春季社招真题 -- 知乎
subtitle: 部门 知乎社区
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 面试
tags:
  - 面试
---

最惨的面试经历，让我认识到了`简历`的重要性！必须360度无死角！经过本次面试之后，我的简历修改到无敌！(去阿里面专家的时候，大佬直接问我简历改过几遍，足以证明简历的重要性

## 一面

- Vue，react为什么要用key（一面没答好，二面还问了这个

- 为什么要使用RAF（`requestAnimationFrame`），和 `setTimeout`   区别在哪里

1. 不掉帧，更加流畅
2. Cpu使用率更低了，屏幕非激活状态下不执行回调

- 为什么 `reducer` 要使用 `pure function`，如果不用会怎样 （ 我根本不熟React技术栈，一顿问我这个，就是因为我简历上写了这个关键词！

1. 返回相同`state` 有可能会造成数据修改但是`redux`对比时没发现导致没更新
2. 如果调用了`Date.now()` 会每次结果都变化，无法`时间旅行`，或者写自动化测试脚本
3. 如果做了异步请求。 导致 返回结果修改不到`state`，不能保证`可预测性`

- 浏览器`为什么要加跨域`，如果不加会怎么样 (直接问懵逼，发现自己确实没有理解透彻！回去重看了一遍，之后所有的跨域全部完美回答！刷题的必要性！
- 工程中遇到哪些困难印象深刻（ 面试官实际上是对你的项目不太熟悉才会问这个的
- webpack `loader`执行顺序
- `webpack`优化，分chunk，粒度如何区分
- `promise`问题`A+`语法
- flex 计算 `grow` 和 `shrink`

## 二面

- `React` 生命周期函数（ 简历失误！！！！！！我就不该写！
- `Redux action`是个啥 （ 你看你看我都和他说了不熟，他还是要问！
- Vue，react为什么要用key，没有key会怎么样 （ 这回我答对了
- `Webapck` 热重载如何实现 不刷新页面替换文件 
- 除了`jsonp`还有哪些异步加载js的技术
- `csrf` 攻击

## 总结

- 把知识点吃透
- 简历不要出现答不上来的问题

二面之后心态炸了，为什么知乎的面试官脑回路这么清奇。后来静下心来想了想，不是面试官的问题！是我确实`没有把这些问题搞懂`！又闭关了三天，出来感觉随便面！（又膨胀了哈哈哈