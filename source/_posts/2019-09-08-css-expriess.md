---
layout: post
title: css 画图与动画
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - css
tags:
  - css
---

## 图形

### 圆形

```css
.circle{
  width:50px;
  height:50px;
  border-radius: 50%;
  background: red;
}
```

<!--more-->
### 三角形

```css
.sanjiao{
  width:0;
  height:0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-bottom: 100px solid red;
}
```

### 扇形

```css
.shanxing{
  width:0;
  height:0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-bottom: 100px solid red;
  border-radius: 50%;
}
```

### 菱形

```css
.lingxing{
  width: 100px;
  height: 100px;
  background-color: #c685d9;
  transform: scaleX(0.5) rotate(45deg);
  margin: 50px;
}
```

## 动画