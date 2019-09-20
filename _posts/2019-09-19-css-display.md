---
layout: post
title: css布局
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
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