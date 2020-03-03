---
layout: post
title: JS隐式转换
subtitle: js implicit type conversion
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 前端
tags:
  - js
---

## 正常

- String: + 字符连接符
- Number: 自增自减 / 加减乘除余 / 关系运算符
- Boolean: ! 逻辑非运算符
- undefined 转 number NaN 转 boolean false
- null 转 number 0 转 boolean false

<!--more-->
## 特殊

- 关系运算符两边都是字符时 比较第一位unicode编码 '2' > '10' true '2'.charCodeAt() > '10'.charCodeAt()
- null == undefined true
- null === undefined false (不发生隐式转换)
- NaN == NaN false
- undefined == undefined true

## 复杂类型隐式转换中（拆箱）

- 先 valueOf 基本类型返回 否则
- toString()

## 题目

```js
a = {}
if(a == 1 && a == 2 && a == 3){
  return true
}
// 手动修改valueOf
a.i = 0
a.valueOf = function(){
  return ++a.i
}
```

```js
[] == 0 //true 先valueOf [] 再toString '' 再装箱 Number('') == 0
![] == 0 //true ! 优先级高于 == 先转boolean Boolean([]) = true !非  false Number(false) = 0

{} == {}  // false 引用地址不同
{} == !{} // Number({}.valueOf.toString '[Object Object]') NaN / Number(false) 0  NaN == 0 fales
```

## 如何避免和巧用

避免：

- 使用 === / Object.is，替代 ==

巧用：

- if()

