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

```js
const WindiCSSWebpackPlugin = require('windicss-webpack-plugin');
...
plugins: [
  new WindiCSSWebpackPlugin(),
  ...
]
```

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

### 预检样式

```js
preflight: false // 关闭所有预定义样式
preflight: {
  safelist: 'h1 h2 h3 p img', // 仅开启白名单样式
}
```
