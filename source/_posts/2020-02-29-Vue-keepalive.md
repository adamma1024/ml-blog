---
layout: post
title: 前端知识体系-Vue源码
subtitle: Vue源码阅读 -- keep-alive
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 前端
tags:
  - 前端知识体系
---

# Vue源码阅读 -- keep-alive

> `keep-alive`由于有单个js文件，所以源码跟踪挺简单的，本章会从源码解读`keep-alive`的实现

## keep-alive 是一个抽象组件

源码位置： `Vue/src/core/components/keep-alive.js`  

```js

function getComponentName (opts: ?VNodeComponentOptions): ?string {
  // TODO Ctor是什么？ 循环引用
  return opts && (opts.Ctor.options.name || opts.tag)
}

function matches (pattern: string | RegExp | Array<string>, name: string): boolean {
  // 匹配正则和字符串，用来解析 include 和 exclude 的
}

function pruneCache (keepAliveInstance: any, filter: Function) {
  // prune：清理， 清理无效的缓存
  pruneCacheEntry(...)
}

function pruneCacheEntry (
  cache: VNodeCache,
  key: string,
  keys: Array<string>,
  current?: VNode
) {
  //! 如果VNode 的 tag 变化 则会调用 destroy 钩子 销毁之前缓存的组件
  const cached = cache[key]
  if (cached && (!current || cached.tag !== current.tag)) {
    cached.componentInstance.$destroy()
  }
  cache[key] = null
  remove(keys, key)
}

const patternTypes: Array<Function> = [String, RegExp, Array]

export default {
  name: 'keep-alive',
  abstract: true, // 抽象组件实锤了！🔨

  props: {include,exclude, max},

  created () {
    this.cache = Object.create(null)
    this.keys = []
  },

  destroyed () {
    // 销毁是清空缓存
    for (const key in this.cache) {
      pruneCacheEntry(this.cache, key, this.keys)
    }
  },

  mounted () {
    this.$watch('include', val => {
      pruneCache(this, name => matches(val, name))
    })
    this.$watch('exclude', val => {
      pruneCache(this, name => !matches(val, name))
    })
  },

  // 划重点！！！划重点！！！划重点！！！
  // render 是 keep-alive 缓存 读取的核心方法！！！

  render () {
    const slot = this.$slots.default
    // 这个 vnode 是通过 slot 获取的，多为动态组件
    const vnode: VNode = getFirstComponentChild(slot)
    const componentOptions: ?VNodeComponentOptions = vnode && vnode.componentOptions
    if (componentOptions) {
      // check pattern
      // 如果不包括就不缓存
      const name: ?string = getComponentName(componentOptions)
      const { include, exclude } = this
      if (
        // not included
        (include && (!name || !matches(include, name))) ||
        // excluded
        (exclude && name && matches(exclude, name))
      ) {
        return vnode
      }

      const { cache, keys } = this
      const key: ?string = vnode.key == null
        // same constructor may get registered as different local components
        // so cid alone is not enough (#3269)
        ? componentOptions.Ctor.cid + (componentOptions.tag ? `::${componentOptions.tag}` : '')
        : vnode.key

      // 如果缓存里面有就从缓存里面拿
      if (cache[key]) {
        vnode.componentInstance = cache[key].componentInstance
        // make current key freshest
        remove(keys, key)
        keys.push(key)
      } else {
        cache[key] = vnode
        keys.push(key)
        // 超长了清除最老的
        // prune oldest entry
        if (this.max && keys.length > parseInt(this.max)) {
          pruneCacheEntry(cache, keys[0], keys, this._vnode)
        }
      }

      // 标记vnode是个keepAlive组件
      vnode.data.keepAlive = true
    }
    return vnode || (slot && slot[0])
  }
}
```

看下来 keep-alive 有两个关键属性，`key` 和 `cache`。  
`key` 是动态组件的 `key` 或 `cid和tag的组合`  
`key` 也是用来与 `include` 和 `exclude` 比较的。  
`cache` 会根据 `key` 缓存动态组件。  
`render` 是重点！！！！   
`render` 的时候会取 slot 里第一个 `vnode`，然后比对 key 在不在 `cache` 中，如果有就直接返回 `cache` 中的进行渲染  

## keep-alive 缓存重新渲染

源码位置： `Vue/src/core/vdom/create-component.js`  

