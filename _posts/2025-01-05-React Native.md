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

[react native中文文档](https://www.react-native.cn)   [awesome-react-native](https://github.com/jondot/awesome-react-native) [react-native-guide中文指南](https://github.com/reactnativecn/react-native-guide)

## 基础

### 开发环境

Android：Node(18+)、JDK(17+) 和 [Android Studio](https://developer.android.google.cn/studio?hl=zh-cn)、全程稳定代理

**Android Studio**

- 安装 Android Studio

- 安装 Android SDK（默认Studio已安装）

- 配置 ANDROID_HOME 环境变量

- 使用 `@react-native-community/cli` 初始化项目

### 项目文件

`index.js` 入口文件

`app.json` RNApp 配置文件

`App.tsx` App react根页面

`.watchmanconfig` Watchman配置（监控系统文件修改的重编译和热加载）

`metro.config.js` RN打包工具metro配置文件

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

## React Native组件

RN 中对原生视图的封装的组件，如View、Image、Text等[核心组件](https://reactnative.cn/docs/components-and-apis)；除此之外好包括社区组件、自定义的原生组件；

### 基础组件

**View**：简单容器

**Text**：文本容器

**Image**：图片元素

**ScrollView**：滚动容器

**TextInput**：文本输入

### 核心组件

App容器

## 样式

### style开发

**style属性**：直接在支持样式的组件上编写style属性

**StyleSheet.create**：创建CSS抽象样式表，以CSS Module方式编写类样式

*style Props*

style props对象属性速查：[https://www.react-native.cn/docs/layout-props](https://www.react-native.cn/docs/layout-props)

其中文本相关样式属性只能绑定在 Text 组件，border/opacity等属性只能绑定 View 组件；

### 宽高大小

默认View/Text等组件宽度占满，支持自定义 `style.width/height` 值

**绝对数值**

通过设备的逻辑像素点数量数值表示宽高；

**flex数值**

仅支持数字类型值 `flex: 1` ，显示伸缩占位；

**宽高百分比**

### Flexbox布局

`flexDirection` 默认值为 `column`

`alignContent` 默认值为 `flex-start` 而非 `stretch`

`flexShrink` 默认值同 `flexGrow` 都为0，即默认不伸缩

### 文字样式

**fontSize**：默认RNApp字号14dp，且所有文字样式支持在Text组件内继承

**fontFamily**

默认 Text 组件字体跟随系统

*如何自定义字体？*

1. 导入字体文件
- 准备TTF字体文件（文件名要求不含特殊符号，如“-”）

- 将字体文件存放在 `src/assets/fonts` 下

- package.json新增
  
  ```json
  “rnpm”: {
     “assets”: [“./src/assets/fonts”]
  }
  ```

- 终端运行 `react-native link`，此时assets下字体将被链接且被放置App使用
2. 新增自定义 AppText 组件，要求实现
- 默认采用指定的App字体的Text组件

- 根据系统Platform，IOS下需使用“-”拼接

- 支持传入style props定义其它字体或文字样式

*移除已链接字体*

Andorid直接移除 `android/app/src/main/assets/` 下字体文件即可

IOS：XCode移除 `Info.plist` 文件的字体Font项；然后 Build Phases > Copy Bundle Resources 下移除字体文件；如果报错警告忽略即可

*不自定义字体下，统一app字体*

- **优先使用系统默认字体**：如 iOS 的 `San Francisco` 和 Android 的 `Roboto`，判断系统强制设置使用默认字体。
- **需要一致字体时**：统一设置使用通用字体（如 `Arial`、`Verdana`、 `Courier New`）。

## 图片

### 静态图片

```tsx
<Image source={require('./my-icon.png')} />;
const icon = this.props.active
  ? require('./my-icon-active.png')
  : require('./my-icon-inactive.png');
<Image source={icon} />;
背景图
<ImageBackground source={...} style={{width: '100%', height: '100%'}}>
  <Text>Inside</Text>
</ImageBackground>
```

**注**：必须是固定的**相对**路径字符串值；如果你需要动态缩放图片（如通过 flex），你可能必须手动在 style 属性设置 `{ width: null, height: null }`。

### 网络图片

```tsx
<Image source={{uri: 'https://facebook.github.io/react/logo-og.png'}}
       style={{width: 400, height: 400}} />
```

必须手动指定图片尺寸，并ios要求https传输安全
