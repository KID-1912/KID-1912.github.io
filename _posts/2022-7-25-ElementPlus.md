---
layout:     post
title:      Element-PLUS
subtitle:   基于 Vue 3 的UI组件库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - 类库
---

# Element PLUS

## 开始

**安装：**`npm i element-plus -S`

**引入**

- 完整引入

- 按需引入

- 自动导入

- 手动导入

详见 [官方文档](https://element-plus.org/zh-CN/)

## 主题

**SCSS 变量**

新建 `src/plugins/element-plus/var.scss`，编写scss变量覆盖；详见 [主题 ](https://element-plus.org/zh-CN/guide/theming.html)

**CSS变量**

为元素类声明 css 变量覆盖基础值，适用于单独为某个组件实例定义样式；

```css
.custom-class {
  --el-tag-bg-color: red;
}
```

## Icon

### 基本使用

**安装**

Element Plus将Icon独立为图标集合

```shell
npm i @element-plus/icons-vue -S
```

**引入**

```js
// icon.js
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 引入所有 也可按需手动引入
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
```

**使用**

```html
<!-- 直接使用Svg -->
<Edit style="width: 16px; height: 1px; margin-right: 4px" />

<!-- ElIcon控制样式 -->
<el-icon class="no-inherit" color="#409EFC" :size="16">

<!-- 组件icon值 -->
<el-button type="primary" icon="Edit">修改</el-button>
```

### 自动导入

```js
// webpack.config.js
const Components = require("unplugin-vue-components/webpack");
const Icons = require("unplugin-icons/webpack");
const IconsResolver = require("unplugin-icons/resolver");

module.export = {
  // ......
  plugins: [
    Components({
      resolvers: [
        // 自动导入svg图标组件
        IconsResolver({
          prefix: false,  // 省略前缀 默认组件前缀 icon
          enabledCollections: ["ep"],  // icon集合，ep即elementplus图标集
          alias: { 'el-svg': "ep" },  // 别名 使用'el-svg'作为'ep'别名
        }),
        ElementPlusResolver(),
      ],
    }),
    // 自动安装图标集，无需另外安装
    Icons({ compiler: "vue3", autoInstall: true })
  ]
};
```

**自定义Icon**

```js
// webpack.config.js
const { FileSystemIconLoader } = require('unplugin-icons/loaders')
Components({
  resolvers: [
    IconsResolver({
      prefix: false,
      alias: { "el-svg": "ep" },
      enabledCollections: ["ep"],
      customCollections: ["svg"],  // 自定义集合添加解析
    }),
    ElementPlusResolver(),
  ],
}),
Icons({
  compiler: "vue3",
  autoInstall: true,
  // 自定义icon图标集合
  customCollections: {
    // 指定导入目录为名称为svg图标集
    svg: FileSystemIconLoader(resolve("src/icons/svg")),
  },
}),
```

**使用**

```html
<!-- 
  默认组件名 按{prefix}-{collection}-{icon}
  配置别名后 elementplus图标使用 el-svg-icon名称
  自定义图标集使用 svg-icon名称
-->
<ELSvgPlus />
<SvgLogo />
```

vite详见  [element-plus-best-practices](https://github.com/sxzz/element-plus-best-practices/blob/db2dfc983ccda5570033a0ac608a1bd9d9a7f658/vite.config.ts#L21-L58)

自动导入插件 [unplugin-icons](https://github.com/antfu/unplugin-icons)

## 分页

推荐使用 `@update:current-page` 替代 `@current-page`

```html
<el-pagination
  :current-page="1"
  :page-size="10"
  :total="0"
  @update:current-page="handlePageChange"
  layout="prev, pager, next"
  background
></el-pagination>
```
