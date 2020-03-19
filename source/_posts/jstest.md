---
layout: post
title: 测试
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
# tags: 
#     - secury
# password: malin258
---

# 测试题以及相关文章

## 作用域

```js
// 知识点: let,const 定义变量只在块级作用域中生效，不挂到window上
let a = 10;
const b = 20;

console.log(window.a)
console.log(window.b)
```

<!--more-->
```js
// 知识点:
// 1.变量提升和函数提升
// 2.函数作用域
var a = 1;
function foo() {
    a = 10;
    console.log(a);
    return;
    function a() {};
}
foo(); // 10
console.log(a); //1
```

```js
// 知识点：
// 1.var关键字的缺点
function fun() {
   var arr = [];
   for (var i = 0; i < 10; i++) {
      arr[i] = function() {
         return i;
      };
   }
   return arr;
}

console.log(arr[1]())
console.log(arr[2]())
// 如何打印 1 2 3？   let的使用
```

```js
// 知识点：
// 全局变量的定义
function foo() {
    console.log(a);
    a = 1;
}

foo(); // ???

function bar() {
    a = 1;
    console.log(a);
}
bar(); // ???
```

[this、apply、call、bind](https://juejin.im/post/59bfe84351882531b730bac2)
[call、apply和bind的实现](https://github.com/Abiel1024/blog/issues/16)
[[译] （他喵的）到底是什么this — 理解](https://juejin.im/post/5b9f176b6fb9a05d3827d03f)

```js
// 知识点：
// 1.原型链
// 2.箭头函数不可以new
var Foo = () => {};
Foo.prototype.name = 1;
Foo.prototype.sayName = function(){
  console.log(this.name)
}
var foo = new Foo(); // TypeError: Foo is not a constructor

foo.sayName()
```

参考资料

[ECMAScript 6 入门 --箭头函数](http://es6.ruanyifeng.com/#docs/function#%E7%AE%AD%E5%A4%B4%E5%87%BD%E6%95%B0)

使用ES6语法快速数组去重

```js
var arr = [1,1,1,4,4,5,2,1,7,6]
arr = [...new Set(arr)]
```
