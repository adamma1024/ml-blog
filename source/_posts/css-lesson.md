# css基础

## 常用基础属性

- width
- height
- border
- background
- box-shadow
- transform
- transition
- animation

## 盒模型

box-sizing: content-box（default），border-box，padding-box

ie盒模型 height = border + padding + content.height

标准盒模型 height = content.height

## 选择器

CSS选择器的匹配是`从右向左`进行的  

这一策略导致了不同种类的选择器之间的性能也存在差异。相比于#markdown-content-h3，显然使用#markdown .content h3时，浏览器生成渲染树（render-tree）所要花费的时间更多。因为后者需要先找到DOM中的所有h3元素，再过滤掉祖先元素不是.content的，最后过滤掉.content的祖先不是#markdown的。试想，如果嵌套的层级更多，页面中的元素更多，那么匹配所要花费的时间代价自然更高。

权重
行内样式 > id > 类选择器、属性选择器、伪类选择器 > 元素选择器，伪元素选择器 > 通配符选择器

[css选择器整理](https://segmentfault.com/a/1190000007815822)
[CSS性能优化的8个技巧](https://juejin.im/post/5b6133a351882519d346853f#heading-4)

## flex,grid布局
