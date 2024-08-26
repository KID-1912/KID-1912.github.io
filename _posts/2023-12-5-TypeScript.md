---
layout:     post
title:      TypeScript
subtitle:   在 JavaScript 的所有功能之上添加了一层： TypeScript 的类型系统。
date:       2023-11-27
author:     page
header-img: img/TypeScript.png
catalog: true
tags:
    - TypeScript
---

# TypeScript

[官方文档](https://www.typescriptlang.org/) [TypeScript 教程 - 阮一峰](https://wangdoc.com/typescript/)

## 安装

`typescript` 编译器

```shell
npm i typescript -g
```

`tsc index.ts` 编译index.ts并输出为js

`tsc --init` 初始化 `tsconfig.js` 配置文件

`ts-node` node下ts编译后执行（可选）

```shell
npm i ts-node -g
```

`ts-node index.ts` 立即执行 `index.ts` 并输出结果

## 类型标注

声明赋值，类型确定

```ts
let a = '你好'
```

提前标注

```ts
let b: string = '下午好'
```

### 基础类型

**数字/字符串/布尔值**

```ts
let num: number = 1;
let str: string = '';
let loading: boolean = false;
```

**数组类型**

```ts
const list: string[] = [];
const arr: Array<string> = []; // 推荐
```

**对象类型**

定义接口

```ts
interface Article {
  title: string,
  id: number,
  published: boolean
  category?: string // 可选属性
}
```

标注对象

```ts
const currentArticle: Article = {
  title: '',
  id: 0,
  published: false
}
```

标注类型

```ts
const articleList: Array<Article> = [];

interface Author {
  name: string,
  artist: Array<Article>
} 
```

### 枚举

Ts通过带名字的常量实现枚举有限范围的值，枚举值允许数字/字符串类型

```ts
enum ArticleStatus {
  DRAFT = 0,
  PUBLISHED = 1
  DELETED, // 忽略，则基于上一个自增
}
console.log(ArticleStatus.DRAFT)
console.log(article.status === ArticleStatus.DRAFT);
```

### Map

```ts
const map = new Map<number, string>(); // 标着映射类型
map.set(1, '1');
```

### Set

```ts
const set = new Set<number>(); // 标着映射类型
set.add(1);
```

## 函数类型

### 标注参数/输出类型

```ts
const getArticleStatus = (status: ArticleStatus): string => {
  switch(status) {
    case ArticleStatus.DRAFT:
      return 'draft';
    case ArticleStatus.PUBLISHED:
      return 'published';
    case ArticleStatus.DELETED:
      return 'deleted';
    default:
      return 'unknown';
  }
}

function getArticleStatus2(status: ArticleStatus): string {
  switch(status) {
    case ArticleStatus.DRAFT:
      return 'draft';
    case ArticleStatus.PUBLISHED:
      return 'published';
    case ArticleStatus.DELETED:
      return 'deleted';
    default:
      return 'unknown';
  }
}
```

void：无返回语句

```ts
// 标记返回值void类型
const fun = function(p1: string): void {
  console.log(p1)
}
// 标记返回值undefiend类型
const handle = (p1: string): undefined {
  console.log(p1)
  return; // 必须返回undefined类型值
}
```

### 函数重载

Ts实现了类型层面的重载，罗列函数参数所有类型组合

```ts
function getDomClassList(id: string): string;
function getDomClassList(list: Array<string>): string;
function getDomClassList(id: string | Array<string>): string {
  if(typeof id === 'string') return id;
  if(id instanceof Array) return id.join(' ');
  return '';
};
```

### Class类

为class类增加类型描述

```ts
class Book {
  pageTotal: number;
  constructor(name: string, author: Author){

  }

  getBookPageTotal(): number {
    return  this.pageTotal;  
  }
}

// public 关键词
class A {
  constructor(public name: string, public age: number){

  }
  private ... // 仅类内可访问
  protected ...  // 仅类内和子类内可访问
}
```

## any

任意类型，即所有其他类型，这使TypeScript无法类型检查从而可能导致不可预见错误；

## unknown

任意类型，但是保留类型检查

通过类型断言，在未标注类型下赋予变量类型，让开发者按预期类型处理

```ts
(param as unknown[]).map(item => item);
(str as any).handler();
const { name, job = {} as IJob } = user;
```

## 联合/交叉类型

**类型别名**

通过类型别名实现类型复用

```ts
type computed = (unknown) => string;

const name: computed = (person) => person.name;
const id: computed = (person) => person.id;
```

或者类似 `Interface` 作用

```ts
type Person {
  name: string,
  age: number
}
```

**联合类型**

通过多类型配合类型别名创建自定义的联合类型

使用 `|` 或关系联合类型

```ts
type isSuccess = number | boolean;
let isSuccess: isSuccess = 0;
isSuccess = true;
type User = VisitorUser | CommonUser | VIPUser | AdminUser;
```

使用 `&` 且关系联合类型

```ts
const temp = (Animal | Person) & (GameObject)
```

**字面量联合类型**

变量类型只能是指定值的类型且相等

```ts
type Status = 'pengding' | 'success' | 'failure';
type code = 200 | 400 | 500
```

## 泛型

动态可复用的类型

如配合类型别名创建**工具类型**，其中泛型作为参数存在（主动赋值）

```ts
type Status<T> = number | boolean | T;
let status: Status<string> = 'success'
```

或者在标注类型时，使用泛型表达一个动态的未来类型，并对它复用（自动推导）

```ts
function fun<T>(param: T): T {
  return param
}
```

## 类型断言

允许开发者在代码中“断言”某个值的类型。TypeScript 一旦发现存在类型断言，就不再对该值进行类型推断，而是直接采用断言给出的类型。

```ts
interface Task {
  __type: "task";
  id: string;
  // .....
  scheduledAt: Date | null;
}

const task: Task = {
  // .....
  scheduledAt: task.scheduledAt ? Timestamp.fromDate(task.scheduledAt as Date) : null
}
```

```tsx
// 断言为HTMLDivElement，不为null
const container = document.getElementById("root") as HTMLDivElement;

ReactDOM.createRoot(container).render(
  <React.StrictMode>
      <App />
  </React.StrictMode>,
);
```

**断言unknown类型**

```tsx
export type AppRouteObject = {
  order?: number;
  meta?: RouteMeta;
  children?: AppRouteObject[];
} & Omit<RouteObject, 'children'>;

const routes: AppRouteObject[] = []; // 自定义的AppRouteObject类型
const router = createHashRouter(routes as unknown as RouteObject[]);

 request<T = any>(config: AxiosRequestConfig): Promise<T> {
    return new Promise((resolve, reject) => {
      axiosInstance
        .request<any, AxiosResponse<Result>>(config)
        .then((res: AxiosResponse<Result>) => {
          resolve(res as unknown as Promise<T>);
        })
        .catch((e: Error | AxiosError) => {
          reject(e);
        });
    });
  }
```

**非空断言**

```tsx
const root = document.getElementById('root')!;


const UserContext = createContext<User | null>(null);
const userId: string = user!.uid; // 断言user不为null
```

## 模块

```ts
export interface A {
  foo: string;
}
export let a = 123;

import { type A, a } from './a';
import type { A } from './a';
import type * as TypeNS from 'moduleA';
```

## declare

向TS编译器描述项目外部的类型，只声明不实现

```ts
// plugins.d.ts
declare module "qs";
declare module "nprogress";
declare module "js-md5";
declare module "react-transition-group";
```

使用declare global {}语法，为 JavaScript 引擎的原生对象添加属性和方法

```ts
// * global
declare global {
    interface Window {
        __REDUX_DEVTOOLS_EXTENSION_COMPOSE__: any;
    }
    interface Navigator {
        msSaveOrOpenBlob: (blob: Blob, fileName: string) => void;
        browserLanguage: string;
    }
}
export {};
```

## 工具类型

前面提到通过泛型实现工具类型，Ts内置了一些工具类型：

**Partial**

接收一个对象类型，并将这个对象类型的所有属性都标记为可选

```ts
type User = {
  name: string;
  age: number;
  email: string;
};
const girl: Partial<User> ={};

type PartialUser = Partial<{
  name: string;
  age: number;
  email: string;
}>;
const boy: PartialUser = {};
```

**Readonly**

接收一个对象类型，并将这个对象类型的所有属性都标记为只读

```ts
type ReadonlyUser = Readonly<{
  name: string;
  age: number;
  email: string;
}>;
```

**Record**

快速对象类型的键值类型标注

```ts
type Field = 'name' | 'job' | 'email'
type User = Record<Field, string>
const user: User = {
  name: 'xxx',
  job: 'worker',
  email: 'xxx.com'
};
const user: Record<string,string> = {
  name: 'xxx',
  job: 'worker',
  email: 'xxx.com'
};
```

**Pick & Omit**

Pick：对传入对象类型取其中部分键值类型值作为新类型返回

Omit：对传入对象类型排除部分键值类型值作为新类型返回

```ts
type BasicInfo = Pick<User, 'name' | 'age'>;
type MoreInfo = Omit<User, 'name' | 'age'>;
interface NewTask extends Pick<Task, "__type" | "done" | "name"> {}
```

**Exclude & Extract**

Exclude：对联合类型执行差集操作后类型值作为新类型返回

Extract：对联合类型执行交集操作后类型值作为新类型返回

```ts
type UserProps = 'name' | 'age' | 'email' | 'phone' | 'address';
type RequiredUserProps = 'name' | 'email';

type OptionalUserProps = Exclude<UserProps, RequiredUserProps>;
type RequiredUserPropsOnly = Extract<UserProps, RequiredUserProps>;
```

**Parameters & ReturnType**

Parameters：从函数类型中提取入参类型作为新类型返回

ReturnType：从函数类型中提取返回值类型作为新类型返回

```ts
type Add = (x: number, y: number) => number;

type AddParams = Parameters<Add>; // [number, number] 类型
type AddResult = ReturnType<Add>; // number 类型

const addParams: AddParams = [1, 2];
const addResult: AddResult = 3;
```

**typeof** 关键字

对一个Js变量值提取Ts类型值作为新类型返回

```ts
const addHandler = (x: number, y: number) => x + y;

type Add = typeof addHandler; // (x: number, y: number) => number;
type User = typeof person;
```

**Awaited**

提取一个 `Promise` 类型的返回值类型 

```ts
async function getPromise() {
  return new Promise<string>((resolve) => {
    setTimeout(() => {
      resolve("Hello, World!");
    }, 1000);
  });
}

type Result = Awaited<ReturnType<typeof getPromise>>; // string 类型
```

## 类型声明.d.ts

单独单纯的类型声明文件：把本模块的外部接口的所有类型都写在这个文件里面，便于模块使用者了解接口，也便于编译器检查使用者的用法是否正确。

```ts
// 模块声明
declare module App {
  create(string?: string): string
  ...
}
// 变量声明
declare var window: Window & typeof globalThis;
```

生成类型声明文件：

```shell
tsc index.ts --declaration
```

在ts开发的npm，需告知类型声明文件位置

```json
{
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts", // 包的类型声明文件
}
```

## 模板字符串类型

ts支持字符串类型额外的模板结构描述，如

```ts
type Tel = `${number}-${number}`
type Version = `${number}.${number}.${number}`

type SayHello = `Hello ${string | number}`
const sayStr: Say =  'Hello name'
const sayNum: Say =  'Hello 666'

type SayHello<T extends string | number> = `Hello ${T}`;
```

配合联合类型，得到更多组合模式的联合类型

```ts
type Brand = 'iphone' | 'xiaomi' | 'honor';
type Memory = '16G' | '64G';
type ItemType = 'official' | 'second-hand';

type SKU = `${Brand}-${Memory}-${ItemType}`;
```

## 编译配置

Ts编译主要负责语法降级和类型定义的生成，编译配置类别包括产物控制、输入与输出控制、类型声明、代码检查等

### 产物控制

**target：** 控制产物语法的 ES 版本

**module:**  控制产物模块化规则

**outDir：** 输出目录

**types：** 仅加载指定类型定义包

```json
{
  "compilerOptions": {
    "module": "ESNext"/"commonjs",  // TS生成的模块代码的格式
    "moduleResolution": "Bundler",  // 指定TS如何解析模块导入，Node/Bundler
    "lib": ["DOM", "DOM.Iterable", "ESNext"],  // 定义可用的全局变量和类型的库文件
    "skipLibCheck": true,  // 跳过对所有声明文件（.d.ts 文件）的类型检查  
    "target": "ESNext", // TS编译结果的ECMAScript版本：ES5、ES6、ESNext
    "outDir": "dist"  // 输出目录
    "types": ["node", "react"],  // 自动加载 @types/node、@types/react 类型包
    // more
    "allowImportingTsExtensions": , // 允许导入.ts和.tsx文件
    "jsx": "react-jsx",  // 指定TS如何处理jsx语法
    "noEmit": true,  // 仅进行类型检查和编译，不生成.js与.d.ts文件
    "esModuleInterop": true, // 允许import非ES模块，启用ES模块互操作性支持
    "allowSyntheticDefaultImports": true, // 允许使用默认导入语法，即使模块实际没有默认导出
    "baseUrl": ".",  //  TS编译器解析模块的基准目录，通常与paths使用
    "paths": { "@/*": ["./src/*"] }, // 声明解析别名
    "include": ["./src", "auto-imports.d.ts"], // 限定编译文件
    "forceConsistentCasingInFileNames": true, // 模块导入时强制文件名大小写一致性
    "sourceMap": true,  // 是否生成源映射文件用于调试
    "plugins": [{ "name": "typescript-plugin-css-modules" }] // ts 插件
    "useDefineForClassFields": true,
    "allowJs": false,
    "strict": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
  }
}
```

### 输入控制

**include：** 输入文件范围

**exclude：** 输入文件排除范围

```tsconfig
{
  "include": [
    "src/**/*",
     "auto-imports.d.ts" // 引入全局变量，自动引入的变量
  ],
  "exclude": [
    "src/excludeDir",
    "**/*.spec.ts"
  ]
}
```

### 类型相关配置

**declaration：** 是否生成 .d.ts

**emitDeclarationOnly：** 仅生成.d.ts

**noEmit：** 不生成任何文件，仅类型检查

### 类型检查配置

**noImplicitAny：** 是否不允许隐式any存在
