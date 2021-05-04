---
layout: post
title: 重学设计模式--SOLID 原则
subtitle: 设计模式五原则
author: "malin"
header-bg-css: "linear-gradient(to right, #5cadff, #09EF46);"
categories:
  - 重构
tags:
  - Design Pattern
---

> 此系列文章为博主阅读[《深入设计模式》](https://refactoring.guru/design-patterns)的阅读笔记, 欢迎交流, wechat: 
> 合理的运用设计模式可以让你的代码更加健壮 Proper use of design patterns can make your code more strong

## Factory Method

> “As long as all prod­uct class­es imple­ment a com­mon inter­face, you can pass their objects to the client code with­out break­ing it.”

### 例子

如果我们需要交通工具, 比如卡车, 运输货物

```js
class Truck {
  deliver(){
    // 运货
  }
}
```

此时我们如果公司扩展业务, 多了轮船, 走水路, 那么我们可以建造一个工厂函数, 来创建运输工具

```ts
enum TransportType {
  Truck = 'truck',
  Ship = 'ship',
}

class TransportFactory{
  createOrder(type: TransportType, options: any){
    if(type === TransportType.Truck){
      return new Truck(options);
    } else if(type === TransportType.Truck){
      return new Ship(options);
    }
  }
}

interface ITransport {
  deliver: () => void
}

class Truck implements ITransport{
  ...
}

class Ship implements ITransport{
  ...
}

```

通常 factory 可能由于返回对象属性不同, 业务逻辑不同, 比如卡车是陆地运输、船代表海上运输, 那么就需要 class RoadTransportFactory extends TransportFactory 来实现卡车实例的创建

### 组成部分

1. Product 产品 `ITransport`
2. Concrete Products `Truck`
3. Creator `TransportFactory`
4. Concrete Creators `RoadTransportFactory`

## Abstract Factory

当工厂中 Creator 的类中 所有 api 都是 abstract 时, 个人理解此时工厂与抽象工厂等价

### 例子

家具厂, 造不同风格家具. 以后可能增加风格、家具种类.

```ts
enum Style{
  Modern = 'modern',
  Victorian = 'victorian',
}
// abstract interface
interface Chair {
  style: Style;
  sitOn: () => void;
}
interface Sofa{
  style: Style;
  sitOn: () => void;
}
interface FurnitureFactory {
  createChair: () => Chair
  createSofa: () => Sofa
}
```

```ts
class ModernChair implements Chair{
  style = Style.Modern;
  sitOn(){
    console.log('起来, 不愿做奴隶的人们')
  }
}
class VictorianSofa implements Sofa{
  style = Style.Victorian;
  sitOn(){
    console.log('嗯, 真香')
  }
}
class ModernFurnitureFactory implements FurnitureFactory {
  public createChair(): ModernChair {
    return new ModernChair();
  }
  public createSofa(): ModernSofa {
    return new ModernSofa();
  }
}
```

### 组成部分

1. Product `ITransport`
2. Concrete Products `Truck`
3. Abstract Factory `TransportFactory`
4. Concrete Factories `RoadTransportFactory`
