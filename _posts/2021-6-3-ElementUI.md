---
layout:     post
title:      Element-UI
subtitle:   快速搭建后台vue库
date:       2021-6-03
author:     page
header-img: img/home-bg-geek.jpg
catalog: true
tags:
    - 类库
---

# Element-UI

## 开始

**安装：**`npm i element-ui -S`

**引入**

- Element UI（@vue）插件

- 完整引入

- 按需引入

详见[官方文档](https://element.eleme.cn/#/zh-CN)

## 布局

#### 结构布局

- \<el-container>：外层容器
- \<el-header>：顶栏容器
- \<el-aside>：侧边栏容器
- \<el-main>：主要区域容器
- \<el-footer>：底栏容器

#### 内容布局

- \<el-page-header>：页头
- \<el-card>：卡片
- \<el-table>：表格
- \<el-image>：图片
- \<el-drawer>：抽屉

#### 弹性布局

- \<el-row> + \<el-col>
  - \<el-col :span="12">（分为24份span）
  - \<el-row :gutter="20">（指定每栏左右padding）
  - \<el-col :span="6" :offset="6">（offset向后偏移）
  - \<el-row type="flex" justify="start/center/end/space-between/around">（子栏目对齐）
  - \<el-col :xs="8" :sm="6" :md="4" :lg="3" :xl="1">（响应式）
  - \<el-row :span="6" class="hidden-xs-only/...">（响应式显示隐藏类;import 'element-ui/lib/theme-chalk/display.css';）

## 组件

#### Pagination分页

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

单文件上传

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
     // 响应失败
     this.resetUpload();
     this.$message({ type: "error", message: "上传失败" });
   }
 },
 // 请求发出失败
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

分片上传

```html
<!-- 基于七牛元sdk为例 -->
<template>
  <el-upload
    class="mt-24"
    action="/"
    :on-change="handleUploadChange"
    :auto-upload="false"
    :show-file-list="false"
    drag
    multiple
  >
    <slot></slot>
  </el-upload>
</template>

<script>
  import * as qiniu from 'qiniu-js';

  export default {
    props: {
      uploadList: { type: Array, default: () => [] },
      fileTypeLimit: { type: Array, default: () => ['image/jpeg', 'image/png', 'image/gif'] },
      fileSizeLimit: { type: Number, default: 20 }
    },

    methods: {
      // 1. 添加上传
      handleUploadChange(file) {
        if (!this.fileTypeLimit.includes(file.raw.type)) return;
        if (file.size / 1024 / 1024 > this.fileSizeLimit) {
          this.$message.warn(`图片大小不正确，请重新上传小于${this.fileSizeLimit}M的图片！`);
          return;
        }
        this.uploadList.push(file);
        this.createPreviewURL(file);
        this.uploadFile(file);
      },

      // 2. 创建任务
      async uploadFile(file) {
        const arr = file.name.split('.');
        const ext = arr.pop();
        const name = `${arr.join('.')}_${new Date().getTime()}.${ext}`;
        const {
          data: { key, token }
        } = await this.$http.getQiNiuToken({ fileName: name });
        file.key = key;
        file.token = token;
        file.observable = qiniu.upload(file.raw, key, token);
        this.handleStartUpload(file);
      },

      // 开始上传
      handleStartUpload(file) {
        const next = (res) => {
          file.uploadInfo = res.uploadInfo;
          file.percentage < res.total.percent && (file.percentage = res.total.percent);
        };
        const error = () => {
          file.status = 'fail';
        };
        const complete = () => {
          file.status = 'success';
        };
        file.status = 'uploading';
        file.subscription = file.observable.subscribe(next, error, complete);
      },

      // 暂停上传
      handleStopUpload(file) {
        file.subscription.unsubscribe();
        file.status = 'stop';
      },

      // 取消上传
      handleCancelUpload(file) {
        const list = this.uploadList.filter((item) => item !== file);
        this.$emit('update:uploadList', list);
        file.subscription.unsubscribe();
        file.uploadInfo && qiniu.deleteUploadedChunks(file.token, file.key, file.uploadInfo);
      },

      // 重新上传
      async handleReUpload(file) {
        file.status = 'ready';
        file.percentage = 0;
        const { token, key, uploadInfo } = file;
        file.uploadInfo && qiniu.deleteUploadedChunks(token, key, uploadInfo);
        this.uploadFile(file);
      },

      // 清空上传
      clearUploadFiles() {
        this.uploadList.forEach((file) => file.status === 'uploading' && this.handleCancelUpload(file));
        this.$emit('update:uploadList', []);
      },

      // 临时预览图片
      createPreviewURL(file) {
        const fileReader = new FileReader();
        fileReader.onload = () => {
          fileReader.result && (file.previewURL = fileReader.result);
        };
        fileReader.readAsDataURL(file.raw);
      }
    }
  };
</script>
```

