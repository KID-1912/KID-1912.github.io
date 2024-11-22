---
layout:     post
title:      Element-PLUS
subtitle:   基于 Vue 3 的UI组件库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - 类库
---

# Element PLUS

## 开始

**安装：**`npm i element-plus -S`

**引入**

- 完整引入

- 按需引入

- 自动导入

- 手动导入

详见 [官方文档](https://element-plus.org/zh-CN/)

## 主题

### SCSS 变量

新建 `src/assets/styles/element.variable.scss`，编写scss变量覆盖；详见 [主题 ](https://element-plus.org/zh-CN/guide/theming.html)

```scss
// https://github.com/element-plus/element-plus/blob/dev/packages/theme-chalk/src/common/var.scss
@use 'element-plus/theme-chalk/src/mixins/function.scss' as *;

@forward "element-plus/theme-chalk/src/common/var.scss" with (
  $colors: (
    'primary': (
      'base': #EC1620,
    ),
  ),
  $text-color: (
    "regular": #444444,
    'primary': #666666
  ),
  $border-radius: (
    "base": 4px,
  ),
  $border-color: (
    '': #D9D9D9,
    'lighter': #EBEDF0,
  ),
  $button: (
    'text-color': getCssVar('text-color', 'primary'),
    'hover-link-text-color': getCssVar('color-primary'),
  ),
  $dropdown: (
    'menu-box-shadow': 0px 2px 8px 1px rgba(0,0,0,0.1),
    'menuItem-hover-color': getCssVar('text-color', 'primary'),
    'menuItem-hover-fill': #f4f7fa,
  ),
  $date-editor: (
    "daterange-width": 300px,
  ),
);
```

**引入变量**

```js
// vite.config.js
    css: {
      preprocessorOptions: {
        less: {},
        scss: {
          additionalData: `@use "@/assets/styles/element.variable.scss" as *;`,
        },
      },
    },
```

**注**：如果项目使用了 `unplugin/vue-components` 自动按需导入组件样式，可能导致组件不生效，需关闭按需引入组件样式并引入全局样式：

```js
AutoImport({
  // .....
  resolvers: [ElementPlusResolver({ importStyle: false })],
}),
Components({
  resolvers: [
    ElementPlusResolver({ importStyle: false }),
       // ......
    ]
})
```

**引入全部样式文件**

```scss
// element-plus.scss
@use "element-plus/theme-chalk/src/index.scss" as *;
```

### CSS变量

为元素类声明 css 变量覆盖基础值，适用于单独为某个组件实例定义样式；

```css
.custom-class {
  --el-tag-bg-color: red;
}
```

### ElementPlus类

编写 element-plus 样式覆盖，masn入口引入

```scss
// element-plus.scss
.el-dialog {
  --el-dialog-border-radius: var(--el-border-radius-base);
}

.el-dialog__headerbtn {
  font-size: var(--el-message-close-size, 20px);
}

.el-dialog__footer {
  text-align: initial;
}
```

## Icon(图标)

### 基本使用

**安装**

Element Plus将Icon独立为图标集合

```shell
npm i @element-plus/icons-vue -S
```

**引入**

```js
// icon.js
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 引入所有 也可按需手动引入
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
```

**使用**

```html
<!-- 直接使用Svg -->
<Edit style="width: 16px; height: 1px; margin-right: 4px" />

<!-- ElIcon控制样式 -->
<el-icon class="no-inherit" color="#409EFC" :size="16">

<!-- 组件icon值 -->
<el-button type="primary" icon="Edit">修改</el-button>
```

### 自动导入

```js
// webpack.config.js
const Components = require("unplugin-vue-components/webpack");
const Icons = require("unplugin-icons/webpack");
const IconsResolver = require("unplugin-icons/resolver");

module.export = {
  // ......
  plugins: [
    Components({
      resolvers: [
        // 自动导入svg图标组件
        IconsResolver({
          prefix: false,  // 省略前缀 默认组件前缀 icon
          enabledCollections: ["ep"],  // icon集合，ep即elementplus图标集
          alias: { 'el-svg': "ep" },  // 别名 使用'el-svg'作为'ep'别名
        }),
        ElementPlusResolver(),
      ],
    }),
    // 自动安装图标集，无需另外安装
    Icons({ compiler: "vue3", autoInstall: true })
  ]
};
```

**自定义Icon**

```js
// webpack.config.js
const { FileSystemIconLoader } = require('unplugin-icons/loaders')
Components({
  resolvers: [
    IconsResolver({
      prefix: false,
      alias: { "el-svg": "ep" },
      enabledCollections: ["ep"],
      customCollections: ["svg"],  // 自定义集合添加解析
    }),
    ElementPlusResolver(),
  ],
}),
Icons({
  compiler: "vue3",
  autoInstall: true,
  // 自定义icon图标集合
  customCollections: {
    // 指定导入目录为名称为svg图标集
    svg: FileSystemIconLoader(resolve("src/icons/svg")),
  },
}),
```

**使用**

```html
<!-- 
  默认组件名 按{prefix}-{collection}-{icon}
  配置别名后 elementplus图标使用 el-svg-icon名称
  自定义图标集使用 svg-icon名称
-->
<ELSvgPlus />
<SvgLogo />
```

vite详见  [element-plus-best-practices](https://github.com/sxzz/element-plus-best-practices/blob/db2dfc983ccda5570033a0ac608a1bd9d9a7f658/vite.config.ts#L21-L58)

自动导入插件 [unplugin-icons](https://github.com/antfu/unplugin-icons)

## Layouts(布局)

```html
<script setup>
import AppHeader from "./header/header.vue";
import AppSidebar from "./sidebar/sidebar.vue";
</script>

<template>
  <div class="h-100vh flex flex-col">
    <AppHeader></AppHeader>
    <el-container class="layout-container">
      <AppSidebar></AppSidebar>
      <el-main>
        <slot></slot>
      </el-main>
    </el-container>
  </div>
</template>

<style lang="scss" scoped>
.layout-container {
  height: 0;
  .el-main {
    padding: 0;
  }
}
</style>
```

## 分页(Pagination)

推荐使用 `@update:current-page` 替代 `@current-page`

```html
<el-pagination
  :current-page="1"
  :page-size="10"
  :total="0"
  @update:current-page="handlePageChange"
  layout="prev, pager, next"
  background
></el-pagination>
```

**分页Hook封装**

```js
export const useActivityManageList = (filter, pager) => {
  filter = ref(filter)
  pager = ref(pager);
  const activityList = ref([]);
  const loading = ref(false);
  const getActivityList = async () => {
    if (loading.value) return;
    const params = {
      pageIndex: pager.value.pageIndex,
      pageSize: pager.value.pageSize,
      ...toValue(filter),
    };
    loading.value = true;
    try {
      const { data } = await api.getActivityManageList(params);
      activityList.value = data.records;
      pager.value.pageIndex = data.current;
      pager.value.pageSize = data.size;
      pager.value.pageTotal = data.total;
      pager.value.pageCount = data.pages;
    } catch (error) {
      console.warn(error);
      ElMessage.error("活动数据获取失败");
    }
    loading.value = false;
  };

  return {
    activityList,
    loading,
    getActivityList,
  };
}; 

export const usePager = (pagerOptions) => {
  const pager = ref({
    pageIndex: pagerOptions.pageIndex ?? 1,
    pageSize: pagerOptions.pageSize ?? 10,
    pageTotal: pagerOptions.pageTotal ?? 0,
    pageCount: pagerOptions.pageCount ?? 0,
  });
  return pager;
};

// 组件使用 
const pager = usePager();
const { 
  activityList,
  getActivityList,
  loading
} = useActivityManageList(params, pager); 
const getActivityListWithPageIndex = (pageIndex) => {
  if (loading.value) return;
  pager.value.pageIndex = pageIndex;
  getActivityList();
};
```

```html
<el-pagination
  layout="jumper"
  :current-page="pager.pageIndex"
  :page-size="pager.pageSize"
  :total="pager.pageTotal"
  background
  @update:current-page="getActivityListWithPageIndex"
/>
```

## Table(表格)

### 固定列适配

表格小屏下固定列实现宽度适配：

```html
<el-table-column label="标题" min-width="200">
<el-table-column label="人数" min-width="120">
<el-table-column label="次数" min-width="120">
<el-table-column label="操作" fixed="right" min-width="250">
```

通过 `min-width` 设置小屏下表格列的最小值（大屏会随宽度计算占比）

补充：覆盖样式实现表格宽度最小值，使大屏下表格宽度占满

```scss
.el-table__header-wrapper{
  min-width: 100%;
}
.el-table__body-wrapper {
  .el-scrollbar__view, .el-table__body {
    min-width: 100%;
  }
}
```

## Issues

### outline bug

dropdown 或 popover 组件展开菜单层，出现黑色的outline

```scss
[role="button"]:focus-visible {
  outline: none;
}
```
