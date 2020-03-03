---
layout: post
title: css布局
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - css
tags:
  - css
---

## css 布局重中之重

### display
#### margin: auto

```css
.block{
  width:15px;
  /* 设置宽度后 设置margin auto 水平居中，缺点是当浏览器小于元素宽度会显示水平滚动条 */
  margin: 0 auto;
}
```

<!--more-->
#### max-width

```css
.block{
  /* 可缩放，在移动设备上尤为重要 ie7+ */
  max-width: 600px;
  margin: 0 auto;
}
```

#### box-sizing

```css
/* 这个属性可以改变 盒子模型 ie8+ */

.block-content-box{
  /* 默认值 常规盒子模型 width = content */
  box-sizing: content-box;
}

.block-border-box{
  /* 默认值 常规盒子模型  width = padding + border + margin + content*/
  box-sizing: border-box;
}
```

### position


### @media screen 响应式布局

```css
@media screen and (min-widh:600px){
  nav{
    float: left;
    width: 20%;
  }
  section{
    margin-left:20%;
  }
}
@media screen and (max-width:599px) {
  nav li{
    display: inline;
  }
}
```

### 文字多列

```css
.text{
  /* ie9+ */
  column-count: 3;
  column-gap: 1em;
}
```

### flex

```css
.container{
  display: flex;
  justify-content: center;
  align-items: center;
  width: 500px;
  height: 400px;
}
.first{
  /* width = 600- 600*1 / (600*1+200*2) * (600+200-500) */
  /* width = 600- 600 / 1000 * 500 * 300 */
  /* width = 600 - 180 = 420px */
  flex: 1 1 600px;
}
.second{
  /* width = 500 - 420 = 80 */
  flex: 1 2 200px;
}
```

### position: sticky 粘性布局

超过阈值前是 `相对布局relative`  超过阈值之后是 `固定布局fixed`  

在 `viewport` 视口滚动到元素 `top` 距离小于 `10px` 之前，元素为`相对定位`。之后，元素将`固定`在与顶部距离 `10px` 的位置，直到 `viewport` 视口回滚到阈值以下  

```css
.spin{
  display: sticky;
  top: 10px;
}
```