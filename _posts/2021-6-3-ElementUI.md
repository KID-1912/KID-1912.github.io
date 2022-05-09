---
layout:     post
title:      Element-UI
subtitle:   快速搭建后台vue库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - Element-UI
---

# Element-UI

## 布局

### 结构布局

- \<el-container>：外层容器
- \<el-header>：顶栏容器
- \<el-aside>：侧边栏容器
- \<el-main>：主要区域容器
- \<el-footer>：底栏容器

### 内容布局

- \<el-page-header>：页头
- \<el-card>：卡片
- \<el-table>：表格
- \<el-image>：图片
- \<el-drawer>：抽屉

### 弹性布局

- \<el-row> + \<el-col>
  - \<el-col :span="12">（分为24份span）
  - \<el-row :gutter="20">（指定每栏左右padding）
  - \<el-col :span="6" :offset="6">（offset向后偏移）
  - \<el-row type="flex" justify="start/center/end/space-between/around">（子栏目对齐）
  - \<el-col :xs="8" :sm="6" :md="4" :lg="3" :xl="1">（响应式）
  - \<el-row :span="6" class="hidden-xs-only/...">（响应式显示隐藏类;import 'element-ui/lib/theme-chalk/display.css';）



## 组件

### Pagination分页

- 组件

```html
  <el-pagination
    :current-page.sync="pageState.pageIndex"
    :page-size.sync="pageState.pageSize"
    :total.sync="pageState.pageTotal"
    :page-sizes="pageState.pageSizes"
    layout="sizes, prev, pager, next"
    @current-change="fetch"
    @size-change="fetch"
  >
  </el-pagination>
```

- 状态管理

```js
  data() {
    return {
      // 分页
      pageState: {
        pageIndex: 1,
        pageSize: 10,
        pageTotal: 0,
        pageSizes: [10, 20, 30]
      }
    };
  }
```

- 请求

```js
fetch(){
  const size = this.pageState.pageSize;
  const index = this.pageState.pageIndex - 1; // 后端分页从0开始
  ...具体请求方法(index,size)
  .then(res => this.pageState.pageTotal = res.result.total) // 更新总页数
}
```



## Upload上传

#### 单文件上传

- Upload组件

```html
<!-- 此处为分离上传操作 -->
<el-upload
  ref="uploader"
  accept=".csv, application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  name="文件参数字段名，默认file"
  :data="{...额外请求字段与参数}"
  :action="uploadUrl"
  :auto-upload="false"
  :on-success="uploadSuccess"
  :on-error="uploadError"
  :on-change="uploadChange"
  :on-remove="resetUpload"
>
  <el-button slot="trigger" plain>
    {{ uploadReady ? "重新选择" : "点击上传" }}
  </el-button>
  <el-button
    type="primary"
    :loading="uploading"
    @click="uploadFile"
    >确定上传</el-button
  >
  <el-button @click="closeDialog" plain>取 消</el-button>
</el-upload>
```

- 状态管理

```js
uploading: false, // 上传中
uploadReady: false, // 上传文件就绪
```

- 相关操作方法

```js
 uploadChange(file, fileList) {
   // 文件列表改变：上传列表中保持只有一个文件
   if (fileList.length > 1) {
     fileList.splice(0, 1);
   }
   if (fileList.length != 0) {
     this.uploadReady = true;
   }
 },
 // 点击开始上传事件
 uploadFile() {
   if (!this.uploadReady) {
     this.$message({ type: "error", message: "请先选择上传文件" });
     return false;
   }
   this.uploading = true;
   this.$refs.uploader.submit();
 },
 // 上传成功回调
 uploadSuccess(res) {
   this.uploading = false;
   if (res.retCode === 0) {
     this.$message({ type: "success", message: "上传成功" });
     this.closeDialog();
     this.fetch();
   } else {
     this.resetUpload();
     this.$message({ type: "error", message: "上传失败" });
   }
 },
 // 请求失败导致的上传失败
 uploadError() {
   this.uploading = false;
   this.resetUpload();
   this.$message({ type: "error", message: "上传失败" });
 },
 // 重置上传文件列表
 resetUpload() {
   this.$refs.uploader.clearFiles();
   this.uploadReady = false;
 }
```



## Dialog弹窗

