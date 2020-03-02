## Promise 手写面试题

### 使用Promise实现每隔1秒输出1,2,3

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */
var arr = [1,2,3]
arr.reduce((p,x)=>{
  return new Promise(res => {
    setTimeout(()=>{
      console.log(x)
      res()
    },1000)
  })
},Promise.resolve())
```

### 使用Promise实现红绿灯交替重复亮

```js
function red() {
    console.log('red');
}
function green() {
    console.log('green');
}
function yellow() {
    console.log('yellow');
}
/**
 * 红灯1s，绿灯2s，黄灯3s
 * 思路：使用.then return 传递promise 在setTimeout中调用res
 */
const light = function(timer, cb){
  return new Promise(res=>{
    setTimeout(()=>{
      cb()
      res()
    },timer)
  })
}
const turnOn = function(){
  Promise.resolve(1).then(res=>{
    return light(1000, red)
  }).then(res=>{
    return light(2000, green)
  }).then(res=>{
    return light(3000, yellow)
  }).then(res=>{
    return trunOn()
  })
}
```

### 实现mergePromise函数

```js
/**
 * 使用Promise实现每隔1秒输出1,2,3
 */
const time = (timer) => {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve()
    }, timer)
  })
}
const ajax1 = () => time(2000).then(() => {
  console.log(1);
  return 1
})
const ajax2 = () => time(1000).then(() => {
  console.log(2);
  return 2
})
const ajax3 = () => time(1000).then(() => {
  console.log(3);
  return 3
})

function mergePromise (arr) {
  let data = []
  let pro = Promise.resolve()
  // 在这里写代码
  arr.map(func => {
    return pro = pro.then(func).then(res => {
      data.push(res)
      return data
    })
  })
  return pro
}

mergePromise([ajax1, ajax2, ajax3]).then(data => {
  console.log("done");
  console.log(data); // data 为 [1, 2, 3]
});

// 要求分别输出
// 1
// 2
// 3
// done
// [1, 2, 3]
```

### 根据promiseA+实现一个自己的promise

[PromiseA+ 源码](/2019/12/27/2019-08-31-es-promise/)

### 封装一个异步加载图片的方法

```js
/**
 * 这个相对简单一些，只需要在图片的onload函数中，使用resolve返回一下就可以了
 */
function loadImg(){
  return new Promise((res,rej) =>{
    const img = new Image()
    img.onload = () =>{
      res(img)
    }
    img.onerror = () => {
      rej()
    }
    img.url = ''
  })
}
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