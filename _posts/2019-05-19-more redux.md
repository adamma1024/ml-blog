---
layout:     post
title:      "深入redux"
date:       2019-05-19 14:14:22
author:     "malin"
header-style: text
tags:
    - Redux
    - React
---

> 通过[初识Redux]()，我们已经知道了Redux的基本使用方法了，下面就让我们深入学习如何使用redux

# TODO MVC

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
```

# 真实场景