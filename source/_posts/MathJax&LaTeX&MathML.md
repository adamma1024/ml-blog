---
layout: post
title: 学习笔记 -- MathJax、LaTeX、MathML
subtitle: LaTeX公式解析成SVG & MathML转SVG
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 可视化
  - 笔记
tags:
  - 可视化
  - 笔记
---

> 研究研究前端中公式解析成SVG的三方库，又要阅读纯英文文档 + 可视化技术了，激动🤪

## LaTeX

## MathJax

[📄MathJax3.0文档](http://docs.mathjax.org/en/v3.0-latest/basic/mathjax.html)

### 什么是MathJax

MathJax是适用于所有现代浏览器的LaTeX，[MathML](https://www.w3.org/TR/MathML3/)和[AsciiMath](http://asciimath.org/)表示法的开源JavaScript显示引擎。  
优势：

- 使用MathJax，数学是基于文本的，而不是基于图像的，因此它可用于搜索引擎，这意味着您的方程式可以被搜索。MathJax允许页面作者使用TeX和LaTeX表示法，MathML（以XML格式表示数学的万维网联盟标准）或 AsciiMath表示法来编写公式。MathJax可以生成多种格式的输出，包括具有CSS样式的HTML或可缩放矢量图形（SVG）图像。

- MathJax是模块化的，因此它只能在必要时加载组件，并且可以根据需要扩展为包括新功能。MathJax是高度可配置的，允许作者根据其网站的特殊要求对其进行自定义。与MathJax的早期版本不同，版本3可以打包到一个文件中，也可以作为较大捆绑包的一部分包含在那些以这种方式管理其javascript资产的网站中。

- 最后，MathJax具有丰富的应用程序编程接口（API），可用于使网页上的数学交互和动态化。ES3已使用Typescript（包含类型检查和转换为ES5的功能的javascript版本）在ES6中重写了版本3。它旨在node.js像在浏览器中一样在服务器（作为应用程序的一部分）上轻松使用。这使得包含数学的网页的预处理比版本2容易得多，因此网站可以一次执行所有数学处理，而不必每次浏览该页面时都让浏览器进行。

- MathJax能够生成可与屏幕阅读器一起使用的数学表达式的可说文本版本，从而为视障人士提供可访问性。

### 配置文件

`default.js` 是提供给你修改的。它基本上包含了`MathJax`的所有配置选项，同时有注释解释。 其他的文件就是我们联合配置文件。它们不仅仅配置`Mathjax`,还预加载了一些配置所需的文件。

#### default.js

这个文件包含了所有MathJax可用的配置选项，并附有注释和说明，你可以编辑它们来满足你的需要。

#### TeX-MML-AM_HTMLorMML.js

允许使用 TeX, LaTeX, MathML,或者 AsciiMath 符号书写公式。如果浏览器支持就处理为MathML，否则就使用Html和Css渲染。

## MathML

一种格式，如果浏览器支持，就转换为这种格式，否则转为html和css
