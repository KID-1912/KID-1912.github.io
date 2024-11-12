---
layout:     post
title:      TypeScript开发
subtitle:   TypeScript开发汇总
date:       2024-8-21
author:     page
header-img: img/TypeScript.png
catalog: true
tags:
    - TypeScript
---

# TypeScript开发

## CSS Module

默认无法将 CSS/SCSS Modules作为TypeScript有效类型，需要额外声明类型：

 `declare module '*.scss';`

**typescript-plugin-css-modules**

 使TypeScript 项目中支持 CSS 模块，更能提供自动补全的插件：

```json
"compilerOptions": {
  "plugins": [{ "name": "typescript-plugin-css-modules" }]
}
```

vscode 需额外设置：
 `"typescript.tsserver.pluginPaths": ["typescript-plugin-css-modules"]`