```vue
// template
<Dialog1 :dialog.sync="dialogName" />
<Dialog2 :dialog.sync="dialogName"/>
<Dialog3 :dialog.sync="dialogName"/>

// 开启弹窗
this.dialogName = 'dialog1';
```

```vue
// Dialog1
<template>
	<el-dialog :visible="dialogName === 'dialog1'">
		dialog1 content
		<template #footer>
            <el-button @click="close">关闭</el-button>
		</template>
    </el-dialog>
</template>	

// 关闭弹窗
this.$emit('update:dialogName','');
```

#### 合并弹窗

对管理后台(admin)的表格数据行进行增删改查操作，适合合并操作弹窗

- 组件

```html
<el-dialog
  :visible.sync="dialogVisible"
  :title="dialogTitle[dialogType]"
  :close-on-click-modal="false"
  :show-close="false"
>
  <template>
    <div v-if="dialogName == 'dialog1'"></div>
    ...
  </template>
</el-dialog>
```

- 状态管理

```js
this.dialogTitle = {
  dialog1Title: "弹窗1标题",
  ...
};
// data
dialogName: "",
currentEditRecord: null, // 当前弹窗关联对象
// computed
dialogVisible(){
  return this.dialogName ? true: false;
}
```

- 开启/关闭弹窗

```js
openDialog(name, editRecord) {
  this.dialogName = name;
  editRecord && (this.currentEditRecord = editRecord);
},
closeDialog() {
  // 弹窗关闭前处理
  this.dialogName == "dialog1" && (特定弹窗关闭前处理);
  ...
  this.dialogName = "";
}
```

#### 弹窗状态

弹窗来自外部状态，则弹窗开启时clone外部状态作为临时状态，弹窗编辑修改临时状态，修改成功则同步至外部状态；

弹窗需要单独接口返回状态下，弹窗创建请求接口得到弹窗状态；弹窗开启时clone弹窗状态作为临时状态，弹窗编辑修改临时状态，修改成功则同步为弹窗状态；

### Table表格

#### 内置插槽

header(动态表头)

```vue
<template #header="{column, $index}">列{{$index}}</template>
```

empty(空数据占位)

```vue
<template #empty><div>暂无数据...</div></template>
```

#### 宽度自适应

```vue
// min-width 按照百分比分配剩余空间
<el-table-column prop="id" min-width="10%"/>
<el-table-column prop="name" min-width="45%"/>
<el-table-column prop="tel" min-width="45%"/>
```

#### 多选行

```vue
<el-table row-key="info.id">
	// reserve-selection 数据更新不销毁选中状态
	<el-table-column type="selection" reserve-selection />
</el-table>
```

#### 重复列

| 姓名 | 分数 | 姓名 | 分数 | 姓名 | 分数 |
| :--: | :--: | :--: | :--: | :--: | :--: |
| xxx  |  **  | xxx  |  **  |  xx  |  **  |
| xxx  |  **  | xxx  |  **  |  xx  |  **  |

1. 假设tableList为表格数据，基于tableList.length计算出最终显示行数，行数由数组lineLength决定

   ```js
   // 非空时计算行数，空数组则默认按空数据显示表格
   if (this.tableList.length > 0) {
     let num = Math.ceil(this.tableList.length / 3); // 3列复用
     this.lineLength = new Array(num).fill("");
   }
   ```

2. $index行索引 + index数据索引计算出位置对应显示数据

   ```html
   <el-table :data="lineLength">
     <template v-for="(num, index) in 3">
       <el-table-column label="名称" :key="`${num}.name`">
         <template #default="{ $index }">
           <div v-if="$index * 3 + index < tableList.length">
               {{ tableList[$index * 3 + index].name }}
            </div>
           <span v-else>-</span>
         </template>
       </el-table-column>
       <el-table-column label="数量" :key="`${num}.count`">
         <template #default="{$index}">
           <div v-if="$index * 3 + index < tableList.length">
               {{ tableList[$index * 3 + index].count }}
            </div>
           <span v-else>-</span>
         </template>
       </el-table-column>
     </template>
   </el-table>
   ```



### Form表单

#### 检验

- el-form:model + el-form-item:prop + :rules/required检验
- prop支持:prop="属性.index.属性"字符串链式访问
- form-item自定义校验：required/rules前置检验 + :error="error变量" + 校验时nextTrick修改error变量 + form-item:foucs/每次检验前 重置error变量



