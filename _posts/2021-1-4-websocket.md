---
layout:     post
title:      websocket双向通信
subtitle:   使用websocket进行双向通信开发
date:       2021-01-04
author:     page
header-img: post-bg-alibaba.jpg
catalog: true
tags:
    - HTTP
---

# websocket

**特点**

- 双向通信
- 数据格式比较轻量，性能开销小，通信高效
- 没有同源策略导致的跨域问题
- 建立在TCP之上，可以发送文本，也可以发送二进制数据

## 基本使用

**安装**

```js
npm install --save socket.io
```

**初始化**

服务端初始化一个socket.io实例并监听connection事件

```js
var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);
io.on('connection', socket => {
 // 每个socket都是一个连接实例
 console.log('a user connected')
});
http.listen(3000, () => {  console.log('server is runing') });
```

**链接**

前端加载socket.io-client，使用全局方法io连接

```html
 var socket = io(); // 默认连接到当前页面主机
```

## 事件通信

**web**

```js
<script src="/socket.io/socket.io.js"></script>
<script src="https://code.jquery.com/jquery-1.11.1.js"></script>
<script>
  $(function () {
    var socket = io();
    $('form').submit(function(){
      socket.emit('chat message', $('#m').val()); // 发送自定义的事件
      $('#m').val('');
      return false;
    });
  });
</script>
```

**server**

```js
io.on('connection', socket => { // 监听自带事件
    socket.on('disconnection',() => console.log('一个用户断开');)
    // 监听指定自定义socket事件，msg即通信数据
    socket.on('chat message', msg => {
      console.log('message: ' + msg);
    });
    socket.on('private message',(from,msg) => console.log('来自',from,消息,msg))
});
```

## 多路由分发

**web**

```html
<script>
  // 可根据当前页面路径连接
    var chat = io.connect('http://localhost/chat')
    , news = io.connect('http://localhost/news');
    chat.on('connect', function () {
      chat.emit('hi!');
    });
    news.on('news', function () {
      news.emit('woot');
    });
</script>
```

**server**

```js
var io = require('socket.io')(80);
var chat = io
  .of('/chat')
  .on('connection', function (socket) {
   socket.emit('a message', {
       that: 'only'
     , '/chat': 'will get'
   });
   chat.emit('a message', {
        everyone: 'in'
      , '/chat': 'will get'
    });
  });
var news = io
  .of('/news')
  .on('connection', function (socket) {
    socket.emit('item', { news: 'item' });
  });
```

## 完成回调

**server**

```js
var io = require('socket.io')(80);
io.on('connection', function (socket) {
  socket.on('ferret', function (name, fn) { // 接受回调参
    fn('success'); // 执行带有参数的回调
  });
});
```

**web**

```html
<script>
  var socket = io();
  socket.on('connect', function () { connect能同时监听连接和事件
    //确认后端处理完成并执行回调
    socket.emit('ferret', 'tobi', function (data) { 
      console.log(data); // 'success'
    });
  });
</script>
```

## 广播消息

```js
io.on('connection', function (socket) {
  socket.broadcast.emit('user connected');  //broadcast除去当前client端
});
```

## Socket

`socket.id`

一个独一无二的针对当前会话socket的标志，来自下行客户端。（返回字符串）

`socket.rooms`

当前客户端所在的房间号（返回对象）

```js
io.on('connection', (socket) => {
  socket.join('room 237', () => {   // 将client放在指定房间内
    let rooms = Objects.keys(socket.rooms);
    console.log(rooms); // [ <socket.id>, 'room 237' ]
  });
});
```

`socket.use(fn)`

注册中间件，当任何讯息流经该中间件时执行中间件中的内容，该中间件会接受参数，也可以判断是否阻断后续中间件的执行。

当发生错误，错误将会通过中间件的回调函数，直接发送一个特殊的错误数据包到客户端。

```js
io.on('connection', (socket) => {
  socket.use((packet, next) => {
    if (packet.doge === true) return next();
    next(new Error('Not a doge error'));
  });
});
```

`socket.join(room[, callback])`

room （字符串）callback （Function）

添加客户端到room房间内，并且执行可选择的回调函数

```js
    io.on('connection', (socket) => {
      socket.join('room 237', () => {
        let rooms = Objects.keys(socket.rooms);
        console.log(rooms); // [ <socket.id>, 'room 237' ]
        io.to('room 237', 'a new user has joined the room'); 
      });
    });
```

每一个socket自动的通过他自己的id标志创建了一个只属于他自己的房间，这样做，使得当前socket和其他socket之间的广播变得更容易。

```js
io.on('connection', (socket) => {
  socket.on('say to someone', (id, msg) => {
    // send a private message to the socket with the given id
    socket.to(id).emit('my message', msg);
  });
});
```
