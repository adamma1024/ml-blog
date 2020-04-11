---
layout: post
title: 学习笔记 -- react
subtitle: 学习react的第N天
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - react
tags:
  - react
---

## setState

### 正确使用

- 不要直接修改 this.state.count = 1
- 更新可能是异步的，处于性能考虑，React会把多个setState合并成一个。所以 this.props 和this.state 需要用回调中的，不能直接使用，因为有可能是个错误（还未生效的）的
- setState会被合并，所以你可以单独的更新某一个属性，而不需要写 `...this.state` 全量更新，注意⚠️这种合并方式称为浅合并
- 数据的向下流动性，state可以往下传，单向数据流，state只能影响组件和子组件的状态

### 同步异步

答： 在React合成事件中是异步的，在原生事件中是同步的。因为合成事件需要进入React更新队列中

## 生命周期

### 16.3

```js
class TestClass extends React.Component{
  constructor(props){super(props)}

  // willmount挂载之前 已经有了this.props / this.state
  componentWillMount(){}
  render()
  // mounted
  componentDidMount(){}

  //! 首次不执行，更新才执行
  // receiveprops 接受父组件传递的新props
  componentWillReceiveProps(){}
  // should update 是否要更新，返回true / false
  // 参数是 下次的props 和 下次state
  // 可以根据这两个参数决定是否要更新
  shouldComponentUpdate(nextProps, nextState){}
  // willupdate 更新前
  componentWillUpdate(){}
  render() // 渲染
  // updated 完成更新后
  componentDidUpdate(){}

  // beforeDestory
  componentwillUnmount(){}
}
```

### 16.4

```js
// v17可能会废除三个
// componentWillMount
// componentWillUpdate
// componentWillReceivedProps

// 增加两个

// 在render之前调用，在首次渲染前和之后更新前都会调用
// 替代willMount 和 componentWillReceivedProps 和 willUpdate
getDerivedStateFromProps(props, state)(){
  return null //return 的值 是下一次的state
  // return { counter: 2 }
}

// 在更新前打快照，常用与更新前获取组件的DOM信息
getSnapshotBeforeUpdate(prevProps, prevState){

}
```
