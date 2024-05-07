---
layout:     post
title:      @use-gesture
subtitle:   
date:       2024-05-05
author:     page
header-img: img/@use-gesture.jpg
catalog: true
tags:
    - JavaScript
---

# @use-gesture

[官方文档](https://use-gesture.netlify.app/docs/) [官网](https://use-gesture.netlify.app/)

## 安装

```shell
npm i @use-gesture/vanilla -S
npm i @use-gesture/react -S // for React
```

## 实例

**Vanilla javascript** 中创建实例

```js
import { Gesture, DragGesture, MoveGesture } from '@use-gesture/vanilla';

// 拖拽
const dragGesture = new DragGesture(el, ({ delta: [dx, dy] }) => {
  ...
}, options);

// 移动
const dragGesture = new MoveGesture(el, () => {
  ...
}, options);

// 多手势交互
const gesture = new Gesture(
  $container,
  {
    onHover: handleHover,
    onMove: handleMove,
  },
  {
    move: { enabled: false }, // move gesture
    ... 
  },
);
```