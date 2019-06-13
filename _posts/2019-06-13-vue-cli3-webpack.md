---
layout: post
title: "Vue-cli3打包配置详解"
subtitle: "How to config Vue-cli3's webpack file -- vue.config.js"
author: "malin"
header-img: ""
header-bg-css: "linear-gradient(to right, #24b94a, #38ef7d);"
tags:
  - vue
  - vue-cli
  - webpack
---

> 羽坛一代名将，李宗伟于今日退役。 愿天堂，呸呸呸，愿大佬战胜病魔享受幸福人生！🎉🎉🎉

## Vue-cli 利弊
曾经有个小伙伴问我，大佬Vue-cli有啥好处啊？我是这样回答他的：
> “好处就是集成了很多配置”

小伙伴又问了，那坏处是啥啊，我是这么回答的：
> “坏处就是集成了很多配置”

是不是有种``“成也风云，败也风云”``的感jio~,没错，对于我来说就是这样<br/>

Vue-cli集成了大量的webpack配置，直接配置好了<code>loader</code>，<code>babel</code>甚至<code>eslint</code>,对于开发来说，你可以直接写代码然后运行一行

```node
npm run serve
```

就可以看到你写的页面了。看似非常的方便，但对于初学者来说，会造成``知其然，不知其所以然``，这就是为什么Vue官网上在对Vue-cli的介绍上写着几个赫然大字：“请注意我们```不推荐```新手直接使用<code>vue-cli</code>”<br/>

因为Vue-cli本身做了大量的webpack配置，``2000``多行的配置代码😱😱😱👉👉👉(包括[webpack-chain配置源码](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-service/lib/config) 共``784``行，[vue-cli/packages/@vue/cli-service/lib/Service.js](https://github.com/vuejs/vue-cli/blob/dev/packages/@vue/cli-service/lib/Service.js) 共``423``行, [vue-cli/packages/@vue/cli-service/lib/options.js](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/options.js) ``145``行，[webpack插件配置](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/options.js) ``731``行)，才使得你开发起来很方便🙂🙂🙂，但是在修改他的配置的时候我才发现了，cli的最大诟病🐷：

> 改起来是真滴费劲！！

本文章主要是针对Vue-cli的自定义webpack配置做分析: 

## vue.config.js 🐛

当你执行完Vue-cli的init命令之后,你就会发现，并没有webpack.config.js，只有一个vue.config.js。基本上你的webpack配置都会写入这个文件，并且通过 [webpack-merge](https://github.com/survivejs/webpack-merge) merge合并到Vue-cli的webpack配置中

### 简单的配置方式
调整 webpack 配置最简单的方式就是在 vue.config.js 中的 configureWebpack 选项提供一个对象：

```js
// vue.config.js
module.exports = {
  configureWebpack: {
    plugins: [
      new MyAwesomeWebpackPlugin()
    ]
  }
}
```

这里就有``坑``了！！！由于vue.config.js里面的变量名有的和webpack不一致，导致你可能会配置错误。

> 有些 webpack 选项是基于 vue.config.js 中的值设置的，所以不能直接修改。
> 例如你应该修改 vue.config.js 中的 outputDir 选项而不是修改 output.path；
> 你应该修改 vue.config.js 中的 publicPath 选项而不是修改 output.publicPath。
> 这样做是因为 vue.config.js 中的值会被用在配置里的多个地方，以确保所有的部分都能正常工作在一起。

### 链式操作（高级）
利用[webpack-chain](https://github.com/neutrinojs/webpack-chain) 修改配置
> 当你打算链式访问特定的 loader 时，vue inspect 会非常有帮助。

#### 修改 Loader 选项

#### 替换一个规则里的 Loader

