---
layout:     post
title:      "深入redux"
date:       2019-05-19 14:14:22
author:     "malin"
header-img: "img/redux.jpg"
categories:
  - React全家桶
tags:
    - Redux
    - React
---

> 通过[初识Redux]()，我们已经知道了Redux的基本使用方法了，是时候深入一下了

Redux主要的三大点：
- action
- reducer
- store

下面通过实例来学习运用

# TODO-WITH-UNDO
UNDO 是一个很重要的功能，有很多种实现的方法:
- 数据层处理（MVC都是数据驱动View层，数据改变、回滚，就可以做出undo效果，缺点是能做的有限）
- 在写方法的时候都实现一套undo（代码改动量比较大）
- 用链表或者栈构建一套时序体系
- ... ...

> Vuex做undo很不友好，数据不是唯一的（不具备不可变性），这就导致了无法准确的收集到每次改变

来看看Redux的实现逻辑吧,上代码！

```javascript
//action
let nextTodoId = 0
export const addTodo = (text) => ({type: 'ADD_TODO',id: nextTodoId++,text})
export const setVisibilityFilter = (filter) => ({type: 'SET_VISIBILITY_FILTER',filter})
export const toggleTodo = (id) => ({type: 'TOGGLE_TODO',id})
```
这个action就四行代码，总共3个action，分别是*addTodo*、*setVisibilityFilter*、*toggleTodo*。作用和名字应该差不多<br/>
```javascript
//reducer
import undoable, { distinctState } from 'redux-undo'

const todo = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        id: action.id,
        text: action.text,
        completed: false
      }
    case 'TOGGLE_TODO':
      if (state.id !== action.id) {
        return state
      }

      return {
        ...state,
        completed: !state.completed
      }
    default:
      return state
  }
}

const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        todo(undefined, action)
      ]
    case 'TOGGLE_TODO':
      return state.map(t =>
        todo(t, action)
      )
    default:
      return state
  }
}

const undoableTodos = undoable(todos, { filter: distinctState() })

export default undoableTodos
```

