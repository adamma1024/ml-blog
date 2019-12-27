# js基础

## 作用域

### 全局作用域

全局作用域贯穿整个`js`文档。一旦你声明了一个全局变量，那么你在任何地方都可以使用它，包括函数内部。事实上，`js`默认拥有一个全局对象`window`，声明一个全局变量，就是为`window`对象的同名属性赋值  

```js
window.a = 1
function test(){
  console.log(a)
  b = 2
}
test()  // 1
console.log(b) //2
```

### 局部作用域

#### 函数作用域

1. 当执行函数时，总是先从函数内部找寻局部变量

2. 如果内部找不到（函数的局部作用域没有），则会向创建函数的作用域（声明函数的作用域）寻找，依次向上

```js
// Global Scope
function a() {
  var c = 1
  // Local Scope #1
  function a1() {
    // Local Scope #2
    var d = 2
  }
  console.log(d)
}
a()            // ReferenceError
console.log(c) // ReferenceError
```

#### 块级作用域

块级作用域可以替代立即执行函数

```js
// 问题
var tmp = new Date();
 
function f(){
  console.log(tmp);
  if(false){
    var tmp = "hello";
  }
}
 
f(); // undefined

for(var i =1;i<4;i++){

}
console.log(i)

function test() {
    if (true) {
        var a = 'js'
    }
    console.log(a)
}
test() // js
```

```js
function test() {
    if (true) {
        let a = 'js'
    }
    console.log(a)
}
test() // ReferenceError
```

```js
for (let i = 0; i <= 2; i++) {
}
console.log(i) // ReferenceError
```

```js
for (var j = 0; j <= 2; j++) {
}
console.log(j) //3
```

### 词法作用域

词法作用域注重的是所谓的 Write-Time，即编程时的上下文，而动态作用域以及常见的 this 的用法，都是 Run-Time，即运行时上下文。词法作用域关注的是函数在何处被定义，而动态作用域关注的是函数在何处被调用。JavaScript 是典型的词法作用域的语言，即一个符号参照到语境中符号名字出现的地方，局部变量缺省有着词法作用域。此二者的对比可以参考如下这个例子：

```js
function foo() {
    console.log( a ); // 2 in Lexical Scope ，But 3 in Dynamic Scope
}

function bar() {
    var a = 3;
    foo();
}

var a = 2;

bar();
```

## this

### 隐式调用

```js
const person = {
  name: 'xiaoming',
  Hello() {
    alert(`Hello, I'm ${this.name}`)
  }
}

person.Hello() // Hello, I'm xiaoming
```

```js
const person = {
  name: 'xiaoming',
  Hello() {
    alert(`Hello, I'm ${this.name}`)
  }
  dad: {
    name: 'xiaoma',
    Hello() {
      alert(`Hello, I'm ${this.name}`)
    }
  }
}

person.Hello() // Hello, I'm xiaoming
person.dad.Hello() // Hello, I'm xiaoma
```

```js
function Hello () {
  console.log(`Hello, I'm ${this.name}`)
}

Hello() // Hello, I'm undefined
```

因为点的左侧没有任何东西，我们也没有用 .call、.apply、.bind 或者 `new` 关键字，`JavaScript` 会默认 `this` 指向 `window` 对象

### 显式调用

```js
function Hello () {
  alert(`Hello, I'm ${this.name}`)
}

const person = {
  name: 'xiaoming',
}

Hello.call(person) // Hello, I'm xiaoming
Hello.apply(person) // Hello, I'm xiaoming
Hello.bind(person) // 只绑定不调用
```

### new 绑定

第三条判断 `this` 引用的规则是 `new` 绑定。每当用 `new` 调用函数时，`JavaScript` 解释器都会在底层创建一个全新的对象并把这个对象当做 `this`。如果用 `new` 调用一个函数，`this` 会自然地引用解释器创建的新对象

```js
class Person {
  constructor(name, age){
    this.name = name
    this.age = age
  }
  Hello(){
    console.log(`Hello, I'm ${this.name}`)
  }
}

const me = new User('malin', 24)
me.Hello() // Hello, I'm malin
```

```js
function new(parent, ...args){
  var obj = new Object()
  obj.__proto__ = parent.prototype
  // 绑定this
  var ret = parent.call(obj, ...args)
  return typeof ret === 'object' ? ret : obj
}
```

## 变量引用方式

### var

提升

### let

不允许重复定义
不提升
会形成块级作用域
暂时死区

### const

不提升
不可改
必须初始赋值
暂时死区

## ECMAScript 6

ECMAScript 6.0（简称 ES6）是 JavaScript 语言的下一代标准，已经在 2015 年 6 月正式发布了。它的目标，是使得 JavaScript 语言可以用来编写复杂的大型应用程序，成为企业级开发语言

在使用nvwa之前需要熟练掌握一下语法：  

- let,const
- class
- Promise
- find,filter,flat 等 数组扩展方法
- Object.assign,Object.keys 等Object扩展方法

推荐读物：[ECMAScript 6 入门 -- 阮一峰](http://es6.ruanyifeng.com/)
