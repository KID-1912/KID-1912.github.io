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

[官方文档](https://ant.design/index-cn) 

## 开始

```shell
npm install antd --save
```

### 自动导入

**vite**

```js
import AutoImport from "unplugin-auto-import/vite";
import Icons from "unplugin-icons/vite";
import IconsResolver from "unplugin-icons/resolver";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  return {
   // ......
   plugins: [
     react(),
     AutoImport({
       // 手动声明自动导入组件
       imports: [{ antd: ["Button", "Form", "Input", "Flex", "message"] }],
       resolvers: [
         IconsResolver({
           prefix: false,
           enabledCollections: ["ant-design"],
           alias: { antd: "ant-design" },
           extension: "jsx",
         }),
         // icon使用示例：<AntdPlusOutlined />
       ],
       eslintrc: {
         enabled: true,
         filepath: "./eslintrc-auto-import.json",
       },
       dts: "auto-imports.d.ts",
     }),
     Icons({ autoInstall: true, compiler: "jsx" }),
  ]
}
```

**注**：

icon自动引入可能需要手动额外安装 `@svgr/plugin-jsx`

## 自定义样式

### CSS变量

在开启CSS变量模式下，不同主题下的样式可以共享，样式体积更小且切换性能优秀；

CSS模式定制主题同上面相同；

```jsx
import { ConfigProvider } from "antd";
const container = document.getElementById("root") as HTMLDivElement;

ReactDOM.createRoot(container).render(
  <React.StrictMode>
    {/* 开启CSS模式，并关闭hash值生成 */}
    <ConfigProvider theme={{ cssVar: true, hashed: false }}>
      <App />
    </ConfigProvider>
  </React.StrictMode>,
);
```

## 组件
