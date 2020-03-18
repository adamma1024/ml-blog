

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