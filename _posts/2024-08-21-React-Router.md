---
layout:     post
title:      react-router
subtitle:   react路由管理库
date:       2024-8-21
author:     page
header-img: img/react.jpg
catalog: true
tags:
    - React
---

[React Router官方文档](https://reactrouter.com/en/main)   [中文文档](http://www.reactrouter.cn/)

**核心库**：路由管理的核心库，提供了路由的基本功能和 API。

**平台无关**：可以在任何 React 环境中使用，包括 web、native、electron 等。

### react-router-dom

**Web 专用**：基于 `react-router` 提供的核心功能，添加了与 DOM 相关的功能和组件。

**附加组件**：提供了 `BrowserRouter`、`HashRouter`、`Link`、`NavLink` 等专用于 web 应用的组件。

```shell
npm i react-router-dom -S
```

### Router

使所有其他组件和挂钩工作的有状态的顶级组件

#### Routers

`createBrowserRouter`、`createHashRouter` ...

#### RouterProvider

上面的data router对象都将传递给该组件，以渲染应用程序并启用其他数据 API。

```jsx
import { createBrowserRouter, RouterProvider } from "react-router-dom";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    children: [
      {
        path: "dashboard",
        element: <Dashboard />,
      },
      {
        path: "about",
        element: <About />,
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById("root")).render(
  <RouterProvider
    router={router}
    fallbackElement={<BigSpinner />}
  />
);
```

#### Router Components

`BroswerRouter`、`HashRouter`、`NativeRouter`、`Router` ...

### Route

一个对象或路由元素，具有 path, element 或 `<Route path element>`；

将 URL 段与组件、数据加载联系在一起。 通过路由嵌套，复杂的应用程序布局和数据依赖关系变得简单明了。

**lazy**

每个路由都可以提供一个异步函数，用于解析路由定义中与路由匹配无关的部分（加载器、操作、组件/元素、ErrorBoundary/errorElement 等）；实现路由配置的延迟加载（除路径、索引、子路由）；

懒路由会在初始加载以及导航或 fetcher 调用的加载或提交阶段进行解析；

### 基础使用

`react-router` 使用分别实现 router + route 即可；常见实现：

**Router Component + Routes Component + Route Component**

```jsx
// main.jsx
root.render(
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>
);

// App.jsx
import { NavLink, Routes, Route } from "react-router-dom";

export default function App() {
  return (
    <div className="App">
      <nav>
        <NavLink to="">首页</NavLink>
        <NavLink to="product">产品</NavLink>
        <NavLink to="about">关于</NavLink>
      </nav>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/product" element={<Product />} />
        <Route path="/about" element={<About />} />
        <Route path="*" element={<Error />} />
      </Routes>
    </div>
  );
}
```

**Router Component + Routes**

```jsx
// @/routers/index.tsx
const Router = () => {
    const routes = useRoutes(rootRouter);
    return routes;
};
export default Router;

// App.tsx
import { HashRouter } from "react-router-dom";
import Router from "@/routers/index";

function App() {
  return (
    <HashRouter>
      <Router />
    </HashRouter>
);
```

**createXxxRouter+ RouterProvider**

```jsx
// @/rotuer/index.tsx
export default function Router() {
  const routes = [LoginRoute, asyncRoutes, ErrorRoutes, PAGE_NOT_FOUND_ROUTE];
  const router = createHashRouter(routes as unknown as RouteObject[]);
  return <RouterProvider router={router} />;
}

// App.tsx
import Router from '@/router/index';
function App() {
  return <Router />;
}
```

### Components

#### Link/NavLink

```jsx
import { Link } from 'react-router-dom';

<Link to="/article" end>文章页面</Link>
```

`NavLink` 是存在 `active` 状态的 `Link`，可以为`active` 和非 `active` 状态的导航添加样式：

```jsx
<NavLink className={({ isActive }) => isActive ? "red" : "blue"} />
```

#### Navigate

在呈现时会更改当前位置。 是 useNavigate 的组件包装器，接受的参数相同。

### Hooks

`useNavigate`、`useLocation`

**useRoutes**

等同于 `<Routes>`，但它使用 JavaScript 对象而不是 `<Route>` 元素来定义路由。 这些对象具有与普通 `<Route>` 元素相同的属性，但不需要 JSX。

```ts
export const rootRouter: RouteObject[] = [
    {
        path: "/",
        element: <Navigate to="/login" />
    },
    ......
];

const Router = () => {
    const routes = useRoutes(rootRouter);
    return routes;
};

export default Router;
```

### 传递状态

#### 传递state

```jsx
<Link to="new-path" state={{ some: "value" }} />
navigate('/', { state: "From the About Page"})

let { state } = useLocation();
```

#### 传递动态路由params

```jsx
const router = createBrowserRouter([
  {
    path: '/invoices/:recordId/:likeId',
    element: <Invoice/>
  }
]);

<Link
  to={`/invoices/${invoice.recordId}/${likeId}`}
  key={invoice.recordId}
>
  {invoice.name}
</Link>
navigate('/invoices/12345/abcde');


import { useParams } from "react-router-dom";

export default function Invoice() {
  let params = useParams();
  return <h2>Invoice: {params.recordId}</h2>;
}
```

#### 传递search参数

```jsx
<Link
  to={{
    pathname: "/settings",
    search: "?sort=date",
    hash: "#hash"
  }}
>
  设置
</Link>


let [searchParams, setSearchParams] = useSearchParams();
searchParams.get("filter") || "";
setSearchParams({ ... })
```

### 嵌套路由

**Outlet**

```jsx
import { Link, Outlet, useNavigate } from 'react-router-dom';
const Layout = () => {
  const navigate = useNavigate();
  return (
    <div>
      <Link to="/layout/board">面板</Link>
      <button onClick={() => navigate('/layout/about')}>关于</button>
      {/* 二级路由出口Outlet */}
      <Outlet />
    </div>
  );
};
export default Layout;
```

**默认二级路由**

使用 `index` 属性取代二级路由 `path`，即索引路由

```jsx
const router = createBrowserRouter([
    {
        path: '/layout',
        element: <Layout />,
        children: [
            {
                // 设置默认二级路由，一级路由/layout访问时也将渲染
                index: true,
                element: <Home />
            },
            {
                path: 'board',
                element: <Board />
            }
        ]
    }
]);
```
