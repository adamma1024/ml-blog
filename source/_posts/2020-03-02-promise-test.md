## Promise 手写面试题

### 使用Promise实现每隔1秒输出1,2,3

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */

```

### 使用Promise实现红绿灯交替重复亮

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */

```

### 实现mergePromise函数

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */

```

### 根据promiseA+实现一个自己的promise

[PromiseA+ 源码](/2019/12/27/2019-08-31-es-promise/)

### 封装一个异步加载图片的方法

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */

```

### 限制异步操作的并发个数并尽可能快的完成全部

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */

```

### 预测输出结果

#### 题目一

```js
const first = () => (new Promise((resolve, reject) => {
    console.log(3);
    let p = new Promise((resolve, reject) => {
        console.log(7);
        setTimeout(() => {
            console.log(5);
            resolve(6);
          	console.log(p)
        }, 0)
        resolve(1);
    });
    resolve(2);
    p.then((arg) => {
        console.log(arg);
    });

}));

first().then((arg) => {
    console.log(arg);
});
console.log(4);

// 结果
```

#### 题目二

```js
const async1 = async () => {
  console.log('async1');
  setTimeout(() => {
    console.log('timer1')
  }, 2000)
  await new Promise(resolve => {
    console.log('promise1')
  })
  console.log('async1 end')
  return 'async1 success'
} 
console.log('script start');
async1().then(res => console.log(res));
console.log('script end');
Promise.resolve(1)
  .then(2)
  .then(Promise.resolve(3))
  .catch(4)
  .then(res => console.log(res))
setTimeout(() => {
  console.log('timer2')
}, 1000)

// 结果
```

#### 题目三

```js
const p1 = new Promise((resolve) => {
  setTimeout(() => {
    resolve('resolve3');
    console.log('timer1')
  }, 0)
  resolve('resovle1');
  resolve('resolve2');
}).then(res => {
  console.log(res)
  setTimeout(() => {
    console.log(p1)
  }, 1000)
}).finally(res => {
  console.log('finally', res)
})

// 结果
```