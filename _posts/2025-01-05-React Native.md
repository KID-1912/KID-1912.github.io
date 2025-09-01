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

### 第三方库

RN App应用库： https://reactnative.directory/

RN 社区： https://github.com/react-native-community

Expo官网SDK： https://docs.expo.dev/versions/latest/

### dp单位

React Native使用**密度无关像素**，dp基于160dpi（每英寸物理像素点数）：

即在每英寸160物理像素屏幕上，1dp=1物理像素=1/160英寸

那么每英寸320物理像素屏幕上，1dp=2物理像素=1/160英寸（iphone6/7/8）

所以在没有dp设计图下，我们可以拿到一个375px的web设计图，把它看做是

iPhone6/7/8的界面图（在这些设备上dpr为2，dpi为326，即1px=2物理像素≈1dp），UI宽高边距单位数值等同于dp单位；

## React Native组件

RN 中对原生视图的封装的组件，如View、Image、Text等[核心组件](https://reactnative.cn/docs/components-and-apis)；除此之外好包括社区组件、自定义的原生组件；

### 基础组件

**View**：简单容器

**Text**：文本容器

**Image**：图片元素

**ScrollView**：滚动容器

**TextInput**：文本输入

### 功能组件

#### App容器

注册App容器：`AppRegistry.registerComponent(appName, () => App)`

#### StatusBar

通过props控制应用状态栏的组件

```tsx
<StatusBar
  translucent
  backgroundColor="transparent"
  barStyle="light-content" // 根据背景色调整
/>
```

#### SafeAreaView

Reacte Native为IOS流海屏提供的安全区域组件，作为App应用的外层容器自带padding边距，使应用内容在安全范围内展示；

推荐使用更强大的 `react-native-safe-context` （支持横向模式/支持自定义edges）实现SafeArea；

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

**box-sizing**

默认组件box-sizing值为border-box，即当固定宽高的组件声明的padding、border会占据宽高区域；

### Flexbox布局

`flexDirection` 默认值为 `column`

`alignContent` 默认值为 `flex-start` 而非 `stretch`

`flexShrink` 默认值同 `flexGrow` 都为0，即默认空间局促下不伸缩

### 绝对/相对定位

默认所有组件为relative定位(无需声明)，如果设置组件absolute定位，注意设置zIndex防止被兄弟组件覆盖上层；

### 文字样式

**fontSize**：默认RNApp字号14(dp)，支持通过fontSize数字类型值设置，且所有文字样式支持在Text组件内继承

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

**lineHeight**

默认存在字号1.x的行高值，建议显示设置1.25以上行高（垂直居中且防截断）

**文字溢出**

```tsx
<Text
  style={styles.fundTitleName}
  numberOfLines={1}
  ellipsizeMode="tail">
  招商双债增强债券LOF(C)
</Text>
```

`ellipsizeMode`：https://www.react-native.cn/docs/next/text#ellipsizemode

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

### 图标

**字体图标**

`react-native-vector-icons` 快速在RN中底层以字体图标方式使用第三方图标(如ant-design)；推荐使用第三方图标库时采用。

自定义的字体图标：将svg格式图标集合转为字体文件，通过 [vector-icons](https://github.com/oblador/react-native-vector-icons?tab=readme-ov-file#custom-fonts) 自定义每个字符的图标name；

svg转字体文件工具：[icomoon](https://icomoon.io/app/#/select) [fontello](https://fontello.com/)

**SVG图标**

`react-native-svg` + `react-native-svg-transformer` 实现在RN中直接引入svg文件作为SvgComponent；

1. `metro.config.js` 新增transformer/resolver配置，见 [use-with-svg-files](https://github.com/software-mansion/react-native-svg/blob/main/USAGE.md#use-with-svg-files)

2. `babel.config.js` extensions选项新增 “.svg” 支持svg转换

3. typescript 新增svg模块文件的类型声明 [using-typescript](https://github.com/kristerkari/react-native-svg-transformer?tab=readme-ov-file#using-typescript)

使用：

```tsx
import IconMcSearchLine from '@/assets/images/svg/mcSearchLine.svg';
<IconMcSearchLine
  style={styles.iconMcSearchLine}
  color="#141736"
  width={18}
  height={18}
></IconMcSearchLine>
```

## 导航跳转

### React Navigation

https://reactnavigation.org

安装依赖库：`npm install react-native-screens react-native-safe-area-context`

安装核心库：`npm install @react-navigation/native-stack`

安装组件库：`npm install @react-navigation/elements`

**创建导航**

```tsx
import { createStaticNavigation } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

const RootStack = createNativeStackNavigator({
  initialRouteName: 'Home', // 初始路由
  screens: {
    Home: HomeScreen,
  },
});

const Navigation = createStaticNavigation(RootStack);

export default function App() {
  return <Navigation />;
}
```

**导航配置**

更多配置参数见：https://reactnavigation.org/docs/headers/

**导航跳转**

```tsx
const Search: React.FC = () => {
  const navigation = useNavigation();
  const onPressSearch = () => {
    navigation.navigate('FundSearch');
  };

  return (
    <TouchableWithoutFeedback onPress={onPressSearch}>
      <View style={styles.search}>
        <Image
          source={require('../../../assets/images/icon/icon-search-line.png')}
          style={styles.iconSearch}
        />
      </View>
    </TouchableWithoutFeedback>
  );
};
```

`navigation.navigate('RouteName')` 进入新路由

`navigation.push('RouteName')` 多次进入新路由（支持原路由多次push）

`navigation.goBack()` 返回上一层

`navigation.popTo('RouteName')` 回退到过去路由

`navigation.popToTop()` 回退到首个路由

### React Native Navigation

https://github.com/wix/react-native-navigation

## 动画

## 存储

### Async Storage

RN 中与 Web 的 Local Storage 类似的功能，一个异步、未加密的键值对存储API；

**安装**

```shell
npm install @react-native-async-storage/async-storage
```

**存储/读取**

```ts
import AsyncStorage from '@react-native-async-storage/async-storage';

const json = JSON.stringify(this.favoriteList);
await AsyncStorage.setItem('@favorite_funds', json);
 
const json = await AsyncStorage.getItem('@favorite_funds');
if (json) this.favoriteList = JSON.parse(json);
```



## 开发

### 路径别名

tsconfig 配置文件通过配置 compilerOptions.paths [自定义项目引入的别名路径](https://www.react-native.cn/docs/typescript#%E5%9C%A8-typescript-%E4%B8%AD%E4%BD%BF%E7%94%A8%E8%87%AA%E5%AE%9A%E4%B9%89%E8%B7%AF%E5%BE%84%E5%88%AB%E5%90%8D)；

### 模拟设备

**安装/新增模拟设备**

android studio 点击 virtual device加号新增设备，next选择android系统版本(31+/33)安装，重启即列表可见新增设备

**命令行启动**

1. 找到 android studio的SDK目录下emulator目录

2. 添加目录到系统环境变量

3. npm scripts新增运行模拟器命令 `"emulator": "emulator -avd Pixel_5_API_33"`

### RN Inspector

Ctrl + M 快捷键进入

### 真机预览

真机开发者模式下，进入开发者选项开启ADB调试使android studio设备列表显示真机设备

### 沉浸式导航栏

**重置状态栏**

状态栏透明、状态栏图标颜色模式（light-content/dark-content）

```tsx
import {StatusBar} from 'react-native';
import {SafeAreaProvider} from 'react-native-safe-area-context';

const App: React.FC = function () {
  return (
    <SafeAreaProvider>
      <StatusBar
        translucent
        backgroundColor="transparent"
        barStyle="light-content" // 根据背景色调整
      />
      <Navigation />
    </SafeAreaProvider>
  );
};
```

Android请在 `android/app/src/main/res/values/styles.xml` 补充配置：

```xml
<item name="android:windowTranslucentStatus">true</item>
```

以支撑 translucent 属性；

**安全的header头**

为header预留padding/margin，其顶部边距值为insets.top/StatusBar.currentHeight

或者为header设置absolute+zIndex覆盖状态栏（注意为页面内容设置marginTop: header高度）

```ts
// header.tsx
  const insets = useSafeAreaInsets();
  // 非必要
  // const statusBarHeight = Platform.select({
  //   ios: insets.top,
  //   android: StatusBar.currentHeight,
  // });

  return (
    <View style={[styles.header, {paddingTop: insets.top}]}></View>
  );
```

## 第三方库

### nativewind

安装nativewind、初始化tailwind.config.js、增加nativewind/babel预设，CSS引入@tailwind、metro.config.js修改、tsconfig引入nativewind/types

**快速开始**：[https://www.nativewind.dev/getting-started/react-native](https://www.nativewind.dev/getting-started/react-native)

**使用**：

```tsx
<Text className="font-bold">加粗内容</Text>
```

### react-native-safe-area-context

为RN App提供安全区域视图(View)的 react context（SafeAreaProvider+useSafeAreaInsets）和组件（SafeAreaView）

https://github.com/AppAndFlow/react-native-safe-area-context
