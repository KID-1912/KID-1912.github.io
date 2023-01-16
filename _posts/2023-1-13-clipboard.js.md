---
layout:     post
title:      clipboard.js
subtitle:   文本复制到剪贴板的现代方法,轻便简洁，无任何依赖
date:       2023-01-13
author:     page
header-img: img/home-bg.jpg
catalog: true
tags:
    - 类库
---

# clipboard

[官方文档](https://clipboardjs.com/) [github](https://github.com/zenorocha/clipboard.js)

## 安装

```shell
npm install clipboard --save
```

## 使用

**从属性复制**

`data-clipboard-text`：复制内容

```html
<div>
  <div class="btn" data-clipboard-text="一段复制内容">点击复制</div>
</div>
<script>
  new Clipboard('.btn');  // 事件代理
</script>
```

**从其它元素复制**

`data-clipboard-target`：复制源

`data-clipboard-action`：复制/剪切

```html
<div>
  <input id="content_input" value="请输入内容"/>
  <div
    class="btn"
    data-clipboard-target="#content_input"
    data-clipboard-action="cut"
>点击复制输入框内容</div>
</div>
<script>
  new Clipboard('.btn');
</script>
```

## 事件

### 复制成功/失败

```js
const clipboard = new Clipboard('.btn');
clipboard.on('success', function(e) {
    console.info('Action:', e.action);
    console.info('Text:', e.text);
    console.info('Trigger:', e.trigger);
    e.clearSelection();  // 清除默认选中复制内容
});
clipboard.on('error', function(e) {
    console.error('Action:', e.action);
    console.error('Trigger:', e.trigger);
    alert('浏览器不支持按钮复制，请手动ctrl+c');
});
```

## 高级选项

列表项的复制常需要一些高级选项配合

**动态源**

```js
new Clipboard('.btn', {
    target: function(trigger) {
        return trigger.nextElementSibling;
    }
});
```

**动态内容**

```js
new Clipboard(".tag-copy", {
  text(trigger) {
    const str = "复制内容：CONTENT";
    return str.replace(
      /CONTENT/g,
      trigger.previousElementSibling.innerText
    );
  }
});
```

**销毁**

```js
clipboard.destroy();
```

## Vue3使用

```html
<script setup>
  import { ref } from 'vue'
  import { useClipboard, usePermission } from '@vueuse/core'
  const { text, isSupported, copy } = useClipboard();

  const message= ref('');
</script>

<template>
  <input v-model="message" type="text">
  <div>当前复制内容：{{ text }}</div>
  <button @click="copy(message)">复制</button>
</template>
```
