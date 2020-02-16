hash
chunkhash  本身没变不会改
contenthash  针对内容改变才会hash  多用于 css 文件打包名字 优化

``` js
[name].[ext] //后缀
```

devserver

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

babel 
@babel/plugin-transform-runtime 闭包引入，但是无法按需引入
polyfill会污染全局变量