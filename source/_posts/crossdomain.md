# 网络 -- cookie / session / 跨域 

## cookie

- 什么样的数据适合放在cookie中？ 身份认证有关的，还有cookie的基本属性
- cookie是怎么设置的？
- cookie为什么会自动加到request header中？
- cookie怎么增删查改？

### cookie 是干什么的？

- 通常用于身份认证
- 存储cookie是浏览器提供的功能
- 发送http请求时浏览器会自动从cookie文件夹中找对应的cookie
- 放到request请求头上
- 如果什么都放的话增加网络开销
- 每个域名下最大4kb，做多20个

### cookie属性

- expires1.0 -> max-age http1.1 请求有限时间，负数 session 0 删除cookie 正数 创建时刻 + 正数 
- domain & path 域和路径，限制了cookie能被哪些URL访问
- secure 安全 在确保安全的请求中才会携带cookie，默认不设置，如果设置了只有在https时，js才可以设置cookie
- httpOnly js无法（读取，删除，修改）cookie

### 如何设置cookie

- 服务端 Set-Cookie
- 客户端 客户端无法设置httpOnly

### 跨域如何发送cookie

1. xhr.withCredentials
2. 服务端 Access-Control-Allow-Credentials:true
3. 服务端 Access-Control-Allow-Origin 必须设置成对应域名，否则，浏览器还是会挡住返回的跨域请求
这样浏览器才会把cookie加入到请求中

## session

存于服务器端，多了会影响性能，更加安全

## 跨域

### 啥是跨域

跨域是浏览器的一种安全措施。  
违反同源策略的请求即为跨域请求  

- 同协议
- 同域名
- 同端口

同源策略限制的内容有：

- cookie、localStorage、SessionStorage等存储
- AJAX请求
- DOM节点

允许跨域的标签
- img src
- form 只发送不要求返回
- link
- script

### 为什么要有跨域

如果没有跨域

到处都是csrf

- 你登陆了淘宝
- 这时你点开了A.com
- A.com 向 taobao.com 发送获取你的信息
- A所有者有了你的信息

随意利用DOM

- 钓鱼网站iframe 嵌入真实网站
- 添加事件
- 获取你的账户密码

### 解决跨域

#### jsonp

```js
function jsonp(url, data, cb){
  return new Promise((resolve,rej) => {
    var script = document.createElement('script')
    window[cb] = function(res){
      resolve(res)
      console.log(res)
      document.removeChild(script)
    }
    let params = '/?'
    for(let d in data){
      params += d + data[d]
    }
    script.url = url + params + '?callback=' + cb
    document.appendChild(script)
  })
}
jsonp('http://localhost:4000/jsonp',{a:'a'},'cb').then(res=>{})
```

```js
const Koa = require('koa')
const app = new Koa()
app.use(ctx => {
  ctx.body = `${ctx.query}('我是Adam Lin')`
})
app.listen(4000)
```

#### 反向代理

使用nginx反向代理实现跨域，是最简单的跨域方式。只需要修改nginx的配置即可解决跨域问题，支持所有浏览器，支持session，不需要修改任何代码，并且不会影响服务器性能

- 原理： 同源策略对服务器不加限制

#### CORS

后端设置了cors即可解决跨域
IE8，9 XDomainRequest

简单请求 / 复杂请求

#### postMessage

- 页面与其打开窗口通信
- 页面与子iframe通信
- 多窗口之间通信
- 以上的跨域都可解决

iframe 可用此方法通信

#### websocket

- 双工通信，一旦建立链接，与http无关

#### node代理服务器转发请求

- 原理： 同源策略对服务器不加限制

#### window.name + iframe
#### document.domain + iframe