在这里就研究一下todos的reducer就好，最核心的功能。<br/>
我们可以看到一个神奇的东西 <strong style="color:red">redux-undo</strong>,这个NPM包挺6的，专门为redux设计的undo的库<br/>
不得不说Redux的生态技术圈可是真的庞大啊！  嗯， 好用！<br/>
研究一下[redux-undo npm文档](https://www.npmjs.com/package/redux-undo#history-api)<br/>

```javascript
undoable(reducer, {
  limit: false, // 回退步数
 
  filter: () => true, // 过滤器，是否回退
 
  undoType: ActionTypes.UNDO, // define a custom action type for this undo action
  redoType: ActionTypes.REDO, // define a custom action type for this redo action
 
  jumpToPastType: ActionTypes.JUMP_TO_PAST, // define custom action type for this jumpToPast action
  jumpToFutureType: ActionTypes.JUMP_TO_FUTURE, // define custom action type for this jumpToFuture action
 
  initialState: undefined, // initial state (e.g. for loading)
  initTypes: ['@@redux/INIT', '@@INIT'] // history will be (re)set upon init action type
  initialHistory: { // initial history (e.g. for loading)
    past: [],
    present: config.initialState,
    future: []
  },
 
  debug: false, // set to `true` to turn on debugging
})
```
嗯属性还是挺多的，就是文档上没指出**distinctState**的作用是个啥，以后在研究吧

# 树状视图

```javascript
//Action
export const INCREMENT = 'INCREMENT'
export const CREATE_NODE = 'CREATE_NODE'
export const DELETE_NODE = 'DELETE_NODE'
export const ADD_CHILD = 'ADD_CHILD'
export const REMOVE_CHILD = 'REMOVE_CHILD'
//计数
export const increment = (nodeId) => ({
  type: INCREMENT,
  nodeId
})
//添加节点
let nextId = 0
export const createNode = () => ({
  type: CREATE_NODE,
  nodeId: `new_${nextId++}`
})
//删除节点
export const deleteNode = (nodeId) => ({
  type: DELETE_NODE,
  nodeId
})

export const addChild = (nodeId, childId) => ({
  type: ADD_CHILD,
  nodeId,
  childId
})

export const removeChild = (nodeId, childId) => ({
  type: REMOVE_CHILD,
  nodeId,
  childId
})
//Reducer
import { INCREMENT, ADD_CHILD, REMOVE_CHILD, CREATE_NODE, DELETE_NODE } from '../actions'

const childIds = (state, action) => {
  switch (action.type) {
    case ADD_CHILD:
      return [ ...state, action.childId ]
    case REMOVE_CHILD:
      return state.filter(id => id !== action.childId)
    default:
      return state
  }
}

const node = (state, action) => {
  switch (action.type) {
    case CREATE_NODE:
      return {
        id: action.nodeId,
        counter: 0,
        childIds: []
      }
    case INCREMENT:
      return {
        ...state,
        counter: state.counter + 1
      }
    case ADD_CHILD:
    case REMOVE_CHILD:
      return {
        ...state,
        childIds: childIds(state.childIds, action)
      }
    default:
      return state
  }
}

const getAllDescendantIds = (state, nodeId) => (
  state[nodeId].childIds.reduce((acc, childId) => (
    [ ...acc, childId, ...getAllDescendantIds(state, childId) ]
  ), [])
)

const deleteMany = (state, ids) => {
  state = { ...state }
  ids.forEach(id => delete state[id])
  return state
}
//最终版缩减器
export default (state = {}, action) => {
  const { nodeId } = action
  if (typeof nodeId === 'undefined') {
    return state
  }

  if (action.type === DELETE_NODE) {
    const descendantIds = getAllDescendantIds(state, nodeId)
    return deleteMany(state, [ nodeId, ...descendantIds ])
  }

  return {
    ...state,
    [nodeId]: node(state[nodeId], action)
  }
}
//Node
export class Node extends Component {
  handleIncrementClick = () => {
    const { increment, id } = this.props
    increment(id)
  }

  handleAddChildClick = e => {
    e.preventDefault()

    const { addChild, createNode, id } = this.props
    const childId = createNode().nodeId
    addChild(id, childId)
  }

  handleRemoveClick = e => {
    e.preventDefault()

    const { removeChild, deleteNode, parentId, id } = this.props
    removeChild(parentId, id)
    deleteNode(id)
  }

  renderChild = childId => {
    const { id } = this.props21
    return (
      <li key={childId}>
        <ConnectedNode id={childId} parentId={id} />
      </li>
    )
  }

  render() {
    const { counter, parentId, childIds } = this.props
    return (
      <div>
        Counter: {counter}
        {' '}
        <button onClick={this.handleIncrementClick}>
          +
        </button>
        {' '}
        {typeof parentId !== 'undefined' &&
          <a href="#" onClick={this.handleRemoveClick} // eslint-disable-line jsx-a11y/anchor-is-valid
             style={{ color: 'lightgray', textDecoration: 'none' }}>
            ×
          </a>
        }
        <ul>
          {childIds.map(this.renderChild)}
          <li key="add">
            <a href="#" // eslint-disable-line jsx-a11y/anchor-is-valid
              onClick={this.handleAddChildClick}
            >
              Add child
            </a>
          </li>
        </ul>
      </div>
    )
  }
}

function mapStateToProps(state, ownProps) {
  return state[ownProps.id]
}

const ConnectedNode = connect(mapStateToProps, actions)(Node)
export default ConnectedNode
```

可以看出来，action主要是定义有哪些动作，而缩减器才是真正去决定每个action做什么的,Node定义了什么时候去触发对应的action，效果如下 <br/>
![](/img/redux-tree.gif)
