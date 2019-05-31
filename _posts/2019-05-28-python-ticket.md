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
不管了我也要撸一个出来！**幸好还有6.1的加场可以抢**<br/>

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

#### chromedriver
火狐浏览器请选择Firefoxdriver
首先这里有坑
- 版本必须匹配！
- [阿里镜像](https://npm.taobao.org/mirrors/chromedriver/)
- **运行时如果出现闪退，并且版本没问题的时候请重启。**我重安了好多次版本不对会直接报错，如果闪退请重启电脑就好了

#### 开发工具vscode
其他的也行，主要要安装好python插件

#### vscode插件 Python
<code>Python</code>这个插件实际是是由很多个python插件组成的
- 代码提示
- python格式化
- 缩进
- 语法高亮
- ... ...

确实非常的好用，**强力推荐**，其他的IDE就得自己查了，加油！

### 开始写第一个python程序！

> 首先你需要一个好老师，[Python-100-Days(什么？从新手到大师才100天？)](https://github.com/qq240814476/Python-100-Days)，还有[python爬虫精华](https://github.com/qq240814476/PythonSpiderNotes)都是不错的入门读物！强力打call

```python
from splinter.browser import Browser
print('黑牛抢票，你值得拥有')
# 初始化bwr
bwr=Browser(driver_name="chrome")

# 输出 '黑牛抢票，你值得拥有'
```

看了<code>Python-100-Days</code>之后,我对python语法有了初步的认识，由于不是小白，确实是太容易上手了。有了java开发的基础很轻松就搞定了，<br/>
只是刚开始注释和缩进有点不习惯。语法方面毕竟有插件嘛，也是哪里出错了就查一查。边写遍查嘛<code>Python-100-Days</code>都快被我用成python文档了哈哈哈

首先，用模块的思想去考虑代码该怎么写。我大致分成三个文件
- main 主程序
- api 定义方法，发送请求
- config 存储静态变量

先来看下browser如何使用的：

```python
# 测试browser
def test(self): 
    bwr.visit(config.sh['whgc']['list'])  # config.sh 里面存的就是个静态的链接，bwr.visit(url)会调用指定浏览器并打开url页面
    # 时间
    friday = bwr.find_by_xpath('//li[@i_event_id="86249"]') # find_by_xpath
    satday = bwr.find_by_xpath('//li[@i_event_id="86268"]')
    sunday = bwr.find_by_xpath('//li[@i_event_id="86270"]')

    day = str(input('你想看哪场的：周五、周六、周日（时间自己查）：'))
    if day == '周六':
        day = satday
    # div = bwr.find_by_xpath('//a[@id="unlogin_div"]')
    bwr.element_class.scroll_to(day)
    day.click()
    # 一年阻塞sleep
    sleep(100)
```

有用的点：
- 找元素<code>find_by_xpath</code>比较稳，毕竟可以根据特殊属性找到对应的元素
- 点击之前先滚动过去，要不然可能会提示点错地方了
- <code>scroll_to</code>不在<code>Browser</code>类的方法里面，而是在<code>WebDriverElement</code>类里面，当然了可以用<code>Browser</code>对象的<code>element_class</code>属性来调用    **Tip：推荐大家去看源码，其实非常简单而且很清楚明了，嗯，对python好感更深了**
- 有时候，执行完你得命令浏览器会闪退，所以我通常加个<code>sleep</code>来阻塞，用来测试
- <code>Browser</code> 还给通过他API（find_by_xpath等）找到的DOM元素添加了很多方法如<code>first</code>,<code>click</code>等，详情请对类按住**ctrl+左键**看源码或者splinter文档

我不会告诉你们我**记错了时间**，然后在**写完程序的那一天才知道已经加场结束了**，😭😭😭，不过没关系我安慰着自己起码python入门了。而且写得是个玩具对浏览器操作还是太慢了，有这时间早都抢完了，所以还是要升级程序。

1. 用爬虫爬到数据
2. 筛选有用的信息
3. 用代理池发送抢票请求，确保不会被锁定ip
4. 挂在一个服务器上，如阿里云，以保证网速

期待更加NB的程序
