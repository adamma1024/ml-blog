---
layout: post
title: 重学设计模式(二)--结构型设计模式
subtitle: Adapter、Bridge、Composite、Facade、Decorator、Flyweight、Proxy
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 重构
tags:
  - Design Pattern
---

> 此系列文章为博主阅读[《深入设计模式》](https://refactoring.guru/design-patterns)的阅读笔记, 欢迎交流, wechat: 
> 合理的运用设计模式可以让你的代码更加健壮 Proper use of design patterns can make your code more strong

## Adapter

适配器, 遇到冲突的接口时, 可以利用适配器, 使得最终产出一个被接受的结构.

### 例子

```ts
interface A {
  getUnit: () => string; // like 'px'
  getWidth: () => number; // like 12
}
interface B {
  getWholeWidth: () => string; // like '12px'
}
class AClass implements A {
  getUnit(){
    return 'px';
  }
  getWidth(){
    return 12;
  }
}
class BClass implements B {
  getWholeWidth(){
    return 12;
  }
}
class C {
  anyone: any;
  constructor(someone){
    this.anyone = someone
  }
  getWholeWidth(){
    return this.anyone.getWholeWidth();
  }
}
var a = new AClass();
var b = new BClass();
var c1 = new C(a);
var c2 = new C(b);
c1.getWholeWidth() // error
c2.getWholeWidth() // '12px'
```

此时我们需要 adapter , 使得 a 能够适配 c类型

```ts
class AAdapter {
  anyone: any;
  constructor(someone: A){
    this.anyone = someone
  }
  getWholeWidth(){
    return this.anyone.getWidth() + this.anyone.getUnit();
  }
}
var a2 = new AAdapter(a);
var c3 = new C(a2);
c3.getWholeWidth() // '12px'
```

