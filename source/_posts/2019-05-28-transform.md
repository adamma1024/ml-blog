---
layout: post
title: 纪念被transform坑哭的一天
subtitle: Holy shit Transform！
author: "malin"
header-img: "img/post-bg-miui6.jpg"
categories:
  - css
tags:
  - css
---

transform也太NB了8！

1. transform 下 `z-index` 失效 (影响了`层叠上下文`)
2. transform限制`position:fixed`的跟随效果
3. transform改变`overflow`对`absolute`元素的限制
4. transform限制`absolute`的100%宽度大小

[原文链接](https://www.zhangxinxu.com/wordpress/2015/05/css3-transform-affect/)