
## 中间件

```ts
function compose(middlewares) {
  return function(){
    function dispatch(i){
      const fn = middlewares[i];
      if(!fn){
        return Promise.resolve();
      }
      return Promise.resolve(
        fn(function next(){
          return dispatch( i + 1 );
        });
      );
    }
    return dispatch(0)
  }
}
```
