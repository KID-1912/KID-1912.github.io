---
layout:     post
title:      Vue3 with Typescript
subtitle:   为 vue 项目使用 TypeScript 能力
date:       2024-09-27
author:     page
header-img: img/post-bg-tree.jpg
catalog: true
tags:
    - vue

---

# Vue3 Typescript

[vite-ts-template](https://github.com/KID-1912/vite-ts-template)

## 定义组件

没有结合 `<script setup>` 使用组合式 API 时，通过 `defineComponent` 定义组件，以便TypeScript 正确地推导出组件选项内的类型

```ts
export default defineComponent({
  // 启用了类型推导
  props: {
    name: String,
    msg: { type: String, required: true }
  },
  data() {
    return {
      count: 1 // 自动类型推导
    }
   }，
   setup(props) {
    props.message // 类型：string | undefined
   }
}
```

**单文件组件**中支持TS：`<script lang="ts">` `<script lang="ts" setup>`

**模板**中TS使用：`{{ (x as number).toFixed(2) }}`

## 组合式API

### props

**运行时声明**

```ts
const props = defineProps({
  name: { type: String, default: "" }, 
});
```

`PropType` 工具类型实现复杂类型：

```ts
import type { PropType } from 'vue'

const props = defineProps({
  activity: Object as PropType<Activity>
});
```

**基于类型声明**

```ts
interface Props = {
  url: string,
  name: string,
  count?: number
}
const props = defineProps<Props>();

interface Activity {
  id: string;
  url: string;
  count?: number;
}
const props = defineProps<{
  activity: Activity
}>()
```

通过解构实现prop默认值：

```ts
const { url, name, count = 0 } = defineProps<Props>();
```

### emits

**运行时声明**

```ts
const emit = defineEmits(['update:modelValue'])
```

**基于类型声明**

```ts
const emit = defineEmits<{
  (e: 'change', id: number): void;  // e即时间名称 id只起到描述第1个参数作用
  (e: 'update', id: string, count: number): void;  // 声明多参数类型
}>() 
// 推荐简洁
const emit = defineEmits<{
  change: [id: number]
  update: [value: string]
}>()
```

### ref

`Ref<>`

```ts
const year = ref(2020);  // 类型推导
const year = ref<string | number>('2020')  // 支持复杂类型
const n = ref<number>()  // 推导得到的类型：Ref<number | undefined>
```

### reactive

```ts
// 推导得到的类型：{ title: string }
const book = reactive({ title: 'Vue 3 指引' })

interface Book {
  title: string
  year?: number
}
const book: Book = reactive({ title: 'Vue 3 指引' })
```

### computed

`ComputedRef<>`

```ts
const double = computed(() => count.value * 2); 
const selectedBook = computed<Book>(() => {});
```

### 事件处理

```ts
const handleChange = (event: Event) => {
  console.log((event.target as HTMLInputElement).value)
}
```

### provide/inject

provide直接提供即可

```ts
const title = ref<string>('标题');
provide('title', title);

const model = ref<Modal>({ /* some data */ });
provide('model', model);

const claculate = (v: string): string => { /* some method */ };
provide('claculate', claculate);

const list = ref<Book[]>([]);
provide('getList', () => list);
```

**inject**

```ts
const title = inject('title');  // 类型推导为 unknown
const title = inject<string>('title'); // 类型推导为 string | undefined
const title = inject<string>('title', 'defaultTitle'); // 类型推导为 string

const claculate = inject<(v: string) => string>('claculate');

const getList = inject<() => Ref<Book[]>>('getList'); 
const list = computed(getList);
```

**InjectionKey**

用于**类型安全**的依赖注入（`provide` 和 `inject`）的辅助类型，确保依赖注入唯一性

```ts
// 名为 mode 的 provide key
const modeKey: InjectionKey<Ref<string>> = Symbol('mode');
const mode = ref<string>("edit");   // mode值
provide(modalKey, modal);

import { modeKey } from "xxx";
const mode = inject(modeKey);
```

## 模板引用

使用 `useTemplateRef` 创建的引用类型：

```ts
const el = useTemplateRef<HTMLInputElement>(null)
```

**组件模板引用**

```ts
<script setup lang="ts">
import { useTemplateRef } from 'vue'
import Foo from './Foo.vue'
import Bar from './Bar.vue'

// 提取类型
type FooType = InstanceType<typeof Foo>
type BarType = InstanceType<typeof Bar>

const compRef = useTemplateRef<FooType | BarType>('comp')
// compReft 包含特定方法或属性的检查
</script>

<template>
  <component :is="Math.random() > 0.5 ? Foo : Bar" ref="comp" />
</template>
```

如果不需要内部方法属性的检查，简单标注 `ComponentPublicInstance`：

```ts
import { useTemplateRef } from 'vue'
import type { ComponentPublicInstance } from 'vue'

const child = useTemplateRef<ComponentPublicInstance | null>(null)
```

## 工具类型

[TypeScript 工具类型 | Vue.js](https://cn.vuejs.org/api/utility-types.html#maybereforgetter)
