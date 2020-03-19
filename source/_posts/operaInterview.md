

## 转换驼峰

```js
function(str){
  return str.split('').reduce((a,b) => {
    if(a[a.length-1] === '-'){
      a = a.slice(0, a.length-1);
      b = b.toUpperCase()
    }
    return a + b
  })
}
```

## 红绿灯替换

```js
function red(){console.log(red)}
function green(){console.log(green)}
function yellow(){console.log(yellow)}

function light(timer, cb()){
  return new Promise(res=>{
    let time = setTimeout(()=>{
      cb()
      res()
      clearTimeout(time)
      time = null
    }, timer)
  })
}

function change(){
  Promise.resolve()
  .then(res => light(2000, red))
  .then(res => light(1000, green))
  .then(res => light(3000, yellow))
  .then(res => change())
}

change()
```

## 千分位分隔符

```js
function addThousand(str){
  let index = 0
  var arr = str.split('')
  var s = ''
  for(let i = str.length -1; i>=0;i--){
    if(++index === 3 && i!==0){
      s+= str[i] + ','
      index = 0
    }else{
      s+=str[i]
    }
  }
  return s.split('').reverse().join('')
}
b('13456679999')
```

## 随机16进制颜色生成器

```js
function random16(){
  return Math.floor(Math.random() * 10).toString(16)
}
function randomHex(){
  let res = '#'
  for(let i = 0; i< 6; i++){
    res += random16()
  }
  return res
}
```

## 并发promise

```js
function handleFetch(urls, max, cb){
  let res = []
  let 
}
```

## K个链表旋转

[1,2,3,4,5] 3   -> [3,2,1,5,4]  
与leetcode 25题不同的是`不够K`也要旋转下  
`尾插法`

```js
var reverseKGroup = function(head, k) {
  let curr = head
  let count = 0

  // 将当前指针移动到结束位置，并记录移动了几位
  while(curr !== null && count < k){
    curr = curr.next
    count++
  }

  // 
  if(count === k){
    // 最终会返回下一个部分的 反转之后的 头节点
    let tail = reverseKGroup(curr, k)
    while(count > 0){
      let next = head.next
      head.next = tail
      tail = head
      head = next
      count--
    }
    head = tail
  }else{
    while(count > 0){
      let next = head.next
      head.next = curr
      curr = head
      head = next
      count--
    }
    head = curr
  }

  return head
};
```
