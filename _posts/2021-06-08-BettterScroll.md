---
layout:     post
title:      BetterScroll2.0增强滚动
subtitle:   BetterScroll 是一款重点解决移动端（已支持 PC）各种滚动场景需求的插件。它的核心是借鉴的 iscroll的实现，在 iscroll 的基础上又扩展了一些 feature 以及做了一些性能优化。BetterScroll 是使用纯 JavaScript 实现的，这意味着它是无依赖的。
date:       2020-6-08
author:     page
header-img: img/post-bg-swift2.jpg
catalog: true
tags:
    - 类库工具
---

# BetterScroll

## 基本使用

- html结构
  - .wrapper滚动容器，作为滚动可见容器
    - .content滚动内容，作为滚动内容容器
      - ...具体内容

- style样式
  - .wrapper需设置高度，overflow: hidden(非常必要！)
  - .content高度非必要，但必须保证其高度大于.wrapper高度

- 引入并使用
  - npm方式
    1. 下载

    ```js
    npm install @better-scroll/core --save
    yarn add @better-scroll/core
    ```

    2. 引入并初始化.

    ```js
    import BScroll from '@better-scroll/core'
    let bs = new BScroll('.wrapper', {
      // ...... 配置参数
    })
    ```
  
  - script方式
    1. 加载

    ```html
    <script src="https://unpkg.com/@better-scroll/core@latest/dist/core.min.js"></script>
    ```

    2. 初始化

    ```js
    let wrapper = document.getElementById("wrapper")
    let bs = new BScroll(wrapper, {})
    ````

## 常用配置

- eventPassthrough: 'vertical' | 'horizontal'
  better-scroll区域默认仅对一个方向的滑动操作保留,另一方向滑动操作不可用；
  设置eventPassthrough后该区域另一方向滑动操作可用；
  如页面垂直居中位置有横向Slide轮播图，必须设置eventPassthrough: 'vertical'才支持在轮播区域实现页面纵向滚动

- click: Boolean
  better-scroll区域默认click时间不可用；
  click设为true即关闭该阻止

- tap: ""
  better-scroll区域默认click时间不可用；
  通过设置tap的值，如"scrollTap"，在内部区域click时转为派发自定义事件"scrollTap"

- bounce: Boolean
  better-scroll默认滚动到边缘会有空白回弹
  通过设置bounce: false 阻止滚动至边缘回弹

- probeType: Number(0)
  通过监听实例的scroll事件执行某些操作，probeType决定scroll事件被触发规则
  - 0：在任何时候都不派发 scroll 事件，
  - 1：仅仅当手指按在滚动区域上，每隔 momentumLimitTime 毫秒派发一次 scroll 事件，
  - 2：仅仅当手指按在滚动区域上，一直派发 scroll 事件，
  - 3：任何时候都派发 scroll 事件，包括调用 scrollTo 或者触发 momentum 滚动动画
  由于默认probeType为0，所以必须配置了probeType为其他值时，监听的scroll事件才能被触发

- preventDefaultException: Object({ tagName: /^(INPUT|TEXTAREA|BUTTON|SELECT|AUDIO)$/})
  - 除了表单元素以外，better-scroll区域默认阻止原生组件的默认行为
  - 设置preventDefaultException的值为正则，对匹配的className,tagName不阻止default行为；如video播放

## 常用API

- refresh()
  - 主动重新计算 BetterScroll 滚动内容，如图片加载导致DOM布局变化会导致滚动出错
  - 此外通过observe-image插件可实现自动监听，无需手动调用refresh

- scrollTo(x,y...)
  - better-scroll实例滚动到指定绝对位置

- on(type, fn)
  - 添加better-scroll实例的监听事件

## 常用插件

通过按需引入并配置插件，在保证依赖包的体积前提增强BetterScroll

### observe-image

对 wrapper 子元素中图片元素的加载的探测。自动调用 BetterScroll 的 refresh 方法来重新计算可滚动的宽度或者高度；

1. 安装

```js
npm install @better-scroll/observe-image --save
// yarn add @better-scroll/observe-image
```

2. 引入并配置

```js
import BScroll from '@better-scroll/core'
import ObserveImage from '@better-scroll/observe-image'
BScroll.use(ObserveImage)

new BScroll('.bs-wrapper', {
  observeImage: true // 开启 observe-image 插件
})
```

### slide

轮播图滚动

1. 安装并引入

```js
npm install @better-scroll/slide --save
// yarn add @better-scroll/slide

import BScroll from '@better-scroll/core'
import Slide from '@better-scroll/slide'
BScroll.use(Slide)
```

2. 配置

```js
new BScroll('.bs-wrapper', {
  scrollX: true, // 滚动方向
  scrollY: false,
  slide: {
    loop: false, // 关闭循环
    autoplay: false, // 关闭自动播放
    threshold: 100, // 切换下一屏阈值，小数即百分比，整数即绝对长度
  },
  momentum: false, // 禁止滑动的惯性导致滚动多屏
  probeType: 2 // 监听slide相关切换事件时设为2或3
})
```

3. slide相关方法

- $bs.prev/next() 切换至上/下一屏
- $bs.goToPage(pageX,pageY) 切换到指定所有屏
- $bs.getCurrentPage() 返回包含当前屏信息对象,属性 x, y 即位置，pageX/Y即索引

4. slide相关事件

- slideWillChange 即将切换至下一屏

```js
slide.on('slideWillChange', (page) => {
  const currentPageIndex = page.pageX;
})
```

- slidePageChanged 完成切换

```js
slide.on('slidePageChanged', (page) => {
  const x = page.x;
})
```

### nested-scroll

BetterScroll 嵌套滚动

1. 安装并引入

```js
npm install @better-scroll/nested-scroll --save
// yarn add @better-scroll/nested-scroll

import BScroll from '@better-scroll/core'
import NestedScroll from '@better-scroll/nested-scroll'
BScroll.use(NestedScroll)
```

2. 配置

```js
new BScroll('.outerWrapper', {
  nestedScroll: true
})
new BScroll('.innerWrapper', {
  nestedScroll: true
})

// 复杂嵌套
new BScroll('.outerWrapper', {
  nestedScroll: {
    groupId: 'dummy-divide'
  }
})
// child bs
new BScroll('.innerWrapper', {
  nestedScroll: {
    groupId: 'dummy-divide'
  }
})
```

3. html结构

```html
<div class="outer-wrapper">
  <div class="outer-content">
    <div class="inner-wrapper">
      <div class="inner-content">
        <!-- ...嵌套内容 -->
      </div>
    </div>
    <!-- ....其它滚动内容 -->
  </div>
</div>
```

4. nested-scroll相关方法

- purgeNestedScroll() 清除嵌套

```js
// 组件销毁时
$bs.purgeNestedScroll();
```

- purgeAllNestedScrolls() 清除所有嵌套

```js
import NestedScroll from '@better-scroll/nested-scroll'

// 不再约束任何 BetterScroll 实例
NestedScroll.purgeAllNestedScrolls()
```
