---
layout: post
title: redux-saga和redux-thunk对比和使用
author: "malin"
header-style: text
tags:
  - redux-saga
  - redux-thunk
---

> 借鉴了[这篇文章](https://blog.csdn.net/wj610671226/article/details/82730051)<br/>
> [redux-saga文档](https://redux-saga.js.org/docs/introduction/BeginnerTutorial.html)<br/>

## redux-thunk的使用

<code>redux-thunk</code>可以使原本只能返回对象的原生redux 的<code>action</code>，变得可以返回<code>promise</code>。

```javascript
//action
import axios from 'axios'

axios.defaults.withCredentials = true

export const changeHttpData = (data) => ({
  type:'CHANGE',
  data: data.data
})
export const getHttpData = (state, action) => {
  return (dispatch) => {
    axios.get('http://localhost:3001/list.json').then(res => {
      dispatch(changeHttpData(res.data))
    }).catch(e=>{
      dispatch(changeHttpData('出错了'))
    })
  }
}
//reducer
const initalState = {
  num: 0,
  httpData: '暂无数据'
}

export default (state = initalState, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return {
        ...state,
        num: state.num +1
      }
    case 'DECREMENT':
      return {
        ...state,
        num: state.num -1
      }
    case 'CHANGE':
      return {
        ...state,
        httpData: action.data
      }
    default:
      return state
  }
}
//dom
import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, applyMiddleware } from 'redux'
import Counter from './components/Counter'
import counter, {getHttpData} from './reducers'
import thunk from 'redux-thunk'

const store = createStore(counter,applyMiddleware(thunk))
const rootEl = document.getElementById('root')

const render = () => ReactDOM.render(
  <Counter
    value={store.getState()}
    onIncrement={() => store.dispatch({ type: 'INCREMENT' })}
    onDecrement={() => store.dispatch({ type: 'DECREMENT' })}
    onClick={() => store.dispatch(getHttpData())}
  />,
  rootEl
)

render()
store.subscribe(render)
//node
const Koa = require('koa');
const core = require('@koa/cors');
const app = new Koa();

//跨域
app.use(core({credentials:true}));

app.use(async (ctx, next) => {
    if(ctx.request.url.indexOf('list') !== -1){
        ctx.response.type='json';
        ctx.response['Access-Control-Allow-Credentials']=true;
        ctx.response.body={data:'Hello World'};
    }
});

app.listen(3001);
```

整个流程就是一个简单的使用redux-thunk去发送请求并<code>dispatch</code>其他action。<br/>
最终拿到了<code>'Hello World'</code>。<br/>
这种写法非常通俗易懂，是个初学者上手的好方法。但是经过上次redux-actions的教训，我决定先看看redux-saga再设计如何重构<code>Vuex</code>的异步action<br/>
