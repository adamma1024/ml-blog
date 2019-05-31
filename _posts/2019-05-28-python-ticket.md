---
layout:     post
title:      python--抢票软件
date:       2019-05-31 21:37:07
author:     "malin"
header-img: "img/post-bg-nextgen-web-pwa.jpg"
header-mask: 0.3
catalog:    true
tags:
    - python
    - 爬虫
    - 自动化测试
---

[黑牛抢票--抢黄牛的票，让他们无票可抢！](https://github.com/qq240814476/BlackCow)

> 今天是上海德奥gala的开票日。我一直守在那里终于等到放票，但悲催的是：在放票的那一刻，浏览器逐渐卡死。刷新多次后终于不卡了，但票也抢没了(┬＿┬)

真的很生气，老子看这么多演出最讨厌的就是黄牛。等等，身为一个程序员竟然连黄牛都抢不过这可太丢人了吧。想想人家**12306分流**是吧，我辈楷模。<br/>
不管了我也要撸一个出来！<br/>

## 选择合适的脚本语言
由于**python**的强大早已经被我的同事以及同学各种安利，我第一个想到了它。虽然之前没用过，但是没关系，事事总有第一次嘛！走，破了他！

## python

### 环境搭建
#### python
这篇文章挺好的，放个链接自己点吧，不说这种已经被说烂了的废话了。[python环境搭建](https://www.runoob.com/python3/python3-install.html)

#### splinter
> 自动化测试工具，模拟浏览器操作
[中文文档](https://splinter-docs-zh-cn.readthedocs.io/zh/latest/install.html)
这文档不是很全啊，有能力还是看英文的
[英文文档](https://splinter.readthedocs.io/en/latest/)
文档还是非常重要的，这个库是基于selenium封装的，后面会介绍遇到的**坑**！！


