---
layout:     post
title:      Vue Router基础
subtitle:   Vue.js 官方的路由管理器。它和 Vue.js 的核心深度集成，让构建单页面应用变得易如反掌
date:       2020-9-8
author:     page
header-img: img/post-bg-swift2.jpg
catalog: true
tags:
    - vue router
---

# [vue Router](https://router.vuejs.org/zh/)

## 前端路由
为SPA的每个视图(网页组件)匹配特殊的url，形成映射关系；通过监听url来分发进行刷新、前进、后退、切换映射的页面；

这要求路由必须做到以下两点：  

　　1. 改变url且不让浏览器像服务器发送请求。  
　　2. 可以监听到url的变化
解决方案包括hash模式和history模式

### vue Router安装与配置
#### 安装
- npm
```sh
npm install vue-router --save
```

- vue CLI添加为预设
```sh
(*) vue Router
```

#### 配置与使用
- 配置(router/index.js)
    + 1.引入vue-router模块,```Vue.use(VueRouter)```安装插件
    + 2.传入路由映射配置,创建并输出router实例
    + 3.挂载创建的路由实例

- 使用
    + 1.在components目录创建.vue路由组件文件
    + 2.router/index.js配置路由组件的路径
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
         path: "*",			// 通配符路由
         meta: { title: 404 },
         component: () => import("@/views/404.vue")
        }
      ]
    })
    ```
    + 3.App.vue添加```<router-link>```和```<router-view>```使用路由
    ```html
    <div id="app">
        <h4>index.html引入App.vue模块的内容</h4>
        <router-link to="/home">主页</router-link>
        <router-link :to="{path: '/about'}">关于</router-link>
        <router-view/>
    </div>
    ```
    
- redirect重定向

    ```js
    routes: [
      {//默认路由路径时重定向至'/home'路径下路由组件
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

- 阻止路由跳转自身时报错

  ```js
  const originalPush = VueRouter.prototype.push
     VueRouter.prototype.push = function push(location) {
     return originalPush.call(this, location).catch(err => err)
  }
  ```

- 路径模式：history/hash

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



### router-link

```vue
<router-link to="/about" tag="button" replace active-class="active"></router-link>
```

- to: 指向路由路径及对应组件
- tag: 渲染< router-link>为指定元素，默认为a标签
- replace: 是否启用replaceState方法修改路由,此方法不允许通过history记录回退/前进
- router-link-active: 指定当< router-link>聚焦状态下,该< router-link>的辅助类名; 
也可在'router/index.js'下配置路由对象Router的属性linkActiveClass为"active"



### router-view

- key: router-view中不同路由之间在同一组件下跳转，默认路由不更新，需绑定:key="$route.path"声明path为更新键



### 路由跳转

```js
methods: {
    toHome(){
        this.$router.push("/home");
    },
    reAbout(){
        this.$router.replace("/about");
    }
}
```



### 路由回退

```
this.$router.back()
```



### 动态匹配路由

Router允许1个页面组件映射多个路径,这种可变的路由即动态匹配路由

1. 配置动态匹配路由映射

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

2. 使用动态匹配路由

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

- 附：this.$route.params获取当前路由的动态参数

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



### 路由懒加载

路由懒加载，即目标路由被激活后才请求对应的路由页面相关业务代码，从而提高页面性能；
这要求我们对打包文件'/dist/js/app.序列号.js'业务代码进行分包，即分离出各个路由对应的页面代资源；

- 配置router/index.js
```js
//ES6的异步组件和webpack代码分割写法
const Home = () => import('../components/Home.vue')
const About = () => import('../components/About.vue')
const User = () => import('../components/User.vue')

//AMD写法
const About = resolve => require(['../components/User.vue'],resolve)
```



### 路由嵌套

父级路由下嵌套子路由，父级页面组件下嵌套子页面组件
```tex
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



### 路由通信

切换/激活路由组件时，传递部分数据至router组件

- $router.params动态路由参数
    1. 添加动态路由： path: '/profile/:userId'
    2. 绑定动态路由参数： :to="'/profile/' + id"
    3. 路由组件使用动态参数： this.$route.params.userId
    4. 适用于通过动态路径传递1个参数串，数据量小，字符格式限制

- $router.query查询参数
    1. 绑定路由激活传递的参数：
        - :to="{path: '/profile',query: {name: 'page',userId: 12138}}"
        - this.$routes.push({path: '/profile',query: {name: 'page',userId: '12138'}})
    2. 激活指定路由时，url为"http://localhost:8080/profile?name=page&userId=12138"
    2. 路由组件使用查询参数： this.$route.query.userId/name



### Router导航守卫

“导航”表示路由正在发生改变。有多种机会植入路由导航过程中：全局的, 单个路由独享的, 或者组件级的

- 全局前置导航
```
const router = new VueRouter({ ... });
router.beforeEach((to,form,next) => {
  //该回调函数重写了默认next处理,添加额外处理前须执行默认next处理
  next();
  ...导航解析时的处理，即路由改变中的处理
});
```

- 其他钩子(回调函数)
    + afterEach 全局后置钩子
    + beforeEnter 路由独享守卫
    + beforeRouteEnter 组件内守卫
- 附：新的路由记录属性
meta: Object类型值，用于给当前路由记录状态添加元数据
matched: Array类型值，包含当前路由的所有嵌套路径片段的路由记录，可访问父级路



### keep-alive缓存

vue默认包含一个可直接使用的keep-alive内置组件,用于对内部组件进行缓存,并为缓存的组件提供了activated和deactivated方法

- 基本使用

1. 缓存APP的组件
   
    ```html
    <keep-alive><router-view/></keep-alive>
    ```
    
2. 组件内调用activated监听缓存组件激活
   
    ```js
    activated(){
    	this.$router.push(this.path);
    }
    ```
    
3. 后置导航钩子记录home子路径
   
    ```js
    beforeRouteLeave(to,from,next){
      this.path = from.path;
      next();
   }

- include和exclude

  指定缓存组件name值/指定不缓存组件,属性值为指定组件的name值
  
  ```vue
  <keep-alive exclude="Profile"><router-view/></keep-alive>
  ```

- 控制滚动行为
  1. 保留路由滚动的位置，必须对该路由组件keep-alive
  2. 创建router实例时，添加滚动控制
  
  ```js
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {  // 如果路由被keep-alive，则切换为原来位置
      return savedPosition
    } else {
      return x: 0, y: 0   // 所有未缓存的路由切换直接置顶
    }
  }
  ```
  
  

## 动态路由(鉴权)

```js
// router.config.js
// export baseRouters(基础路由) adminRouters(权限路由) errorRouters(404兜底路由)
```

````js
// index.js
// 初始状态仅初始化基础路由
````

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













































