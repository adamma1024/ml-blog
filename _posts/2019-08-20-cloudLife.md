---
layout: post
title: 我的云生活 -- node 安装
subtitle: How to install node in Ubuntu 🍔
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
tags:
  - ubuntu
  - node
---

# 题记

> 有几种方法吧，也是有点坑记录下吧    

- 下载node官网的包-解压-修改环境变量
- 使用apt-get直接安装

## 第一种

> 过程比较麻烦不作为重点讲解，丢个[链接](https://www.bilibili.com/video/av62585155?from=search&seid=10466364756648314194)自己瞅瞅吧  

## 第二种

1. 安装 `curl`
2. 执行 `curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -`（默认绑定的node4.x，需要修改）
3. `sodu apt-get install nodejs`
4. `sodu apt-get install npm`
5. `sodu npm install npm -g`
6. `sodu npm install cnpm -g`
7. 最后还是需要配置环境变量💔💔💔


## 好用的插件

1. zsh
2. tmux

## 总结

很气啊，为啥apt-get还默认指向 4.x版本的node啊，我这种想用一条命令的懒人完全满足不了啊！💔
