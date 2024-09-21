---
layout:     post
title:      VueMasonry
subtitle:   Vue 指令形式的瀑布流布局实现
date:       2024-07-05
author:     page
header-img: img/vuejs.webp
catalog: true
tags:
    - vue
---

# VueMasonry

[vue-masonry: 💠 Vue.js directive for masonry blocks layouting ✅](https://github.com/shershen08/vue-masonry)

## Install

```shell
npm install vue-masonry --save 
```

## Usage

**全局注册指令**

```js
import { createApp } from 'vue'
import mitt from 'mitt'
import { VueMasonryPlugin } from "vue-masonry";

const emitter = mitt()
let app = createApp(App)
app.config.globalProperties.emitter = emitter
app.use(VueMasonryPlugin)
app.mount('#app')
```

**列表**

```html
<div
  class="assets-list"
  v-masonry="masonryId"
  column-width="90"
  item-selector=".box"
  :gutter="20"
  transition-duration="0"
>
  <div
    v-for="item in assetsList"
    :key="item.id"
    class="box"
  ></div>
</div>
```

```js
const masonryId = generateID();
const redrawVueMasonry = inject('redrawVueMasonry');
// 列表数据变动后，重新计算布局
watch(articleList, () => {
  nextTick(() => redrawVueMasonry(masonryId));
});
```

### Properties

`v-masonry`：列表布局唯一id标识

`gutter`：列间距

`column-width`：列宽，当列表项宽度不一时，可设为最小宽度列表项值

`item-selector`：列表项选择器

`transition-duration`：自适应宽度调整布局动画时长（毫秒或"FloatS"）
