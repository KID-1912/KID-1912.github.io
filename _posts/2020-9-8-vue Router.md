---
layout:     post
title:      Vue Router基础
subtitle:   Vue.js 官方的路由管理器。它和 Vue.js 的核心深度集成，让构建单页面应用变得易如反掌
date:       2020-9-8
author:     page
header-img: img/post-bg-swift2.jpg
catalog: true
tags:
    - vue
---

# vue Router

**前端路由**

对SPA的每个视图(网页组件)匹配特殊的url，形成映射关系；

通过监听url来分发进行刷新、前进、后退、切换映射的页面；

这要求路由具备：监听到url的变化，可改变url且不让浏览器像服务器发送请求；
解决方案包括hash模式和history模式

## 安装与配置

### 安装

**npm** `npm install vue-router --save`

**vue CLI** 选择预设添加 `(*) vue Router`

### 配置

1. 编写路由映射配置(router/index.js)，创建router实例

2. `app.js` 引入vue-router插件，`Vue.use(VueRouter)` 安装插件

3. `new Vue()` 实例，传入router实例配置作为参数

### 使用

1. 在components目录创建.vue路由组件文件

2. router/index.js配置路由组件的路径
   
   ```js
   import Home from '../components/home.vue'   //引入创建的路由组件
   export default new Router({
     routes: [
     //配置路由组件与路径的映射,每个映射关系对应1个对象
       {
         path: '/home',    // 匹配url的路径
         name: 'home',     // 绑定路由组件时的引用名称
         component: Home   // 对应的路由组件对象
       },
       {
         path: '/about',
         name: 'about', 
         component: About
       },
       {
        path: "*",            // 通配符路由
        meta: { title: 404 },
        component: () => import("@/views/404.vue")
       }
     ]
   })
   ```

3. App.vue添加 `<router-link>` 和 `<router-view>` 使用路由
   
   ```html
   <div id="app">
       <h4>index.html引入App.vue模块的内容</h4>
       <router-link to="/home">主页</router-link>
       <router-link :to="{path: '/about'}">关于</router-link>
       <router-view/>
   </div>
   ```

## redirect(重定向)

```js
routes: [
  { //默认路由路径时重定向至'/home'路径下路由组件
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    name: 'home',
    component: Home
  },
  ...
]
```

路由跳转自身时/被强制重定向报错

控制台输出 `Error: Redirected when going from "/login" to "/home" via a navigation guard.`

**解决：**

调用路由跳转报错代码添加 `catch` 捕获错误

重写push方法忽略报错，这可能会屏蔽所有相关报错不利于debug

```js
const originalPush = VueRouter.prototype.push;
VueRouter.prototype.push = function push(location) {
   return originalPush.call(this, location).catch(err => err)
}
```

## 路径模式(history/hash)

默认的路由路径修改模式是基于URL的Hash模式,路径在会出现'#/'的部分,可以通过配置修改为通过pushState的history的模式

```js
new Route({
    routes: [
        {...},
        {...}
    ],
    mode: 'history'
})
```

## router-link

```vue
<router-link to="/about" tag="button" active-class="active" replace></router-link>
```

- `to`：指向路由路径及对应组件
- `tag`：渲染< router-link>为指定元素，默认为a标签
- `replace`：是否启用replace
- `router-link-active`：指定< router-link>激活状态下添加辅助类，等同在 `router/index.js` 下配置路由对象Router的属性 `linkActiveClass`

## router-view

多路由映射同一组件，此时路由切换后不会更新组件状态；

添加声明 `:key="$route.path"` ，使path值作为 key 标识

## 跳转方法

```js
methods: {
    toHome(){
        this.$router.push("/home");
    },
    toAbout(){
        this.$router.replace("/about");
    },
    back(){
        this.$router.back();
    }
}
```

## 路由嵌套

父级路由下嵌套子路由，父级页面组件下嵌套子页面组件

```html
-- router/index.js --
{
  path: '/home',
  name: 'home',
  component: Home,
  children: [           //嵌套子路由
    {
      path: '',
      redirect: 'message'
    },
    {
      path: 'message',
      component: HomeMessage
    },
    {
      path: 'news',
      component: HomeNews
    }
  ]
},
...
-- Home.vue父级页面组件使用子页面组件 --
<template>
  <div>
    <h4>home路由组件</h4>
    <div>主页内容。。。。。</div>
    <router-link to="/home/message">消息</router-link>
    <router-link to="/home/news">新闻</router-link>
    <router-view></router-view>
  </div>
</template>
```

## 动态路径

允许组件映射的路径是动态的

**配置动态路径映射**

```js
routes: [
  {
    path: '/home',
    name: 'home',
    component: Home
  },
  {
    path: '/user/:userId',  //:userId即路径动态可变部分
    name: 'user',
    component: User,
    props: true             //允许组件的props中接收动态参数userId
  }
]
```

**使用动态路由**

```vue
<template>
  <div id="app">
    <h4>index.html引入App.vue模块的内容</h4>
    <router-link to="/home">主页</router-link>
    <!-- 绑定userId属性的动态值为动态路由的可变部分 -->
    <router-link :to="'/user/'+userId">用户(动态路由)</router-link>
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App',
  data(){
    return {
      userId: 'page12138'
    }
  }
}
</script>
```

**动态参数 $route.params**

```vue
<template>
  <div>
    <h4>用户{{userId}}</h4>
    <div>用户界面内容......</div>
  </div>
</template>

<script>
export default {
    data(){
        return {
            userId: this.$route.params.userId
        }
    }
}
</script>
```

