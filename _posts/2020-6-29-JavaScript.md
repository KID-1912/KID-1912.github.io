---
layout:     post
title:      JavaScript基础
subtitle:   ECMAScript必备知识以及API操作
date:       2020-06-29
author:     page
header-img: img/post-bg-swift2.jpg
catalog: true
tags:
    - JavaScript
---

## Object

`Object.keys(obj)` 返回对象可遍历属性组成的数组

`obj.hasOwnProperty(key)` 判断key是否属于非继承的属性

## Array

**随机取n个不重复项**

```js
function randomArr(arr, num) {
  const result = [];
  let count = arr.length;
  for (let i = 0; i < num; i += 1) {
    const index = parseInt(Math.random() * count) + i;
    // 抽取结果不允许重复
    if(result.includes(arr[index])) continue;
    result[i] = arr[index];
    arr[index] =  arr[i];
    count -= 1;
  }
  return result;
}
```

**创建长度为n的空项数组**

`Array.from({ length: 4 }, (v, i) => i + 1)`

`new Array(10).fill(null)`

## Function

### 闭包

闭包并不是js才有的内容;

一般情况下，全局下调用函数会为给函数创建一个临时执行环境，当函数执行完成即销函数活动对象，也就是局部变量会被清除，但闭包能够让局部变量的值始终保持在内存中;

js中闭包常以函数嵌套方式形成，我们可以让一个函数内通过嵌套一个函数(内层函数)，如果内层函数在全局下被赋予导致内层函数保存在内存中，那么由于内层函数依赖外层函数，内层函数也会被保留在内存中，不会被垃圾回收;

### 递归

```js
function Factorial(num){
  if(num === 1) return 1;
  return num * Factorial(num-1);
}
```

- 明确函数期待输出

- 明确递归终点条件与终点输出

- 明确在函数处理中 依赖递归输出处 调用递归

### 隐式转换

可以使用对象的toString方法实现隐式转换，如下函数柯里化例子

```js
function add(...args){
  let _arr = args;
  let _add = function(){
    _arr.push(...arguments);
    return _add;
  };
  // toString 定义隐式转换处理
  _add.toString = () => _arr.reduce((prev,next) => prev+next);
  return _add;
}
console.log(add(1)(2)(3)+1);  // 最终返回的_add自动调用toString的隐式转换结果
```

### 防抖节流

防抖：等待一定时间后执行最后一次触发事件的回调函数

节流：每隔一定时间执行一次所有触发事件的回调函数

防抖

```js
function debounce(fn,delay){
    let deferTimer;
    return function(...args){
        deferTimer && clearTimeout(deferTimer);
        deferTimer = setTimeout(() => {
            fn.apply(this,args);
         },delay)
    }
}
```

节流（此处待确定）

```js
function throttle(fun, delay) {
    let last, deferTimer
    return function () {
        let that = this
        let _args = arguments
        let now = +new Date();
        if (last && now < last + delay) {
            clearTimeout(deferTimer)
            deferTimer = setTimeout(function () {
                last = now
                fun.apply(that, _args)
            }, delay)
        }else {
            last = now
            fun.apply(that,_args)
        }
    }
}
```

动画节流

```js
function animationThrottle(fun) {
  let animating = false;
  return function() {
    if (animating) return;
    animating = true;
    requestAnimationFrame(() => {
      fun(...arguments);
      animating = false;
    });
  };
}
```

延迟节流

```js
function throttle(fun, delay) {
    let flag = true;
    return function () {
        let that = this
        let _args = arguments
        if (!flag) reutrn;
        setTimeout(function () {
            fun.apply(that, _args)
            flag = true;
        }, delay)
        flag = false;
    }
}
```

### bind call apply

**call实现**

```
Function.prototype.hycall = function(thisArg, ...args) {
  // 1.获取需要被执行的函数
  var fn = this

  // 2.对thisArg转成对象类型(防止它传入的是非对象类型)
  thisArg = (thisArg !== null && thisArg !== undefined) ? Object(thisArg): window

  // 3.调用需要被执行的函数
  thisArg.fn = fn
  var result = thisArg.fn(...args)
  delete thisArg.fn

  // 4.返回结果
  return result
}
```

**apply实现**

```
Function.prototype.hyapply = function(thisArg, argArray) {
  // 1.获取到要执行的函数
  var fn = this

  // 2.处理绑定的thisArg
  thisArg = (thisArg !== null && thisArg !== undefined) ? Object(thisArg): window

  // 3.执行函数
  thisArg.fn = fn
  argArray = argArray || []
  var result = thisArg.fn(...argArray)
  delete thisArg.fn

  // 4.返回结果
  return result
}
```

**bind实现**

```js
Function.prototype.hybind = function(thisArg, ...argArray) {
  // 1.获取到真实需要调用的函数
  var fn = this

  // 2.绑定this
  thisArg = (thisArg !== null && thisArg !== undefined) ? Object(thisArg): window

  function proxyFn(...args) {
    // 3.将函数放到thisArg中进行调用
    thisArg.fn = fn
    // 特殊: 对两个传入的参数进行合并
    var finalArgs = [...argArray, ...args]
    var result = thisArg.fn(...finalArgs)
    delete thisArg.fn

    // 4.返回结果
    return result
  }

  return proxyFn
}
```

## String

`str.trim()`

- 清除字符串首尾空格
- 手写一个trim方法

```js
if(!String.prototype.trim){
    String.prototype.trim = function(){
        return this.replace(/(^ +| +$)/g,"")
    }
}
```

`str.padStart(2, "0")`

ES7新方法，设置字符串最小长度，不足部分用指定字符填充

## JSON

`JSON.stringify()`

`JSON.stringify(obj,null,4)` 自动填充4个空格分隔

## Number

`number.toFixed(digits)` 保留小数点位数后数字(以字符串类型返回)

## Math

`Math.ceil()`向上取整

`Math.floor()`向下取整

`Math.round()`四舍五入取整

## Date

**计算倒计时**

```js
function getDiffTime(timeStamp) {
  // 计算时分秒
  let hours = Math.floor(timeStamp / 1000 / 60 / 60);
  let minutes = Math.floor((timeStamp / 1000 / 60) % 60);
  let seconds = Math.floor((timeStamp / 1000) % 60);
  return `${String(hours).padStart(2,"0")}:
          ${String(minutes).padStart(2,"0")}:
          ${String(seconds).padStart(2,"0")}`;
}
```

## Promise

## async/await

Promise语法糖，await 后代码将作为 promise 回调处理

```js
const result = [];
for(const id in list){
  const item = await fetch({id}; // 统一执行环境下多个await，阻塞
  result.push(item);
}
return result;
```

```js
const fetchPromises = list.map(async (id) => { // 多执行环境多await，非阻塞
  const item = await fetch(id);
  return item;
});
const result = await Promise.all(fetchPromises);
return result;
```

## API

### URL

**创建实例**：`new URL(“合法url,否则报错”)`

**searchParams**

```js
const URLObject = new window.URL(location.href);
const cid = URLObject.searchParams.get('cid');
```

```js
const hash = router.resolve({ name: 'imageEditor' }).href;
const URLObject = new window.URL(hash, window.location.origin); // 参数2 设置base origin
URLObject.searchParams.set('cid','12345');
console.log(URLObject.href);
```
