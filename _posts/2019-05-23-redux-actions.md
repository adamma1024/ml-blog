---
layout: post
title: Redux plug-in --redux-actions
author: "malin"
header-style: text
tags:
  - redux
  - redux-actions
---

使用了redux重构Vuex已经到了尾声，只剩下异步请求数据了，但是在这时我却发现了一个插件，叫做redux-actions！<br/>
我定睛一看，what f**k！这插件写起来action这么简单易懂啊，老子白写了这么多了。没人趟坑就是这么惨。<br/>
抱怨归抱怨，赶紧来看看这东西到底怎么个好法，然后乖乖重写吧<br/>
to-camel-case
# createAction 和 createActions
- **createAction**
 - createAction(type)
 - createAction(type, payloadCreator)
 - createAction(type, payloadCreator, metaCreator)
- **createActions**
 - createActions(actionMap[, options])
 - createActions(actionMap, ...identityActions[, options])

这是createAction和createActions的所有写法
## createAction
### createAction(type)
> 与createActions最大区别就是，当只有单个参数的时候，不需要写payloadCreator，少了好多代码！<strong style="color:red;font-size:20px;">强烈推荐</strong>
```javascript
export const increment = createAction('INCREMENT');
export const decrement = createAction('DECREMENT');
increment(); // { type: 'INCREMENT' }
decrement(); // { type: 'DECREMENT' }
increment(10); // { type: 'INCREMENT', payload: 10 }
decrement([1, 42]); // { type: 'DECREMENT', payload: [1, 42] }
```
### createAction(type, payloadCreator)
> 这种写法不如createActions简单
```javascript
export const increment = createAction('INCREMENT', num => ({num}));
export const decrement = createAction('DECREMENT', num => ({num}));

```