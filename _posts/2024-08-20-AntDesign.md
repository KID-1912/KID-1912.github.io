---
layout:     post
title:      AntDesign
subtitle:   用于瀑布流布局的 Vue.js 指令
date:       2024-07-05
author:     page
header-img: img/cropper.png
catalog: true
tags:
    - 类库
---

# AntDesign

## 开始

```shell
npm install antd --save
```

### 自动导入

**vite**

```js
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  return {
   // ......
   plugins: [
     react(),
     AutoImport({
       imports: [{ antd: ["Button", "Form", "Input", "Flex", "message"] }],
       eslintrc: {
         enabled: true,
         filepath: "./eslintrc-auto-import.json",
       },
       dts: "auto-imports.d.ts",
     }), 
  ]
}
```

## 组件
