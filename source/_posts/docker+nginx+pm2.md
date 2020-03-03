---
layout: post
title: Docker🐳+Nginx+WebHook+Node 一键自动持续部署
subtitle: 实现可移植，持续自动集成系统
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - React
tags:
  - 前端知识体系
---

> 🐳`Docker` 跨平台移植 + `Nginx` 代理 + `webhook`自动监听git push  = 一行命令即可运行自动持续部署系统

本篇文章带你从头搭建上述系统，适用于静态网站或前后端分离式网站  
记录了从0到1的喜悦🌈，和踩过的坑😤，希望大家都能绕过去  
如果有其他问题，请联系我，一起学习一起进步～🤝  

本文使用阿里云ESC服务器搭建，如果没有买个吧，挺便宜的现在正好打折，[阿里云](https://www.aliyun.com/minisite/goods?userCode=tnz5wqkd)  

## Docker 安装

常用命令

### Docker-compose 安装

常用命令

## Nginx 镜像安装

常用命令
配置文件

## WebHook 配置 / Node编写


我执行了这个命令修改了密钥的格式才能被Deploy解析
ssh-keygen -p -m PEM -f ~/.ssh/id_rsa