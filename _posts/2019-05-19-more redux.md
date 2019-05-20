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

> 通过[初识Redux]()，我们已经知道了Redux的基本使用方法了，是时候深入一下了

Redux主要的三大点：
- action
- reducer
- store

下面通过实例来学习运用

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

# 真实场景