---
layout:     post
title:      TypeScript
subtitle:   一套开源内容编辑和实时协作工具，基于ProseMirror
date:       2023-11-27
author:     page
header-img: img/TypeScript.png
catalog: true
tags:
    - JavaScript
---

# TypeScript

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

## 基础类型

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
interface Article{
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
class Book{
  pageTotal: number;
  constructor(name: string, author: Author){
    
  }
  
  getBookPageTotal(): number {
    return  this.pageTotal;  
  }
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






























