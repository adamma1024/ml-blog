---
layout: post
title: 2020春季社招真题 -- 京东
subtitle: 泰国站
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 面试
tags:
  - 面试
---

其实京东一开始就没考虑，但还是想着面面玩玩吧，泰国站我倒要看看是干嘛的哈哈哈，萨瓦迪卡👳🏾‍♀️！

## 一面

- `css3` 特性
- 编程题 `css动画` 实现 `div从左到右`
- `scale` 缩小会不会影响原文档流占位？布局不变的！只会重绘不重排
- `border-radius`：顺序 topleft 、 topright、 bottomright、bottomleft
- 写个`box-shadow`
- 两栏布局 
- `display`有哪些属性,都啥意思
- `position`哪些属性，`relative`相对谁。相对于文档中的正常位置偏移给定的值
- `absolute`和`fixed`区别。
- `粘性布局`。相对于第一个滚动父元素
- rem、em、vh、vw
- es6+语法
- `箭头函数`和普通区别
- `promise`解决什么问题
- `proxy`干嘛的
- `vue-router`实现原理，如何`不刷新页面`更新内容
- 路由如何实现`动态加载`
- Vue生命周期
- `react` 和 `vue` 区别
- `时间分片`的设计思想
- 最近在学什么
- `samesite`了解过么，最近支付宝bug知道么

## 二面
- 手写`jsonP`
- 浏览器优化有哪些方法
- `dns解析`
- 浏览器缓存
- 算法题 买卖股票的最佳时机 `leetcode 121题`

```js
// 算法不要想着暴力法，说了相当于没说
// 这道题用贪心很简单一次遍历就出来了，其实这题我见过，但我当时没做。面试官提醒了下
// [7,1,5,4,6,3,2] 第二天买入 第五天卖出 res = 6 - 1 = 5

var maxProfit = function(prices) {
    let res = 0
    let min = Number.MAX_VALUE

    for(let i = 0; i<prices.length; i++){
        if(prices[i] < min){
            min = prices[i]
        } else if(prices[i] > min){
            res = Math.max(res, prices[i] - min)
        }
    }

    return res
}
```

## 三面（技术总监面

- 聊项目
- 职业规划
- 啥时候能入职
- 如何学习

## 四面（职位不知道啥

唯一一个四面的吧
- 对自己的职业规划
- 有自己的博客么
- 有女朋友么
- 和同年级的同学比较你觉得如何
- 有其他offer么
- 最直接的一位面试官：“是这样的，本来三面就结束了，我这一面是因为涨幅超过50%所以让我也面一下，你等下和hr聊下，给多少可以来我们这，这样也节约大家时间”🤣（心想，这也太爽快了吧！哈哈哈

## 总结

- 知识点考察的`深度`和`广度`都很好，我本以为会很水，错怪京东了，`强东`对不起！
- 要薪资流水的时候让我去银行和原单位盖章，这个超麻烦！！！！好感骤减----，`强东`对不起！

`强东`对不起！