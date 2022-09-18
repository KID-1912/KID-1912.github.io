---
layout:     post
title:      Element-PLUS
subtitle:   基于 Vue 3 的UI组件库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - vue
---

# Element PLUS

## 开始

**安装：**`npm i element-plus -S`

**引入**

- 完整引入

- 按需引入

- 自动导入

- 手动导入

详见[官方文档](https://element-plus.gitee.io)

## 自定义主题

**SCSS 变量**

新建 `src/plugins/element-plus/var.scss`，编写scss变量覆盖；[详见文档](https://element-plus.gitee.io/zh-CN/guide/theming.html)

**CSS变量**

为元素类声明 css 变量覆盖基础值，适用于单独为某个组件实例定义样式；

```css
.custom-class {
  --el-tag-bg-color: red;
}
```
