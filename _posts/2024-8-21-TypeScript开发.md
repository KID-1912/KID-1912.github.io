---
layout:     post
title:      TypeScript
subtitle:   在 JavaScript 的所有功能之上添加了一层： TypeScript 的类型系统
date:       2024-8-21
author:     page
header-img: img/TypeScript.png
catalog: true
tags:
    - TypeScript
---

# TypeScript开发

**CSS Module**

默认无法将 CSS/SCSS Modules作为TypeScript有效类型，需要额外声明类型：

 `declare module '*.scss';`

**typescript-plugin-css-modules**

 使TypeScript 项目中支持 CSS 模块，更能提供自动补全，vscode 需额外设置：
 `"typescript.tsserver.pluginPaths": ["typescript-plugin-css-modules"]`
