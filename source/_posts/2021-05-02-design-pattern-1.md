---
layout: post
title: 重学设计模式(一)--创造型设计模式
subtitle: 工厂、抽象工厂、builder、原型、单例
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

## Builder

生成器让我们可以拆解一个复杂对象的创建, step by step 的创建每一个部分

### 解决的问题

一个复杂的对象, 他的构造函数的参数也许有很多个, 如果我们不用对象来传递. 那么构造函数将会十分臃肿、丑陋

### 例子

不优雅的

```ts
class House {
  window: number;
  door: number;
  garden: boolean;
  swimmingPool: boolean;
  ...
  // ugly!
  constructor(window, door, garden, swimmingPool, ...){
    ...
  }
}
```

```ts
// builder 初成, 但是看了示例,发现万事要抽象, 如果有别墅与平房区别, 那builder肯定是不一样的, 所以我们需要抽象一个基础的build,然后基于这个去具体实现
class HouseBuilder {
  style: string; // 装修风格
  window: number;
  door: number;
  garden: boolean;
  swimmingPool: boolean;
  ...
  // 
  constructor(style){
    this.style = style;
  }
  buildWindow(num: number){
    this.window = num;
  }
  buildDoor(num: number){
    this.door = num;
  }
  ...
}
```

```ts
enum Material {
  Wood = 'wood',
  Gold = 'gold',
}

// abstract builder
interface Builder {
  material: Material;
  buildWindow: (house: House) => House;
  buildDoor: (house: House) => House;
}

// 经济型 builder
class EconomyBuild {
  private material = Material.Wood;
  buildWindow(house: House){
    house.window = new Window(this.material);
    return house;
  }
  buildDoor(house: House){
    house.door = new Door(this.material);
    return house;
  }
}
// 奢华型 builder
class LuxuriousBuild {
  private material = Material.Gold;
  buildWindow(house: House){
    house.window = new Window(this.material);
    return house;
  }
  buildDoor(house: House){
    house.door = new Door(this.material);
    return house;
  }
}
```

某些场景下,我们也许需要一个监工来决定到底使用哪个 builder 来创建 house 的一部分. 监工我们称为 Direc­tor. *我个人理解, Director 实际上就是 封装了一些 switch ,用户传入 需要个金门就传入 type = gold, 监工去找对应的 builder 干活*

```ts
// 不太需要抽象了, 本身就是一些 switch 的集合
class Director {
  builder: Builder;
  changeMaterial(material: Material){
    switch(material){
      case Material.Wood:
        this.builder = new EconomyBuild();
    }
  }
}

// client 客户端
const myHouse = new House();
const director = new Director();
director.changeMaterial(Material.Wood);
director.builder.buildWindow(myHouse);
```

### 组成部分

1. Builder 建造者
2. Concert Builders 奢华型建造者、经济型建造者
3. Director 主管
4. Products 窗户、门

## Prototype

原型不太想写, 和原型链差不多

## Singleton

单例大家都很熟悉了, js 中大多数不需要考虑多线程情况, 所以直接懒汉模式(用的时候 new) 即可