```js
// 这几个 hooks 的调用时机可以自己去看，这里不赘述
const componentVNodeHooks = {
  // 如此看来就知道 keep-alive是不重新调用 mount 钩子的
  init(){
    if (
      ... ...
      && vnode.data.keepAlive
    ) {
      // kept-alive components, treat as a patch
      const mountedNode: any = vnode // work around flow
      componentVNodeHooks.prepatch(mountedNode, mountedNode)
    } else {
      ... ...
      child.$mount(...)
    }
  },

  prepatch (...) {
    ... ...
    // 做一些子组件更新
    updateChildComponent(
      child,
      options.propsData, // updated props
      options.listeners, // updated listeners
      vnode, // new parent vnode
      options.children // new children
    )
  },

  // 在 src/core/patch.js patch() 中调用，感兴趣自己去看
  insert (...) {
    ... ...
    if (vnode.data.keepAlive) {
      if (context._isMounted) {
        // vue-router#1212
        // During updates, a kept-alive component's child components may
        // change, so directly walking the tree here may call activated hooks
        // on incorrect children. Instead we push them into a queue which will
        // be processed after the whole patch process ended.
        // 无情翻译官在线翻译，上面的注释的意思就是
        // vue-router issues 1212
        // 某大佬：“🤔喂，小尤 你这代码有问题吧？”
        // 小尤：“😤不可能，我的代码不可能有问题！”
        // 某大佬：“在更新期间，keep-alive组件的子组件可能发生改变
        // 所以在这直接遍历树会给错误的子节点调用activated钩子
        // 取而代之的是，我们应把他们放到一个 等待整个patch过程结束 才调用队列中组件的 activated 钩子”
        // “怎么样小尤，服了吧？”
        // 小尤：“orz，大佬你说的太对了”
        queueActivatedComponent(componentInstance)
      } else {
        // 首次挂载不用管
        activateChildComponent(componentInstance, true /* direct */)
      }
    }
  },

  destroy (vnode: MountedComponentVNode) {
    // 只要 vnode 还是 keepAlive 状态就不调 destroy 钩子而是调 deactiveate 钩子
    const { componentInstance } = vnode
    if (!componentInstance._isDestroyed) {
      if (!vnode.data.keepAlive) {
        componentInstance.$destroy()
      } else {
        //! 这个方法递归 调用所有子组件的 deactiveate 钩子
        deactivateChildComponent(componentInstance, true /* direct */)
      }
    }
  }
}
```

这里介绍了 `keep-alive` 的在调用生命周期钩子时，与其他组件的区别，还有一段我精彩的脑补😹～

## keep-alive patch

源码位置： `Vue/src/core/vdom/patch.js`  

```js
  function createComponent (vnode, insertedVnodeQueue, parentElm, refElm) {
    let i = vnode.data
    if (isDef(i)) {
      const isReactivated = isDef(vnode.componentInstance) && i.keepAlive
      if (isDef(i = i.hook) && isDef(i = i.init)) {
        i(vnode, false /* hydrating */)
      }
      // after calling the init hook, if the vnode is a child component
      // it should've created a child instance and mounted it. the child
      // component also has set the placeholder vnode's elm.
      // in that case we can just return the element and be done.
      if (isDef(vnode.componentInstance)) {
        initComponent(vnode, insertedVnodeQueue)
        insert(parentElm, vnode.elm, refElm)
        if (isTrue(isReactivated)) {
          reactivateComponent(vnode, insertedVnodeQueue, parentElm, refElm)
        }
        return true
      }
    }
  }

  function reactivateComponent (vnode, insertedVnodeQueue, parentElm, refElm) {
    let i
    // hack for #4339: a reactivated component with inner transition
    // does not trigger because the inner node's created hooks are not called
    // again. It's not ideal to involve module-specific logic in here but
    // there doesn't seem to be a better way to do it.
    // 每次读注释都觉得很有乐趣，这又是个无能为力的改法，小尤"我能怎么办🤷‍♂️？我也很绝望"
    // reactivated 的 组件 内联的 transition（过渡组件）不生效，因为不走created钩子
    // 所以就在actived钩子里面做兼容了，然后挨个调用hooks
    let innerNode = vnode
    while (innerNode.componentInstance) {
      innerNode = innerNode.componentInstance._vnode
      if (isDef(i = innerNode.data) && isDef(i = i.transition)) {
        for (i = 0; i < cbs.activate.length; ++i) {
          cbs.activate[i](emptyNode, innerNode)
        }
        insertedVnodeQueue.push(innerNode)
        break
      }
    }
    // unlike a newly created component,
    // a reactivated keep-alive component doesn't insert itself
    insert(parentElm, vnode.elm, refElm)
  }
```

`patch` 里面说实话没干啥，更新了子组件，剩下的就是调用 `acivated` 钩子了，注意延迟调用的逻辑

## 总结

核心就是 `keep-alive.js` 里面的 `render` 了，首次调用，就判断是否应该加入`cache`中  
再次渲染就直接从`cache`中拿，注意key的值不能变，否则之前缓存的组件会`destroy`掉。  
嗯别问我咋知道的，谁不是为了调bug才看的源码啊😭(部分原因啦，要想弄清原理最快的途径就是看源码，或者阅读别人看源码的文章哈哈哈哈)  
