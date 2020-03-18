# 优秀的插件及其源码解析

## vue-lazyload图片懒加载

- 所有image加载`等待图片`，设置v-lazy自定义指令
- `v-lazy` 会找到组件的上级 `scrollparent`
- 设置监听，`scroll`事件 / `IntersetionObserver`
- 当事件触发时，发送 `event` ，每个组件判断是否在`显示区域`
- 加载`真实`图片

## vue-infinite-scroll 无限滚动插件


