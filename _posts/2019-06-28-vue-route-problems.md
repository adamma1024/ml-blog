---
layout:     post
title:      "VueRoute的那些坑~😫😫😫"
subtitle:   "实战中遇到的需要注意的地方🚨🚨🚨"
date:       2019-06-28 10点57分
author:     "malin"
header-img: "img/post-bg-alibaba.jpg"
tags:
    - vue-route
---

> 在使用vue-route的时候可能大家都遇到过这种那种坑，欢迎各位补充🤞🤞🤞

## 注意
---

### history模式，页面刷新404
---

#### 描述

1. mode设置为history
2. 页面刷新向后台发送请求
3. 返回404页面
4. 前台捕获不到这个404

#### 解决方法

1. mode改为hash（如果不愿意请看看第二条）
👉[原链接](https://blog.csdn.net/httguangtt/article/details/84847582)

2. webpack
