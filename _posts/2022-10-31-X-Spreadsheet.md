---
layout:     post
title:      WindiCss
subtitle:   基于 Web(es6) canvas 构建的轻量级 Excel 开发库
date:       2021-10-31
author:     page
header-img: img/post-bg-excel.jpg
catalog: true
tags:
    - 类库
---

# x-spreadsheet

[中文文档](https://hondrytravis.com/x-spreadsheet-doc/) [GitHub x-spreadsheet](https://github.com/myliang/x-spreadsheet) [SheetJs官网](https://docs.sheetjs.com/docs/)

## 安装

```shell
npm i x-data-spreadsheet -S
```

## 使用

### 创建表格

```html
<template>
  <div class="sheetBox"></div>
</template>

<script>
  import XLSX from 'xlsx';
  import Spreadsheet from 'x-data-spreadsheet';
  import 'x-data-spreadsheet/dist/locale/zh-cn';
  Spreadsheet.locale('zh-cn');

  const options = {
    showToolbar: false,  // 显示工具栏
    showContextmenu: false, // 右键显示菜单
    showBottomBar: false,  // 显示底部信息
    view: { height: 618, width: 1000 },  // 表格视图宽高
    row: { height: 30, len: 100 },  // 行高与行数
    col: { width: 90, len: 26 }  // 列高与列数
  };

  const sheetEditor = new Spreadsheet(".sheetBox", options));
</script>
```

### xlsx转换

**spreadData转Excel工作表**

`xtos` `stox` 方法存放于 sheetjs下 `sheet/demos/xspreadsheet/xlsxspread.js` 目录

```js
import { xtos,stox } from '@/plugins/xlsxspread.js';

const spreadSheetData = sheetEditor.getData();

function toSheet(spreadSheetData) {
  const workbook = xtos(spreadSheetData);
  // XLSX.writeFile(xtos(spreadSheetData), "SheetJS.xlsx");
  return workbook.Sheets[workbook.SheetNames[0]];
}
```

**spreadData转Excel工作表**

官方说明：`https://docs.sheetjs.com/docs/demos/grid#x-spreadsheet`

## 方法

`sheetEditor.sheet.reload()` 重载表格

 `this.sheetEditor.loadData({})` 清空表格
