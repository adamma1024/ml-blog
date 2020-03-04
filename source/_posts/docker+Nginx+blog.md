---
layout: post
title: Docker🐳+Nginx+WebHook 一行代码启动自动构建
subtitle: 一行命令，还你一个可移植自动化持续集成blog
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 自动化部署
tags:
  - Docker
---

> 我的上一篇文章，记录了如何使用[Docker🐳+Nginx+WebHook+Node](/2020/03/04/docker+nginx+pm2)  
> 但是有一个局限性，就是只能部署打包好的静态网站。那么需要命令启动的项目呢？  
> 我花了我一个晚饭的时间，终于在`泡面`🍜+`韭菜炒鸡蛋`🥚的加持下，让我想了出来！  
> 试想一下，如果你的代码能在推送的时候自动构建，写`blog`将会多么的方便？云服务器根本不需要你去维护  
> 如果我告诉你，只需启动`一行`命令就可以实现这一点，你是否心动了呢？？❤️  

本篇文章`高收益`人群：

- 云服务器搭建`blog`，但是还未配置`自动化持续部署`
- 想了解`docker + Nginx`部署
- 对`webhook`感兴趣，想了解用法
- 想学会出去`装逼`的人🤪

你的 `点赞`👍+`收藏`🌟  是我永远的动力！

<!--more-->

## 优势

### 只需一行

```sh
# 就这一行，你爱咋启动咋启动，pm2 nohup都行，就启动 oneLine.sh 就完事了
sh oneLine.sh
```

### 可移植性极高

在`Docker`的加持下，这套自动化持续部署，可以移植到各个平台。  
如果你想换云服务器，换系统。那么恭喜你，学会本篇文章，一行代码就搞定！

### 自动化持续部署

`Webhook`助力代码可以敏锐的监听到 `git push` 等 `github hook`，当你的 `project` 改变时，能够第一时间获取最新改动，并且`自动重新部署`  
我就问问你，它`不香`么？？？😆

## 实战

`Docker` + `Nginx` + `Webhook` 的基础知识请看我的上一篇文章👉🏻[Docker🐳+Nginx+WebHook+Node](/2020/03/04/docker+nginx+pm2)  
本篇文章只讲实战，直接`开撸`！

### Nginx 配置

🛑 注意别名

```sh
# nginx/conf.d/docker.conf
# 思路就是将服务的4000端口 反向代理 到 Nginx 服务 80 端口
server {
    listen 80;
    location / {
        # 注意 ml-blog 是 docker 内 另一个 镜像的 别名，并不是真实 url！
        proxy_pass http://ml-blog:4000;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### Docker 配置

Docker配置有两个：
- Dockfile + process.yml
- docker-compose.yml

Dockerfile内容：

```sh
# 拉取 pm2 镜像，用来启动你的整个项目
FROM keymetrics/pm2:latest-alpine
WORKDIR /usr/src/app
ADD . /usr/src/app
# 镜像加速
RUN npm config set registry https://registry.npm.taobao.org/ && \
    npm i
# pm2在docker中使用命令为pm2-docker
# 使用 process.yml 填写命令配置
CMD ["pm2-runtime", "start", "process.yml"]
```

process.yml 内容：

```yml
apps:
  # 写你的项目启动命令
  - script : npm run server
      # 实例数，没空研究大佬可以告诉小弟，试了1会有问题，所以写了2
      instances: 2
      # 开启监听，如果设置为true，命令异常可不断尝试重连
      watch  : true
```

docker-compose.yml 内容：

```yml
# 版本号还是要注意，需要匹配自己的 docker-compose 版本
version: '2'
services:
  ml-blog:
    # 记不记得 Nginx 配置的别名 http://ml-blog:4000，找到了吧就是容器名称
    container_name: ml-blog
    restart: always
    #构建容器
    build: .
    ports:
    - "4000:4000"
  nginx:
    # restart 出现异常就一直重连
    restart: always
    image: nginx
    # 将 Nginx 80 映射到 服务器的 80 端口
    ports:
      - 80:80
    # Nginx 配置文件 复制到指定目录下才能生效
    volumes:
      - ./nginx/conf.d/:/etc/nginx/conf.d
```

到此为止，实际上`自动化部署`已经完成，但是如果你想实现一`push`就重新构建，还需要`webhook`的配置

### Webhook 配置

这里不详细解释如何配置webhook了，具体的看我上一篇[文章](2020/03/04/docker+nginx+pm2)吧～～

```js
const http = require('http')
const createHandler = require('github-webhook-handler')

const handler = createHandler({
    path:'/XXXXX',
    secret:'XXXXXXX'
})

function run_cmd(cmd, args, callback) {
  var spawn = require('child_process').spawn;
  var child = spawn(cmd, args);
  var resp = "";
  child.stdout.on('data', function (buffer) {
    resp += buffer.toString();
  });
  child.stdout.on('end', function () {
    callback(resp)
  });
}

http.createServer((req,res) => {
  handler(req,res,err => { res.statusCode = 404
    res.end('no such location')
  })
}).listen(8000, () => {
  console.log('Webhook listen at 8000')
})

handler.on('error',err => {
  console.error('Error',err.message)
})

handler.on('push', function (event) {
  console.log('Received a push event for %s to %s', event.payload.repository.name, event.payload.ref);
  // 分支判断
  if(event.payload.ref === 'refs/heads/master'){
    console.log('deploy master..')
    run_cmd('sh', ['./pull.sh'], function(text){ console.log(text) });
  }
})
```

pull.sh 内容

```sh
#!/bin/bash
git pull

# 强制重新编译容器
docker-compose down
docker-compose up -d --force-recreate --build
```

### 最后的shell

oneLine.sh 内容

实际上就是两件事：

- pm2启动 webhook.js
- docker-compose 启动

```sh
# 监听
pm2 start --name ml-blog webhooks.js

# 启动docker-compose
docker-compose up
```
来看下成果吧！

`pm2` 监听webhook
![pm2](/img/pm2.png)

`Nginx` 容器，前两个就是咱们本次的，最下面的是我另外的`Nginx`服务
![log](/img/blog-log.png)

## 总结

这次的学习让我知道了 `Docker`和 `Nginx` 的强大！  
`Docker yes`， `Nginx yes`！ 
欢迎大家评论，一起学习，一起进步！🎉🎉🎉 
