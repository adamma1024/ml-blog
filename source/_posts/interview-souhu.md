---
layout: post
title: 2020春季社招真题 -- 搜狐
subtitle: 部门忘了，房地产相关吧
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 面试
tags:
  - 面试
---

## 一面

- 原生js增删改查节点。前插api。`insertbefore` `appendChild` `removeChild` `replaceChild`
- `less` 特性(定义变量 方法 前缀 函数式编程 父级选择器
- node `eventloop` (timer 、pending callback 、prepare/idle 、poll、check、closecallbck
- `koa express` 区别
- `css3`选择器。(`nth-child`答错了

```css
:nth-of-type(odd / even ) 
/* odd 奇数。even 偶数 */
:nth-of-type(2) 
/* 选中父元素第二个子元素 */
:nth-last-child() 
/* 倒数第几个 */
:last-child
/* 。倒数第一个子元素 */
```

- 水平垂直布局 定宽高，不定宽高
- `css`选择器优先级
- px，em，rem区别 rem根元素字体大小
- 如何`清除浮动` 将问题转移到bfc上
- 浏览器 `eventloop`
- webpack过程
- webpack优化 多线程 loader缓存。分chunk  摇树 压缩 混淆
- `es6+`语法 
- let const 和var区别
- 变量提升

## 二面

- 为什么`node`可以解析js （ 因为用了V8
- `node`为什么要用`V8`做引擎
- `V8`引擎如何解析js，他对js做了哪些优化
- 你用node做了什么
- 微前端架构都有哪些实现方式
- 写的loader是干什么的
- loader如何实现
- 使用了什么插件去解析`ast`语法树
- `plugin`和`loader`的区别
- `comlier` 和 `compliation` 区别
- Vue写过函数式组件么,了解过高阶组件么
- 编程题 偏函数

```js
function a(num){
	return num +1
}
Function b(num){
	return num *2
}
实现个函数c，要求
c(a,b)(5) // 11
c(a,b,c,d…)(5)


function c(...args){
    let stack = []
    stack.push(...args)
    return function(arg){
        while(stack.length !== 0){
            let func = stack.pop()
            arg = func(arg)
        }
        return arg
    }
}
```

## 三面(北大硕士

三面之前hr就和我说过，北大硕士，比较重视计算机原理和算法

- -1在内存中如何存储（我说的原码 10...01，说错了，负数应该是以补码的形式存储 11...11
- transform实现个动画
- 算法题： 52张扑克牌，每个颜色13张，不算大小王 ，分给四个人。求一人拿到4张A的概率，用数学表达式表示（A44
- 其他的问题记不住了
- 问了问大学的专业，为啥要学编程

除了-1也都答对了