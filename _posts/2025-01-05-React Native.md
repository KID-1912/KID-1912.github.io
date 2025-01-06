---
layout:     post
title:      React Native
subtitle:   使用React和应用平台的原生功能来构建 Android 和 iOS 应用的开源框架
date:       2025-01-05
author:     page
header-img: img/react-native.webp
catalog: true
tags:
    - React
---

# React Native

[awesome-react-native](https://github.com/jondot/awesome-react-native) [react-native-guide中文指南](https://github.com/reactnativecn/react-native-guide)

## 开发基础

### Reac Native组件

RN 中对原生视图的封装的组件，如View、Image、Text等[核心组件](https://reactnative.cn/docs/components-and-apis)；除此之外好包括社区组件、自定义的原生组件；

### 开发环境

Android：Node(18+)、JDK(17+) 和 [Android Studio](https://developer.android.google.cn/studio?hl=zh-cn)、全程稳定代理

**Android Studio**

- 安装Android Studio

- 安装 Android SDK（默认Studio已安装）

- 配置 ANDROID_HOME 环境变量

- 使用@react-native-community/cli初始化项目

### 特定平台

**Platform**

RN提供Platform模块用于判断当前运行环境，包括系统平台、系统版本等：

```js
Platform.OS === 'ios' // android || ios
Platform.Version // android版本
const majorVersionIOS = parseInt(Platform.Version, 10) // ios版本
```

**平台文件后缀**

RN支持开发者为组件/文件独立多个系统后缀的文件：

```
BigButton.ios.js
BigButton.android.js
```

按照省略平台后缀的引入，RN在运行时将自动按照当前系统区分平台：

```ts
import BigButton from "./BigButton";
```
