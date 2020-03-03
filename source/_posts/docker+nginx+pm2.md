---
layout: post
title: Docker🐳+Nginx+WebHook+Node 一键自动化持续部署
subtitle: 实现可移植，持续自动集成系统
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 自动化部署
tags:
  - 前端知识体系
---

> 🐳`Docker` 跨平台移植 + `Nginx` 代理 + `webhook`自动监听git push  = 一行命令即可运行自动持续部署系统

本篇文章带你从头搭建上述系统，适用于静态网站或前后端分离式网站  

> 非静态网页请看 👉🏻  [Docker🐳+Nginx+WebHook自动化持续部署2.0](/2020/03/03/docker+Nginx+blog)  

记录了从0到1的喜悦🌈，和踩过的坑😤，希望大家都能绕过去  
如果有其他问题，请联系我，一起学习一起进步～🤝  

本文使用阿里云ESC服务器 `Ubuntu 16 64位` 搭建，如果没有买个吧，挺便宜的现在正好打折，[阿里云](https://www.aliyun.com/minisite/goods?userCode=tnz5wqkd)  

<!--more-->

如果你对Docker的使用很熟练，并且不需要了解概念，你可以直接从👉🏻[实战](#shizhan)开始看起

## Docker 安装

安装教程没问题的，我这面就不会细讲，照着敲，肯定能出来。  
👉🏻[安装教程](https://www.runoob.com/docker/ubuntu-docker-install.html)  
👉🏻[镜像设置教程](https://yeasy.gitbooks.io/docker_practice/install/mirror.html)  

```sh
# Helloworld测试
docker run hello-world
```

如果执行上述命令，出来一屏代码，并且最上面出现 `Hello from Docker!` 字样就说明你成功了

### Docker概念

#### image 镜像

> Docker 镜像是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像不包含任何动态数据，其内容在构建之后也不会被改变

```sh
# 常用命令

# 获取镜像
docker pull XXX
# 搜索镜像
docker search XXX
# 删除镜像
docker rmi XXX
# 创建镜像，通常使用Dockfile创建, . 是相对路径的意思，需要吧Dockerfile放到与命令执行目录同级
docker build -t XXX .

# Dockerfile 简易 详细的自己查下
# 从那个镜像获取
FROM nginx:latest
# 执行那些命令
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

个人总结： 镜像相当于一个封装好`配置信息`和`运行指令`的`带环境`的应用

#### container 容器

> 镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的 `类` 和 `实例` 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

```sh
# 常用命令
# 所有命令 ID 使用前三位即可
# 显示所有容器
docker ps -a
# 显示所有容器ID
docker ps -aq
# 关闭/启动/重新启动容器  
docker stop/kill/start/restart ID
# 删除容器
docker rm ID
# 删除所有容器（启动和没启动的）
docker rm $(docker ps -aq) 
# 进入容器 后面的命令行自己随意，推荐 bash
docker exec -it ID /bin/bash
# -d 后台运行 -p映射端口 前面的是docker的端口，后面的是映射到 服务器的端口
docker run -p 8000:80 -d XXX
```

个人总结： 使用时相当于 `new` 了一个 `image`，镜像开始工作了

#### Docker Registry 仓库

> 镜像构建完成后，可以很容易的在当前宿主机上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，Docker Registry 就是这样的服务

与 `npm` 仓库，类似，存储的是 `image`

### Docker-compose 安装

如果你自己尝试了 `新建image` -> `创建container` 过程，相信你一定觉得也没方便啊，很麻烦。一个都这样，那多个`协同工作`还了得？  
嗯，docker-compose就是为了解决这个问题而诞生的。  

> Compose 是用于定义和运行多容器 Docker 应用程序的工具。通过 Compose，您可以使用 YML 文件来配置应用程序需要的所有服务。然后，使用一个命令，就可以从 YML 文件配置中创建并启动所有服务。

```yml
# 快来试试威力吧
# docker-compose.yml
version: '3.1' services:
  mongo:
    image: mongo
    restart: always
    ports:
      - 27017:27017
  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8000:8081
```

接下来你只需要1行命令就可以启动配置好的容器了

```sh
# 启动
docker-compose up
```

### Nginx 镜像安装

这里只使用 `Docker` 拉取 `Nginx` 镜像  

```sh
# 如果你之前在服务器上装过，你一定知道多头疼
# 这就是docker的威力，只需要一行
docker pull nginx
```

Nginx 真正复杂的地方不在于安装，而是在于他的配置文件真的是 `又臭又长` ，对于小白十分不友好！还好本文用到的不多～

### WebHook 配置

> `Webhook` 就算你没听过，相信你一定也想过，`github` 上每次做了 `git push`如果能自动拉新代码，重启服务那该多棒。`Webhook`就是实现这个操作的关键  

webhook 顾名思义，是 网络钩子。很容易就联想到了 Vue 生命函数钩子 和 EventEmitter ，两者都属于 发布-订阅 模式。webhook干的活也是一样的，github上的操作，从push到新建分支再到fork甚至是star，都是有对应的 Hook 的。  
下面展示一下 webhook 配置页面：  

![webhook](/img/webhook.png)

步骤：  

1. 选中任意项目
2. 选择 `setting`
3. 选择 webhook
4. 新建 webhook
5. 填写 url 密码(这两项，实战中要使用，需要记住！)
6. 选择接受数据格式
7. update webhook

## 实战

<span id="shizhan">⚓️</span>

嗯，说了这么多终于要实战了！奥利给！  

首先在你的项目中添加下面两个文件

### webhook 使用

```sh
# autoDeploy.sh
#!/bin/bash
# deploy-dev.sh
echo Deploy Project # 获取最新版代码

# 拉取代码
git pull

# 下面的先注释，等配置完 docker-compose 和 Nginx 再打开
# 强制重新编译容器
# docker-compose down
# docker-compose up -d --force-recreate --build
```

```js
const http = require('http')
const createHandler = require('github-webhook-handler') //这个插件使用前先安装 npm i github-webhook-handler -D

function run_cmd(cmd, args, callback) {
  var spawn = require('child_process').spawn;
  var child = spawn(cmd, args);
  var resp = "";
  child.stdout.on('data', function (buffer) {
    resp += buffer.toString();
  });
  child.stdout.on('end', function () {
    console.log('Deploy 完成')
    callback(resp)
  });
}

const handler = createHandler({
    path:'/resume-hook', // url 后缀
    secret:'xxxxxxx' // 你的密码
})

// ❗️ 注意要在阿里云安全组里面添加开放端口
// ❗️ 还要在ubuntu防火墙关闭对应端口
http.createServer((req,res) => {
  handler(req,res,err => {
    res.statusCode = 404
    res.end('no such location')
  })
}).listen(7778, () => {
  console.log('Webhook listen at 7778')
})

handler.on('error',err => {
  console.error('Error',err.message)
})

// 拦截push，执行 Deploy 脚本
handler.on('push', function (event) {
  console.log('Received a push event for %s to %s', event.payload.repository.name, event.payload.ref);
  // 分支判断
  if(event.payload.ref === 'refs/heads/master'){
    console.log('deploy master..')
    run_cmd('sh', ['./autoDeploy.sh'], function(text){ console.log(text) });
  }
})
```

> ❗不要忘记开放端口！！！被这个问题坑哭了都，血的教训😭

### 打包你的项目

我是用 `webpack` 打包到了 `dist` 文件夹，这个文件夹会在下一步用到，复制到 `Nginx` 容器中，用来展示页面
在配置 `docker-compose.yml` 文件时别忘了修改文件夹名称！ 
并且要将这个文件夹推送到github，看看.gitignore有没有他，有就删除  

### Nginx 和 docker-compose 配置

在你的项目中添加 nginx/conf/docker.conf，内容如下：

🔥 注意，空格都不要错，nginx配置格式要求十分严格，推荐直接复制粘贴

```sh
# 80端口是 Nginx 容器的，后面会做映射
server {
    listen 80;
    location / {
      root /var/www/html;
      index index.html index.htm;
    }
}
```

再添加docker-compose.yml文件

```yml
# 这里也有坑，version 是和你的 docker-compose版本有关的，如果报错就试试改成 3 或者 3.1
# 打包后存放的文件夹，我的叫dist！！！ 别忘了修改成自己的
version: '2'
services:
  nginx:
    restart: always
    image: nginx
    ports:
      - 80:80
    volumes:
      - ./nginx/conf/:/etc/nginx/conf.d
      - ./dist/:/var/www/html/
```

ok,大功告成这时候，将 autoDeploy.sh 后面的注释取消。git push

### 最后一步，执行webhook.js

- 进入服务器，git clone xxx
- cd xxx
- node webhook.js  (不想看日志的推荐用pm2守护进程运行)


![结果](/img/webhook_finish.png)

欢迎大家讨论，整套流程我搞了整整一天，坑太多了。最后成功了还是很开心的。但是我的bolg不能用这个方法，因为blog是用的hexo，需要hexo server才能启动。大家如果有什么建议和问题，欢迎评论👏👏！
