# 监听
pm2 del ml-blog-hook
pm2 start --name ml-blog-hook webhooks.js

# 自动部署
sh autoDeploy.sh
# 
# 启动docker-compose
# docker-compose up