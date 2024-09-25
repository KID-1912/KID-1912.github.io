---
layout:     post
title:      Firebase
subtitle:   由 Google 提供的移动和 Web 应用开发平台，提供数据库、身份验证、托管等多种服务，帮助开发者快速构建和优化应用
date:       2024-8-27
author:     page 
header-img: img/firebase.png
catalog: true
tags:
    - 服务端
---

# Firebase

[Firebase官网](https://link.juejin.cn/?target=https%3A%2F%2Ffirebase.google.com%2F%3Fhl%3Dzh-cn "https://firebase.google.com/?hl=zh-cn")   [Firebase控制台](https://link.juejin.cn/?target=https%3A%2F%2Fconsole.firebase.google.com%2F "https://console.firebase.google.com/")

## Firebase应用

### 引入

```shell
npm install firebase --save
```

### 初始化

Firebase 控制台创建项目并添加应用，本地项目初始化逻辑：

```ts
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "xxx",
  authDomain: "xxx",
  projectId: "xxx",
  storageBucket: "xxx",
  messagingSenderId: "xxx",
  appId: "xxx",
  measurementId: "xxx",
};

// Initialize Firebase
export const firebaseApp = initializeApp(firebaseConfig);
export const firebaseAuth = getAuth(firebaseApp);
```

关于 `firebaseConfig` 配置，可在控制台的 【项目概览】—【项目设置】—【常规】—【您的应用】—【SDK 设置和配置】中查看到项目配置信息；

## Authentication

[Firebase Authentication文档](https://firebase.google.com/docs/auth/web/password-auth?hl=zh-cn)

### 邮箱验证链接实现注册

- 编写注册页，邮箱和密码后点击注册，发送验证邮件（传递注册表单信息）
- 手机端接收信息，点击链接将跳到应用指定链接，应用指定链接判断到验证身份链接，验证身份登录后设置用户密码
- pc 点击“验证链接已通过，去登录”，将携带账号密码去等登录页

## Firestore Datebase

[Cloud Firestore 使用入门  |  Firebase](https://firebase.google.com/docs/firestore/quickstart?hl=zh-cn#initialize)

### FirestoreDataConverter

**定义文档数据与应用程序数据之间的转换逻辑**，方便数据的序列化和反序列化。\

### 索引

涉及了 **复合查询**、**排序、过滤和混合查询**，必须在控制台 Firestore Database添加索引；

## Hosting

**安装**：`npm install -g firebase-tools`

**登录**：`firebase login`，根据命令行提示步骤通过身份验证

若登录失败，命令行尝试后重试：

```shell
set HTTP_PROXY=http://127.0.0.1:7890
set HTTPS_PROXY=http://127.0.0.1:7890
```

**初始化项目**：`firebase init`    配置 `firebase.json`

**部署**：`firebase deploy`
