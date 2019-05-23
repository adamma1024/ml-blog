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
先说一点，在比较大的项目中actions比较多。**极力推荐**<strong style="color:red;font-size:20px;">createActions + handleActions</strong>**的写法**

# createAction 和 createActions
- **createAction**
 - createAction(type)
 - createAction(type, payloadCreator)
 - createAction(type, payloadCreator, metaCreator)
- **createActions**
 - createActions(actionMap[, options])
 - createActions(actionMap, ...identityActions[, options])

这是createAction和createActions的所有写法
## createActions
### createActions(actionMap[, options])
> 多actions时推荐使用，少了好多代码！<strong style="color:red;font-size:20px;">强烈推荐</strong>
> 首先redux-actions依赖了to-camel-case，将type转成驼峰命名的action名

```javascript
const { actionOne, actionTwo, actionThree } = createActions(
  {
    // function form; payload creator defined inline
    ACTION_ONE: (key, value) => ({ [key]: value }),

    // array form
    ACTION_TWO: [
      first => [first], // payload
      (first, second) => ({ second }) // meta
    ]

    // trailing action type string form; payload creator is the identity
  },
  'ACTION_THREE'
);

expect(actionOne('key', 1)).to.deep.equal({
  type: 'ACTION_ONE',
  payload: { key: 1 }
});

expect(actionTwo('first', 'second')).to.deep.equal({
  type: 'ACTION_TWO',
  payload: ['first'],
  meta: { second: 'second' }
});

expect(actionThree(3)).to.deep.equal({
  type: 'ACTION_THREE',
  payload: 3
});
```
### createActions(actionMap, ...identityActions[, options])
```javascript
createActions({ ... }, 'INCREMENT', {
  prefix: 'counter', // String used to prefix each type
  namespace: '--' // Separator between prefix and type.  Default: `/`
})
```
> 看看就行了，namespace就是拼接actions的时候的间隔符默认是'/'

## createAction
### createAction(type)
> 单参数、少量actions的时候**推荐使用**
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
let noop = createAction('NOOP', amount => amount);
// same as
noop = createAction('NOOP');
```
### createAction(type, payloadCreator, metaCreator)
> 多了个meta参数，但是我觉得可以用payload替代啊，**知道啥时候用meta传更好的可以给我补充**
```javascript
const updateAdminUser = createAction(
  'UPDATE_ADMIN_USER',
  updates => updates,
  () => ({ admin: true })
);

updateAdminUser({ name: 'Foo' });
// {
//   type: 'UPDATE_ADMIN_USER',
//   payload: { name: 'Foo' },
//   meta: { admin: true },
// }
```
# handleAction 和 handleActions
- handleAction
 - handleAction(type, reducer, defaultState)
 - handleAction(type, reducerMap, defaultState)
 - handleActions
- handleActions(reducerMap, defaultState[, options])

## handleActions
- handleActions(reducerMap, defaultState);
- reducerMap可以传map、对象
### handleActions(reducerMap, defaultState[, options])
> <strong style="color:red;font-size:20px;">力荐这种写法</strong>**，通用且简单**
```javascript
const increment = createAction(INCREMENT);
const decrement = createAction(DECREMENT);

const reducer = handleActions(
  new Map([
    [
      increment,
      (state, action) => ({
        counter: state.counter + action.payload
      })
    ],

    [
      decrement,
      (state, action) => ({
        counter: state.counter - action.payload
      })
    ]
  ]),
  { counter: 0 }
);
```

## handleAction
### handleAction(type, reducer, defaultState)
> 除非很简单，否则用不到
```javascript
handleAction(
  'APP/COUNTER/INCREMENT',
  (state, action) => ({
    counter: state.counter + action.payload.amount
  }),
  defaultState
);
```
### handleAction(type, reducerMap, defaultState)
> 这种写法是默认走next(),当有错误的时候走个错误处理方法throw(),没啥好讲的
```javascript
handleAction('FETCH_DATA', {
  next(state, action) {...},
  throw(state, action) {...},
}, defaultState);
```
redux插件太多了，用之前建议多看看有啥好插件，要不然就像我一样，一直在重构代码。。。
不说了，熬夜重构去了！！(┬＿┬)
