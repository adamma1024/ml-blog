---
layout:     post
title:      "webpack知识点及如何优化"
date:       2019-10-12 10点24分
author:     "malin"
header-style: text
categories:
  - 打包
tags:
    - webpack
---

## hash

chunkhash  本身没变不会改
contenthash  针对内容改变才会hash  多用于 css 文件打包名字 优化

``` js
[name].[ext] //后缀
```

## devserver

contentBase 把打包之后的放到内存中读取

热模块更新  webpack.hotmodulereplaceplugin
只更新更改的模块，不会全部刷新
比如修改了颜色 只会将css模块替换  不重新加载整个页面
hot: true
hotOnly: 强制浏览器不刷新 HMR不生效也不刷新

```js
// js
if(module.hot){
  module.hot.accept('./xxx.js',function(){
    xxx()
  })
}
```

## babel 

@babel/plugin-transform-runtime 闭包引入，但是无法按需引入
polyfill会污染全局变量

## webpack 优化

### 缩小文件范围 

- `exclude` `include` `test`
- 推荐 `include`

```js
include:path.resovle(__dirname,"./src")
```

### resolve 属性

```js
// modules 指定 node_modules
// alias 使用绝对路径
// extensions 尽可能少
resolve: {
  modules: [path.resolve(__dirname, "node_modules")],
  alias:{
    react: path.resolve(__dirname,"./node_modules/react/umd/react.production.min.js")
  }，
  extensions: ['.js']
}
```

### postcss-loader 转前缀

### MiniCSSExtractPlugin

分离css  并行下载  
不能使用 style-loader 改成 minicssextractplugin.loader  
style-loader 会把 css 注入 style 属性里面，所以要换
```js
const MiniCssExtractPlugin = require("mini-css-extract- plugin");
{
  test: /\.scss$/,
  use: [
    // "style-loader", // 不不再需要style-loader，⽤用
    MiniCssExtractPlugin.loader代替 MiniCssExtractPlugin.loader,
    "css-loader", // 编译css "postcss-loader", "sass-loader" // 编译scss
  ] },
  plugins: [
      new MiniCssExtractPlugin({
        filename: "css/[name]_[contenthash:6].css",
        chunkFilename: "[id].css"
      })
  ]
```

### OptimizeCSSAssetsPlugin

压缩css  
use cssnano  

### cross-env 传参数

### css摇树

`glob-all`, `purify-css`, `purifyCss-webpack`

```js
plugins:[
  new PurifyCss({
    paths: glob.sync([
      // 需要对 html 也 tree shake
      path.resolve(__dirname,"./src/*.html"),
      path.resolve(__dirname,"./src/*.js")
    ])
  })
]
```

### js摇树

开发模式无效，方便调试
```js
// 生产模式自动开启
// dev模式需要这个
 optimization: {
   usedExports: true
 }
```

### sideEffects

false 对所有 模块 （包括css模块）都进行摇树

```js
// package.json
// false 是对 全模块 摇树
// 数组是排除  某种类型文件
sideEffects: [
  "*.css",
  "*.less"
]
```

### splitChunks

```js
splitChunks:{
  maxsize:0,  // 一般不设置
  name: true, // 对cacheGroup中的name有影响
  cacheGroups:{
    react:{
      test:/react|react-dom/,
      name: "react"
    }
  }
}
```