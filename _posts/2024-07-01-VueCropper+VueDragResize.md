---
layout:     post
title:      VueCropper + VueDragSize
subtitle:   一个优雅的图片裁剪插件；一个用于可拖动和可调整大小元素的 Vue 组件。
date:       2024-07-05
author:     page
header-img: img/cropper.png
catalog: true
tags:
    - vue
---

# VueCropper + VueDragResize

## vue-cropper

一个优雅的图片裁剪插件；

 [vue-cropper: A simple picture clipping plugin for vue](https://github.com/xyxiao001/vue-cropper)

### Install

```shell
npm install vue-cropper@next";
```

### Usage

```js
import 'vue-cropper/dist/index.css'
import { VueCropper }  from "vue-cropper
```

```html
<vueCropper
  ref="cropper"
  :img="option.img"
  :outputSize="option.size"
  :outputType="option.outputType"
></vueCropper>
```

<img title="" src="https://raw.githubusercontent.com/KID-1912/Github-PicGo-Images/master/2024/07/05/20240705103636.png" alt="" width="508" data-align="center">

引入组件，传入图片链接即可快速实现裁剪器；

提供了获取裁剪图的base64/blob对象方法，无需额外编写裁剪操作逻辑；

## vue-drag-resize

一个用于可拖动和可调整大小元素的 Vue 组件；

 [vue-drag-resize: Vue Component for draggable and resizable elements.](https://github.com/kirillmurashov/vue-drag-resize)

<img title="" src="file:///C:/Users/黑羽同学/AppData/Roaming/marktext/images/2024-07-05-11-07-49-image.png" alt="" width="390" data-align="center">

### Install

```shell
npm i -s vue-drag-resize@next
```

### Usage

```html
<VueDragResize
  class="cropper"
  ref="cropperRef"
  :w="cropper.width"
  :h="cropper.height"
  :x="cropper.left"
  :y="cropper.top"
  :z="cropper.zIndex"
  :key="cropper.id"
  :aspectRatio="cropper.aspectRatio"
  :sticks="cropperSticks"
  :minw="50"
  :minh="50"
  :parentLimitation="true"
  :isActive="true"
  :isResizable="true"
  :preventActiveBehavior="true"
  @resizestop="handleCopperChange"
  @dragstop="handleCopperChange"
>
</VueDragResize>
```

```js
const cropper = ref({ id: 0 });
const cropperRef = ref();
cropper.value = {
  id: generatedId(),
  aspectRatio,
  width,
  height
  left
  top,
  zIndex: 999,
};
const cropperSticks = computed(() => {
  if (cropper.value.aspectRatio) {
    return ['tl', 'tr', 'br', 'bl'];
  } else {
    return ['tl', 'tm', 'tr', 'mr', 'br', 'bm', 'bl', 'ml'];
  }
});
const handleCopperChange = (size) => {
  const { width, height, left, top } = size; // 需确保大小位置在父元素内
  cropper.value.width = width;
  cropper.value.height = height;
  cropper.value.left = left;
  cropper.value.top = top;
  cropper.value.id = generatedId(); // 生成新组件Id
};
```

**注**：vue3版本下存在绑定的cropper手动设置更新无效问题，统一通过设置状态时更新key的 `handleCopperChange` 方法同步cropper
