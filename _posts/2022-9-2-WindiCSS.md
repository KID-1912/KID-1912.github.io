---
layout:     post
title:      WindiCss
subtitle:   Css工具类框架
date:       2021-09-18
author:     page
header-img: img/post-bg-css3.webp
catalog: true
tags:
    - 开发框架
---

# WindiCSS

[官方文档](https://windicss.org/)  [中文文档](https://cn.windicss.org/)

## 开始

### 安装

**webpack**

```
npm i windicss-webpack-plugin -D
```

### 配置

**webpack**

```js
const WindiCSSWebpackPlugin = require('windicss-webpack-plugin');
...
plugins: [
  new WindiCSSWebpackPlugin(),
  ...
]
```

其它构建工具使用见：[Installation | Windi CSS](https://windicss.org/guide/installation.html)

### 引入虚拟模块

```js
// main.js
import 'windi.css'
import "virtual:windi.css"; // vite
```

## 配置

### 基础配置

```js
// windi.config.js
import { defineConfig } from 'windicss/helpers'

export default defineConfig({
  extract: {
    // A common use case is scanning files from the root directory
    include: ['**/*.{vue,html,jsx,tsx}'],
    // if you are excluding files, make sure you always include node_modules and .git
    exclude: ['node_modules', '.git', 'dist'],
  },
});
```

### 继承配置

```js
import { defineConfig } from "windicss/helpers";

export default defineConfig({
  /* 配置项... */
  corePlugins: { // corePlugins控制类开启
    container: false,
  },
});
```

### 白名单

使用**动态拼接**特性，须显式声明 `safelist` 配置项列举可能的组合：

```html
<div class="p-${size}"></div>
```

```js
import { defineConfig } from 'windicss/helpers'
function range(size, startAt = 1) {
  return Array.from(Array(size).keys()).map(i => i + startAt)
}
export default defineConfig({
  safelist: [
    'p-1 p-2 p-3 p-4',
    range(10).map(i => `mt-${i}`), // mt-1 to mt-10
  ]
})
```

### 预检样式

windicss会向页面注入元素的预定义样式

```js
preflight: false // 关闭所有预定义样式
preflight: {
  safelist: 'h1 h2 h3 p img', // 仅开启白名单样式
}
```