## 路由懒加载

目标路由被激活后才请求对应的路由页面相关业务代码，从而提高页面性能；
要求对打包文件 `/dist/js/app.序列号.js` 业务代码进行分包，分离出各个路由对应的页面代资源

配置router/index.js

```js
//ES6的异步组件和webpack代码分割写法
const Home = () => import('../components/Home.vue')
const About = () => import('../components/About.vue')
const User = () => import('../components/User.vue')

//AMD写法
const About = resolve => require(['../components/User.vue'],resolve)
```

## 路由通信

切换/激活路由组件时，传递部分数据至router组件

**查询参数$router.query**

传递参数

```
// router-link
<router-link :to="{ path: '/profile', query: { name: 'page', userId: 12138 }}"></router-link>

// router
this.$routes.push({ path: '/profile', query: { name: 'page',userId: '12138' }})
```

此时location路径为 `http://localhost:8080/profile?name=page&userId=12138`

访问参数： `this.$route.query.userId/name`

**注：** 非js手动路由跳转，即导航栏访问/页面刷新时，query参数的值全部转为字符串类型，因此使用query前必须做期望类型转换

**动态路径$route.params**

传递参数

`path: '/profile/:userId'`

`:to="'/profile/' + id"`

访问参数：`this.$route.params.userId`

适用于通过动态路径传递1个参数串，数据量小，字符格式限制

对比$router.params

1. 用法与query一致，但不会回显在页面地址，因此刷新会丢失

2. 由于避免与动态路径路由冲突，传递params要求以name跳转方式

**注：** 最新版本 `VueRouter` 已不再支持非路径方式传递params，可改用 `history` 替代

```js
// 记录到history.state
$router.push({ name: "nextPage", state: { id: "12345" } )

// 直接读取
mounted: {
  const id = window.history.state.id;
}
```

## 导航守卫

全局前置导航

```js
const router = new VueRouter({ ... });
router.beforeEach((to,form,next) => {
  //该回调函数重写了默认next处理,添加额外处理前须执行默认next处理
  next();
  ...导航解析时的处理，即路由改变中的处理
});
```

其他钩子(回调函数)

+ afterEach 全局后置钩子
+ beforeEnter 路由独享守卫
+ beforeRouteEnter 组件内守卫

**注：** 导航守卫中 `next()` 与 `next(path)`有一点区别，前者是继续完成当前跳转，后者是开启新跳转(重定向)

## keep-alive(缓存)

可直接使用的内置组件，用于对内部组件进行缓存，并为缓存的组件提供了 `activated` 和 `deactivated` 方法

**基本使用**

缓存APP的组件

```html
<keep-alive><router-view/></keep-alive>
```

activated监听组件激活

```js
activated(){
    this.$router.push(this.path);
}
```

**include和exclude**

指定缓存组件name值或指定不缓存组件，属性值为指定组件的name值

```vue
<keep-alive exclude="Profile"><router-view/></keep-alive>
```

**控制滚动行为**

保留路由滚动的位置，必须对该路由组件keep-alive

创建router实例时，添加滚动控制

```js
scrollBehavior (to, from, savedPosition) {
  if (savedPosition) {  // 如果路由被keep-alive，则切换为原来位置
    return savedPosition
  } else {
    return x: 0, y: 0   // 所有未缓存的路由切换直接置顶
  }
}
```

## route属性

**matched**：Array类型，包含当前路由的各嵌套层级路径，可访问父级路由 

## Router属性

**meta**：Object类型，用于给当前路由记录状态添加元数据

## Router操作

**添加路由**

单个添加：`router.addRoute(RouteOption:Object)`

批量添加：`router.addRoutes(RouteOptions:Array)`

**重置路由**

```js
router.matcher = new VueRouter({
 routes: baseRoutes // 路由配置
}).matcher;
```

**注：** 路由被重置后，需要发生一次有效跳转后生效，如 `next(to.path)`

## 动态路由(鉴权)

**配置**

```js
// router.config.js
// export baseRouters(基础路由) 
// adminRouters(权限路由) 
// errorRouters(404兜底路由)
```

**router实例**

```js
// index.js
// 初始状态仅初始化基础路由
```

**鉴权**

```js
// auth.js
import router from "./index";
import $store from "@/store";
import { adminRoutes, errorRoute } from "./router.config";

// 白名单
const whiteList = ["/login", "/404"];

// 权限动态路由
const addAdminRoutes = function() {
  // 用户角色标识
  let userRole = $store.getters["user/userInfo"].role;
  let rootRoutes = [];
  // 根据角色权限生成路由列表
  adminRoutes.forEach(route => {
    var routesArr = route.children.filter(secondRoute => {
      // 比较角色权限与路由要求权限
      var roles = secondRoute.meta.role;
      if (!roles || roles.includes(userRole)) return true;
      return false;
    });
    if (routesArr.length > 0) {
      route.children = routesArr;
      router.addRoute(route);
      rootRoutes.push(route);
    }
  });
  router.addRoute(errorRoute);
  // 保存用于渲染侧边栏
  $store.commit("SET_ADMIN_ROUTES", rootRoutes);
};

router.beforeEach((to, from, next) => {
  if (whiteList.includes(to.path)) return next();
  var authToken = window.localStorage.getItem("token");
  if (!authToken) return next("/login");
  if (!$store.getters["user/userInfo"]) {
    $store.dispatch("user/getUserInfo").then(() => addAdminRoutes());
  }
  return next();
});
```

```js
// main.js
// router鉴权
import "./router/auth";
```
