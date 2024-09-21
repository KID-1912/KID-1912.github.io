---
layout:     post
title:      AntDesign
subtitle:   基于 Ant Design 设计体系的 React UI 组件库，适合企业级中后台产品与前台桌面网站。
date:       2024-07-05
author:     page
header-img: img/cropper.png
catalog: true
tags:
    - react
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

### 主题变量

通过配置主题变量（Seed Token），快速生成主题色主题

```tsx
const theme = { token: { colorPrimary: "#dc4c3e" }, cssVar: true, hashed: false };

ReactDOM.createRoot(container).render(
  <React.StrictMode>
    <ConfigProvider theme={theme} locale={locale}>
      <AntdApp className="h-full" notification={{ showProgress: true, duration: 3 }}>
        <App />
      </AntdApp>
    </ConfigProvider>
  </React.StrictMode>,
);
```

编写项目scss时也可直接/间接使用主题变量，实现样式统一

```sass
// variable.scss
$primaryColor: var(--ant-color-primary);
```

```sass
@use "@/assets/styles/variable.scss" as *;

.add-task-item:hover {
  color: $primaryColor;
}
.add-task-item:hover {
  color: var(--ant-color-primary);
}
```

## 组件

### App

全局提供 React context 的 `message`、`Modal`、`notification` 静态方法，支持全局配置

```tsx
import App from "./App.tsx";
import { App as AntdApp } from "antd";
import "virtual:windi.css";
import { ConfigProvider } from "antd";

const container = document.getElementById("root") as HTMLDivElement;

ReactDOM.createRoot(container).render(
  <React.StrictMode>
    <ConfigProvider theme={{ cssVar: true, hashed: false }} locale={locale}>
      <AntdApp className="h-full" notification={{ showProgress: true, duration: 3 }}>
        <App />
      </AntdApp>
    </ConfigProvider>
  </React.StrictMode>,
);
```

**应用内使用：**

```tsx
export default function Home() {
  const { message, notification } = App.useApp(); 
  notification.success({
     placement: "bottomLeft",
     message: "1个任务已完成",
     style: { width: "240px" },
  });
}
```
