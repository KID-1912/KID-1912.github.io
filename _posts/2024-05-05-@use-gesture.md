---
layout:     post
title:      @use-gesture
subtitle:   @use-gesture 是一个库，可让您将更丰富的鼠标和触摸事件绑定到任何组件或视图。 
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

**Vanilla javascript**

| `DragGesture`   | Handles the drag gesture                   |
| --------------- | ------------------------------------------ |
| `MoveGesture`   | Handles mouse move events                  |
| `HoverGesture`  | Handles mouse enter and mouse leave events |
| `ScrollGesture` | Handles scroll events                      |
| `WheelGesture`  | Handles wheel events                       |
| `PinchGesture`  | Handles the pinch gesture                  |
| `Gesture`       | Handles multiple gestures in one hook      |

```js
import { Gesture, DragGesture, MoveGesture } from '@use-gesture/vanilla';

// 拖拽实例
const dragGesture = new DragGesture(el, ({ delta: [dx, dy] }) => {
  ...
}, options);

// 移动实例
const dragGesture = new MoveGesture(el, () => {
  ...
}, options);

// 多手势交互实例
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

## [options](https://use-gesture.netlify.app/docs/options/)

支持通过 `setConfig(options)` 更新 options 配置

**enabled**：手势是否开启

## [state](https://use-gesture.netlify.app/docs/state/)

**xy**：值为数组 [x,y]，即指针位置或滚动偏移量

**delta**：值为数组[dx, dy]，移动差值，即指针移动/滚动差值

**active**：当前手势行为是否处于激活状态（boolean）