## Dialog弹窗

```html
// template
<Dialog1 :dialog.sync="dialogName" />
<Dialog2 :dialog.sync="dialogName"/>
<Dialog3 :dialog.sync="dialogName"/>

// 开启弹窗
this.dialogName = 'dialog1';
```

```html
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

**注：**```destroy-on-close```属性即关闭弹窗后刷新组件，仅当弹窗状态由唯一内容子组件时具备重置弹窗状态功能；否则请为内容容器添加`v-if`解决状态残留；

#### 合并弹窗

对管理后台(admin)的表格数据行进行增删改查操作，可以合并操作弹窗

- 组件

```html
<el-dialog
  :visible.sync="dialogVisible"
  :title="dialogTitle[dialogType]"
  :close-on-click-modal="false"
  :show-close="false"
  @close="closeDialog"
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

#### 弹窗嵌套

将内层`dialog`的`append-to-body`值设为 true 解决`modal`覆盖问题

#### 弹窗状态

弹窗来自外部状态，则弹窗开启时clone外部状态作为临时状态，弹窗编辑修改临时状态，修改成功则同步至外部状态；

弹窗需要单独接口返回状态下，弹窗创建请求接口得到弹窗状态；弹窗开启时clone弹窗状态作为临时状态，弹窗编辑修改临时状态，修改成功则同步为弹窗状态；

### Popover弹出框

**控制定位**

```html
<el-popover width="200" popper-options="poperOptions">
  <el-button slot="reference">UI控件</el-button>
</el-popover>
<script>
  const poperOptions = { modifiers: [ { name:'offset', options: { offset: [0,2] } } ] }
</script>
```

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

注：仅单独对一列设置可能导致列偏移，建议每列设置

#### 单选行

单选行：```el-table-column```内容为Radio单选框组件实现

#### 多选行

```vue
<el-table row-key="info.id" @selection-change="onSelectionChange">
    // reserve-selection 数据更新不销毁选中状态
    <el-table-column type="selection" reserve-selection />
</el-table>
```

```js
// selection-change 返回选中的行数据集合
onSelectionChange(list){
    console.log(list);
};
// toggleRowSelection 手动选中/取消选中某行,row必须为行对象
this.toggleRowSelection(row, true);
```

#### 默认部分选中的多选行

```toggleRowSelection```的默认选中要求参数```row```，不适用于分页数据的默认多选；

```el-table-column```内容为Checkoutbox多选框组件实现

#### 重复列

| 姓名  | 分数  | 姓名  | 分数  | 姓名  | 分数  |
|:---:|:---:|:---:|:---:|:---:|:---:|
| xxx | **  | xxx | **  | xx  | **  |
| xxx | **  | xxx | **  | xx  | **  |

1. 假设tableList为表格数据，基于tableList.length计算出最终显示行数，行数由数组lineLength决定
   
   ```js
   // 非空时计算行数，空数组则默认按空数据显示表格
   if (this.tableList.length > 0) {
     let num = Math.ceil(this.tableList.length / 3); // 3列复用
     this.lineLength = new Array(num).fill("");
   }
   ```