### Message消息

```js
// element.js
...
Vue.prototype.$message = $message;

// $message
// this.$message方式调用
function $message(options) {
  if (typeof options == "string") options = { message: options };
  options.duration = options.duration || 1600;
  Message(options);
}
// this.$message.type方式调用(关闭其它Message提示)
["success", "error", "warning", "info"].forEach(type => {
  $message[type] = function(msgStr) {
    Message.closeAll();
    var options = typeof msgStr == "string" ? { message: msgStr } : msgStr;
    options.type = type;
    options.duration = options.duration || 1600;
    Message(options);
  };
});
```



### Loading加载

```js
// element.js
...
Vue.prototype.$loading = $loading;

// $loading
function $loading(handle, options) {
  if (typeof options == "string") options = { text: options };
  options = { ...options, background: "rgba(0, 0, 0, 0.7)" };
  let loadingInstance = Loading.service(options);
  handle = handle instanceof Function ? handle() : handle;
  return handle.finally(() => {
    loadingInstance.close();
  });
}

// 使用
this.$loading(this.fetch,"数据加载中...");
```



### Menu侧边栏

```vue
<template>
  <div id="sidebar" class="fulled-h">
    <el-scrollbar>
      <el-menu
        :router="true"	// 路由模式
        :default-active="activeRoute"	// 默认激活路径
        :default-openeds="defaultOpeneds"	// 默认展开选项
        @close="index => $refs.menu.open(index)"
        ref="menu"
      >
        <template v-for="route in adminRoutes">
          <!-- 仅一级 -->
          <template v-if="!route.meta.title && route.children.length == 1">
            <el-menu-item :index="route.path" :key="route.path" class="fs-md">
              <svg-icon :iconClass="route.meta.icon" class="mr-12"></svg-icon
              >{{ route.children[0].meta.title }}
            </el-menu-item>
          </template>
          <!-- 两级 -->
          <template v-else>
            <el-submenu :key="route.path" :index="route.path">
              <template slot="title">
                <div class="d-flex al-center fs-md">
                  <svg-icon :iconClass="route.meta.icon" class="mr-12"></svg-icon>
                  <div>{{ route.meta.title }}</div>
                </div>
              </template>
              <el-menu-item
                v-for="item in route.children"
                :key="item.path"
                :index="`${route.path}/${item.path}`"
                class="t-grey"
              >
                <div class="menu-item_inner px-12 bd-filt">{{ item.meta.title }}</div>
              </el-menu-item>
            </el-submenu>
          </template>
        </template>
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  computed: {
    // 路由为数据
    ...mapGetters(["adminRoutes"]),
    // 当前激活路由
    activeRoute() {
      return this.$route.fullPath;
    },
    // 默认所有submenu展开
    defaultOpeneds() {
      return this.adminRoutes.map(route => route.path);
    }
  }
};
</script>
<style lang="scss" scoped>
// 隐藏组件scrollbar
.el-scrollbar{
  height: 100%;
  .el-scrollbar__wrap{
    overflow-x: hidden
  }
}
</style>
```

### Breadcrumb面包屑

```vue
<template>
    <el-breadcrumb
      v-show="matched && matched.length > 1"
      separator-class="el-icon-arrow-right"
      class="px-24 py-12 bgc-white"
    >
      <el-breadcrumb-item
        v-for="(route, index) in matched"
        :class="{ 'route-top': index !== matched.length - 1 }"
        @click.prevent="toRoute(index, route.path)"
        :key="route.path"
        >{{ route.meta.title }}</el-breadcrumb-item
      >
    </el-breadcrumb>
</template>

<script>
export default {
  computed: {
    matched() {
      var matched = this.$route.matched;
      return matched.filter(route => route.meta && route.meta.title);
    }
  },
  methods: {
    toRoute(index, path) {
      // 1级路由标题和当前路由标题不可跳转
      if (index == 0 || index == this.matched.length - 1) return;
      this.$router.push(path);
    }
  }
};
</script>
```



## Scrollbar滚动

```vue
<div style="height: 560px">
	<el-scrollbar>
    	scroll content
	</el-scrollbar>
</div>	

<style>
.el-scrollbar {
  height: 100%;
  .el-scrollbar__wrap {
    overflow-x: hidden;
  }
}
</style>
```

