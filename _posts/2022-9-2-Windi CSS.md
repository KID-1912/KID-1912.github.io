# Windi CSS

[官方文档](https://windicss.org/)  [中文文档](https://cn.windicss.org/)

## 安装

**webpack**

```
npm i windicss-webpack-plugin -D
```

## 配置

```js
const WindiCSSWebpackPlugin = require('windicss-webpack-plugin');
...
plugins: [
  new WindiCSSWebpackPlugin(),
  ...
]
```

## 引入虚拟模块

```js
// main.js
import 'windi.css'
```

## Windi 配置

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
