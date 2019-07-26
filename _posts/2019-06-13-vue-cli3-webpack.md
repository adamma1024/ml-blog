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

因为Vue-cli本身做了大量的webpack配置，``2000``多行的配置代码😱😱😱<br/>
👉👉👉(包括[webpack-chain配置源码](https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-service/lib/config) 共``784``行<br/>[vue-cli/packages/@vue/cli-service/lib/Service.js](https://github.com/vuejs/vue-cli/blob/dev/packages/@vue/cli-service/lib/Service.js) 共``423``行<br/>
[vue-cli/packages/@vue/cli-service/lib/options.js](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/options.js) ``145``行<br/>
[webpack插件配置](https://github.com/vuejs/vue-cli/blob/dev/packages/%40vue/cli-service/lib/options.js) ``731``行)<br/>
才使得你开发起来很方便🙂🙂🙂，但是在修改他的配置的时候我才发现了，cli的最大诟病🐷：

> 改起来是真滴费劲！！

本文章主要是针对Vue-cli的自定义webpack配置做分析: 

## vue.config.js 🐛

当你执行完Vue-cli的<code>init</code>命令之后,你就会发现，并没有webpack.config.js，只有一个<code>vue.config.js</code>。基本上你的webpack配置都会写入这个文件，并且通过 [webpack-merge](https://github.com/survivejs/webpack-merge) merge合并到Vue-cli的webpack配置中

### 简单的配置方式
调整 <code>webpack</code> 配置最简单的方式就是在 <code>vue.config.js</code> 中的 <code>configureWebpack</code> 选项提供一个对象：

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

这里就有``坑``了！！！由于<code>vue.config.js</code>里面的变量名有的和<code>webpack</code>不一致，导致你可能会配置错误。

> 有些<code> webpack</code> 选项是基于 <code>vue.config.js</code> 中的值设置的，所以不能直接修改。
> 例如你应该修改 <code>vue.config.js</code> 中的 <code>outputDir</code> 选项而不是修改 <code>output.path</code>；
> 你应该修改 <code>vue.config.js</code> 中的 <code>publicPath</code> 选项而不是修改 <code>output.publicPath</code>。
> 这样做是因为 <code>vue.config.js</code> 中的值会被用在配置里的多个地方，以确保所有的部分都能正常工作在一起。

### 链式操作（高级）
利用[webpack-chain](https://github.com/neutrinojs/webpack-chain) 修改配置
> 当你打算链式访问特定的 <code>loader</code> 时，<code>vue inspect</code> 会非常有帮助。

#### 修改 Loader 选项
> 对于 CSS 相关 <code>loader</code> 来说，我们推荐使用 <code>css.loaderOptions</code> 而不是直接链式指定 loader。这是因为每种 CSS 文件类型都有多个规则，而 <code>css.loaderOptions</code> 可以确保你通过一个地方影响所有的规则

```js
// vue.config.js
module.exports = {
  chainWebpack: config => {
    config.module
      .rule('vue')
      .use('vue-loader')
        .loader('vue-loader')
        .tap(options => {
          // 修改它的选项...
          return options
        })
  }
}
```

#### 替换一个规则里的 Loader
如果你想要替换一个已有的基础 loader，例如为内联的 SVG 文件使用 <code>vue-svg-loader</code> 而不是加载这个文件：

```js
// vue.config.js
module.exports = {
  chainWebpack: config => {
    const svgRule = config.module.rule('svg')

    // 清除已有的所有 loader。
    // 如果你不这样做，接下来的 loader 会附加在该规则现有的 loader 之后。
    svgRule.uses.clear()

    // 添加要替换的 loader
    svgRule
      .use('vue-svg-loader')
        .loader('vue-svg-loader')
  }
}
```

#### 修改插件选项

```js
// vue.config.js
module.exports = {
  chainWebpack: config => {
    config
      .plugin('html')
      .tap(args => {
        return [/* 传递给 html-webpack-plugin's 构造函数的新参数 */]
      })
  }
}
// 你需要熟悉 webpack-chain 的 API 并阅读一些源码以便了解如何最大程度利用好这个选项，
// 但是比起直接修改 webpack 配置，它的表达能力更强，也更为安全。

// 比方说你想要将 index.html 默认的路径从 /Users/username/proj/public/index.html 改为 /Users/username/proj/app/templates/index.html。通过参考 html-webpack-plugin 你能看到一个可以传入的选项列表。我们可以在下列配置中传入一个新的模板路径来改变它

// vue.config.js
module.exports = {
  chainWebpack: config => {
    config
      .plugin('html')
      .tap(args => {
        args[0].template = '/Users/username/proj/app/templates/index.html'
        return args
      })
  }
}
```

### 审查项目的 webpack 配置
重头戏啊来了哈，👉

```sh
//package.json里面加入这句命令
"inspect": "vue-cli-service inspect"

//然后命令行里面
npm run inspect > output.js
```

你就会发现你的目录里面多了一个output.js，进入，嗯``1155``行代码🙃🙃🙃，所有配置都在这里。
还有一些更加方便的命令

```sh
# 只审查第一条规则
vue-cli-service inspect module.rules.0
# 或者指向一个规则或插件的名字
vue-cli-service inspect --rule vue
vue-cli-service inspect --plugin html
# 或者指向一个规则或插件的名字
vue-cli-service inspect --rules
vue-cli-service inspect --plugins
```

> 当然了，推荐的还是🔥🔥🔥直接用第一条命令 <code>npm run inspect</code> 直接全部输出然后<code>ctrl + F</code> 找你要改的<br/>
> 没错，就是这么麻烦🙃🙃🙃

举个🌰：我想修改<code>CopyWebpackPlugin</code>插件的属性需要 ``五步走``

1. npm run inspect > output.js
2. 在output.js里面找到CopyWebpackPlugin的名称(config修改过的)和现有参数
3. 在vue.config.js里面修改参数
4. npm run inspect > output.js 再打印出来新的参数看看有没有加上，或者自信直接第五步
5. npm run build

来让我们走一遍流程

```sh
npm run inspect > output.js
```
```js
//找到CopyWebpackPlugin,注意下面的注释，这是这个插件在vue.config.js里面的新名字 config.plugin('copy')
/* config.plugin('copy') */
  new CopyWebpackPlugin(
    [
      {
        from: 'E:\\web_pro\\nr.os-ui\\public', // 拷贝哪里的文件
        to: 'E:\\web_pro\\nr.os-ui\\dist',     // 拷贝去何方
        toType: 'dir',                         // 新建文件夹么
        ignore: [                              // 忽略哪些文件
          '.DS_Store'
        ]
      }
    ]
  )
```

我想添加忽略文件怎么办？看看[CopyWebpackPlugin官方文档](https://www.webpackjs.com/plugins/copy-webpack-plugin/)吧

```js
// vue.config.js 里面添加
chainWebpack: config => config.plugin('copy').tap((args) => {
  args[0][0].ignore.push('output/**')  //因为里面是个数组，这个数组是args[0]所以这个参数里面的第一个子元素是args[0][0]
  return args
}),
```

```js
//添加成功
/* config.plugin('copy') */
  new CopyWebpackPlugin(
    [
      {
        from: 'E:\\web_pro\\nr.os-ui\\public', // 拷贝哪里的文件
        to: 'E:\\web_pro\\nr.os-ui\\dist',     // 拷贝去何方
        toType: 'dir',                         // 新建文件夹么
        ignore: [                              // 忽略哪些文件
          '.DS_Store',
          'output/**'
        ]
      }
    ]
  )
```

```sh
npm run inspect > output.js
```

大功告成了！这简直也太快乐😊（mafan）了8

## 构建

### 库library

首先你应该先去学习[webpack library相关知识](https://www.webpackjs.com/configuration/output/#output-library)<br/>
然后你就可以通过这行命令打出你所需要的：

```sh
vue-cli-service build --target lib --name myLib [entry]
# File                     Size                     Gzipped

# dist/myLib.umd.min.js    13.28 kb                 8.42 kb
# dist/myLib.umd.js        20.95 kb                 10.22 kb
# dist/myLib.common.js     20.57 kb                 10.09 kb
# dist/myLib.css           0.33 kb                  0.23 kb
```

#### Vue vs. JS/TS 入口文件

> 当使用一个 .vue 文件作为入口时，你的库会直接暴露这个 Vue 组件本身，因为组件始终是默认导出的内容。
> 然而，当你使用一个 .js 或 .ts 文件作为入口时，它可能会包含具名导出，所以库会暴露为一个模块。
> 也就是说你的库必须在 <code>UMD</code> 构建中通过 <code>window.yourLib.default</code> 访问，
> 或在 <code>CommonJS</code> 构建中通过 <code>const myLib = require('mylib').default</code> 访问。
> 如果你没有任何具名导出并希望直接暴露默认导出，你可以在 <code>vue.config.js</code> 中使用以下 <code>webpack</code> 配置：

```js
module.exports = {
  configureWebpack: {
    output: {
      libraryExport: 'mlLibrary' //你得库的名字
    }
  }
}
```

### Web Components 组件
<code>web components</code> 由于兼容性并不适用于ie11一下，所以不介绍了。可以自行了解，👉[传送门](https://cli.vuejs.org/zh/guide/build-targets.html#vue-vs-js-ts-%E5%85%A5%E5%8F%A3%E6%96%87%E4%BB%B6)