2. $index行索引 + index数据索引计算出位置对应显示数据
   
   ```vue
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

#### 检验实现

一般通过```el-form:model + el-form-item:prop:rules/required```实现检验，且prop支持```:prop="属性.index.属性"```属性路径式访问

`$form.validate(callback)`传入参数为回调函数，回调函数Function(boolean, object)返回校验结果：是否校验通过，未通过检验项信息；若未传入回调函数，则校验结果以validate返回的promise结果中获取；

**依次校验多个表单**

```js
// 手动校验所有配置
async validMultiForm() {
  let isValid = false;
  isValid = await this.$refs.applyForm.validate().catch(() => {
    this.$message.error("applyForm错误");
    this.activeSetting = "applySetting";
    return false;
  });
  if (!isValid) return;
  isValid = await this.$refs.pageForm.validate().catch(() => {
    this.$message.error("pageForm错误");
    this.activeSetting = "pageSetting";
    return false;
  });
  return isValid;
},
```

自定义校验报错时，可借助form-item:error控制错误信息：```:required/rules前置检验 + :error="errorMsg"控制错误信息 + 校验后nextTick设置error错误信息``` 附：form-item:foucs/每次检验前需重置error变量

**注：** 表单对象的状态(`el-form:model`)为数组情况，可以`:model="{formData}"`，此时prop路径增加前缀`prop="formData.index.attr"`

#### 仅提交时校验

默认elementUI在blur/change时必会触发校验，我们可以添加判断，过滤部分原有的触发校验限制做到仅提交时校验；

```js
// 标记是否为提交触发
let isSubmitTrigger = false;
// 校验规则
const rules = {
  username: { pattern: /^[A-Za-z0-9]+$/, min: 6, message: '账号由字母与数字组成' },
  password: {
    validator,
    required: true,
    validate: validateEmpty,
    message: '请输入密码'
  },
};

// Login Handle
this.logging = true;
isSubmitTrigger = true;
this.$refs.form.validate().then(() => { ... });
isSubmitTrigger = false;

// validator统一处理
function validator(rule, value, callback) {
  if (!isSubmitTrigger) return; // 仅提交表单时验证
  // 空值校验
  if (rule.required && value === '') return callback(new Error(' '));
  // 对表单项自身进行validate校验
  if (rule.validate) {
    try {
      rule.validate(value);
    } catch (error) {
      return callback(new Error(rule.message));
    }
  }
  // 提交时的多字段联合校验，如校验两次密码是否输入一致
  ...multiple field validate logic
  callback();
}
```

## Radio/Checkbox单选/多选

**自定义内容**

```vue
<el-radio-group v-model="form" @change="onChange">
  <el-radio :label="0">000</el-radio>
  <el-radio :label="1">111</el-radio>
</el-radio-group>
.el-checkbox:flex + order自定义选框与内容顺序
```

**全选/半选计算实现**

```html
<div class="t-light">
  <el-checkbox :value="selectAll" :indeterminate="isIndeterminate" @change="handleSelectAll">全选</el-checkbox>
  已选中 <span class="t-theme">{{ selectList.length }}</span>条
</div>
```

```js
computed: {
  isIndeterminate(){
    const count = this.selectList.length;
    const total = this.itemsList.length;
    return count && count < total;
  },
  selectAll(){
    const count = this.selectList.length;
    const total = this.itemsList.length;
    return count === total;
  }
},
methods: {
  // 全选/取消全选
  handleSelectAll() {
    if(this.selectAll){
      this.selectIdList = [];
    } else {
      this.selectIdList = [...this.itemsList];
    }
  }
}
```

## Message消息

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

## Loading加载

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

## Menu侧边栏

```vue
<template>
  <div id="sidebar" class="fulled-h">
    <el-scrollbar>
      <el-menu
        :router="true"    // 路由模式
        :default-active="activeRoute"    // 默认激活路径
        :default-openeds="defaultOpeneds"    // 默认展开选项
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

## Breadcrumb面包屑

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

## Collapse折叠

默认空格键能控制弹起或收起，绑定 keyup.stop 可阻止

## InfiniteScroll无限滚动

```vue
<div
  v-infinite-scroll="scrollMore"
  infinite-scroll-distance="40"
  :infinite-scroll-disabled="loading || isEnd"
  infinite-scroll-immediate="false"
  :style="{ height: '500px', overflowY: auto}"
>
    ...list-item
</div>
```

`infinite-scroll-immediate`控制是否立即加载，默认会自动加载；仅值为'false'(此处非布尔值)禁用默认加载；
