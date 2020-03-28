#!/bin/bash
git pull

# 安装依赖
cnpm i

# 清空之前的资源
npm run clean

# 打包📦生成新静态资源
npm run build

# 删除之前的public
rm -rf /usr/share/nginx/html/public

# 复制 静态资源 到 /usr/share/nginx/html/ 下
cp -r ./public/ /usr/share/nginx/html/

# 删除老pm2进程
pm2 del ml-blog

# 新建新进程
pm2 start npm --name ml-blog -- run server

# 强制重新编译容器
# docker-compose down
# docker-compose up -d --force-recreate --build