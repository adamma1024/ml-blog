---
layout:     post
title:      "VueRoute的那些坑~😫😫😫"
subtitle:   "实战中遇到的需要注意的地方🚨🚨🚨"
date:       2019-06-28 10点57分
author:     "malin"
header-img: "img/post-bg-alibaba.jpg"
categories:
  - Vue全家桶
tags:
    - vue-route
---

> 在使用vue-route的时候可能大家都遇到过这种那种坑，欢迎各位补充🤞🤞🤞

## 问题
---

### history模式，页面刷新404

#### 描述

1. mode设置为<code>history</code>
2. 页面刷新向后台发送请求
3. 返回404页面
4. 前台捕获不到这个404
5. 设置了route <code>children</code> 也会出现404，原本的静态资源找不到了 (未验证)

<!--more-->
#### 解决方法

1. mode改为<code>hash</code>（如果不愿意请看下一条😆😆😆）
2. webpack配置项中的<code>devServer</code>加上

```js
// history模式下的url会请求到服务器端，但是服务器端并没有这一个资源文件，就会返回404，所以需要配置这一项
historyApiFallback: {
	index: '/index.html' //与output的publicPath有关(HTMLplugin生成的html默认为index.html)
},
```

3. 静态资源问题解决方法

在webpack配置中添加<code>output</code>属性

```js
output: {
	// 表示在引入静态资源时，从根路径开始引入
	publicPath: '/'
},
```

👉[原链接](https://blog.csdn.net/httguangtt/article/details/84847582)

## 小结
---

欢迎大家一起完善，总结🌈🌈🌈