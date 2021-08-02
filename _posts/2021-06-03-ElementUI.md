---
layout:     post
title:      Element-UI
subtitle:   快速搭建后台vue库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - vue
    - 后台开发
    - 类库工具
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
    @current-change="fetch"
    @size-change="fetch"
    :current-page.sync="pageState.pageIndex"
    :page-size.sync="pageState.pageSize"
    :total.sync="pageState.pageTotal"
    :page-sizes="[10, 20, 30]"
    layout="sizes, prev, pager, next"
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
        pageTotal: 0
      }
    };
  }
```

- 请求

```js
fetch(){
  const size = this.pageState.pageSize; // 后端分页从0开始
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



### 弹窗Dialog

#### 弹窗合并

- 组件

```html
<el-dialog
  :visible.sync="dialogVisible"
  :title="dialogTitle[dialogType]"
  :close-on-click-modal="false"
  :show-close="false"
>
  <template>
    <div v-if="dialogType == 'dialog1'"></div>
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
dialogType: "",
currentEditRecord: null, // 当前弹窗关联对象
// computed
dialogVisible(){
  return !!this.dialogType
}
```

- 开启/关闭弹窗

```js
openDialog(type, editRecord) {
  this.dialogType = type;
  editRecord && (this.currentEditRecord = editRecord);
},
closeDialog() {
  this.dialogType == "dialog1" && (关闭前处理);
  ...
  this.dialogType = "";
}
```

### Table表格

#### 重复列表格

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
         <template #default="{$index}">
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

