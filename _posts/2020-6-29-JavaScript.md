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

`hasOwnProperty(key)` 判断key是否属于非继承的属性

## Array

**数组中随机取num个不重复项**

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

## Function

### 闭包

1. 闭包并不是js才有的内容
2. 一般情况下，全局下调用函数会为给函数创建一个临时执行环境，当函数执行完成即销函数活动对象，也就是局部变量会被清除，但闭包能够让局部变量的值始终保持在内存中
3. js中闭包常以函数嵌套方式形成，我们可以让一个函数内通过嵌套一个函数(内层函数)，如果内层函数在全局下被赋予导致内层函数保存在内存中，那么由于内层函数依赖外层函数，内层函数也会被保留在内存中，不会被垃圾回收；
4. 这个函数就是闭包

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

节流

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

## API相关

### 
