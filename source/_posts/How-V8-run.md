---
layout: post
title: How V8 run？ 
subtitle: 是时候看看v8了
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - js
tags:
  - js
---

v8如何执行js代码的呢？主要分为：

- 编译
- 执行

## 编译过程

机器只认识机器语言，js这种高级语言需要先转成汇编语言再经过汇编语言编译器转成机器语言就是0101才能执行。
v8可以理解成一个虚拟机，虚拟机通过模拟计算机的各种功能：CPU、寄存器、堆栈等，虚拟机还具有自己的一套指令系统。
所以对于js编写者来说，不必担心自己写的代码在不同的计算机中运行结果不一致（cpu类型不同指令集不同），v8都可以转成统一标准的代码。
v8是虚拟机用来编译和执行js代码。