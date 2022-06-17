---
layout:     post
title:      supermall商城
subtitle:   一款仿蘑菇街商城的WebApp，使用vue全家桶
date:       2020-11-2
author:     page
header-img: img/post-bg-re-vs-ng2.jpg
catalog:    true
tags:
    - 项目实战
---

## supermall项目
## 新项目步骤
1. 划分文件夹
    - src
        + assets    资源文件
            * css
            * img
            * font
        + common    公共js功能函数(mixins...)
        + components    组件
            * common    组件库组件
            * content   业务组件
        + network   网络模块文件
        + router    路由
        + store     状态管理
        + views     页面视图组件

2. 引入基本css文件
    - normalize.css
    - base.css

3. 添加配置文件
    - vue.config.js 配置路径别名
    - .editorconfig 代码格式化风格

## 业务开发
#### 首页开发(home.vue)
1. tabbar
- 组件
    + mainTabBar -> TabBar -> TabBarItem

2. vue router
- 安装vue router插件创建实例
- 配置router视图组件映射
- TabBarItem接收path参数绑定路由跳转

3. navbar
- 组件结构
    + .left + .center + .right

4. 首页数据
- 网络模块
    - network/request.js 请求功能模块
    - newwork/home.js 具体请求发送
- 依赖关系
home组件created时调用 -> home.js发送请求 -> request.js请求方法

5. swipper
- 组件结构
    + .swipper -> .swipper-item -> slot轮播内容
    + swipper文件夹index.js用于整体引用swipper下多个父子组件  
- 问题
    + 浏览器窗口切换，轮播图加速；使用doucment的visibilitychange解决

6. recommend组件
- 组件
    + views/Home/childComps/HomeRecommend.vue

7. featureview组件
- 组件
    + views/Home/childComps/FeatureView.vue

8. tabcontrol组件
- 组件
    + components/common/tabcontrol/TabControl
- 组件思想
    + 不适用插槽插入固定标签与文本，采用props传输titles数组至子组件

9. 商品列表展现
- 数据结构
    + 商品列表分为pop，sell，news之间切换，切换中列表有各自页数位置
    + 设计为 goods对象 > pop+sell+news > page: , list: number
- 数据请求
    + created执行三次methods下请求方法
    + methods接受请求参数，执行请求方法并声明回调处理（该方法需可复用）
    + home.js提供已配置请求路径，参数的请求处理
- 数据展示
    + 组件
        - content/ GoodsList > GoodsListItem
        - :绑定pop数据至GoodsList，GoodsListItem接受每个商品数据为参数
    + tabcontrol切换商品列表
        - 为tabcontrol切换时触发tabclick向父组件$emit切换index索引
        - home订阅tabcontrol事件，更改绑定的goods商品列表数据，goodslist组件数据对响应

10. better-scroll滚动优化
    + 安装better-scroll第三方工具
        - npm install @better-scroll/core --save
    + 引入并测试使用
        - import BScroll from '@better-scroll/core'
        - 滚动标签结构：.wrapper(滚动元素) > .content(滚动内容容器) > 所有滚动内容
        - mounted生命周期函数下执行new BScroll(wrap,null);
    + 应用项目
        - 新建1个scroll独立组件用于滑动效果开发
        - 向scroll组件插入内容，设置scroll组件的滑动可视区
    + better-scroll问题
        - 无法滚动：mounted创建better-scroll实例时，图片未加载完成导致content高度小于wrapper高度；使用滚轮滚动也会导致scroll工具出错
        - 解决：图片load完成执行BScroll.refresh重写计算content高度，或者延迟2秒执行better-scroll实例创建
        - 实现：在goodslistitem组件监听每个img的load事件，通过事件总线$bus发布，home组件订阅执行scroll组件的scroll实例的refresh方法重新计算可滚动区域

11. backto组件
    + 基本功能
        - 为home下back-to标签绑定 @click.native事件给原生组件对象
        - backTo触发scroll组件的scrollTo方法回至顶部
    + 显示隐藏
        - scroll组件内监听滚动，向上emit滚动事件
        - 为防止scroll始终监听scroll事件，由props传递probeType决定是否监听
        - home接收emit的scroll事件，判断position.y参数大小，修改backto的v-show变量

12. 下拉加载更多商品
    + scroll组件根据home传入的pullUpLoad是否监听pullingUp，该事件需要安装@better-scroll/pull-up插件
    + pullingUp事件$emit至home，执行getMore处理，再次请求数据并更新goods
    + getMore处理调用goods请求后，需执行scroll组件的scroll实例的finishPullUp结束上拉状态，执行refresh重写计算可下拉区高度使scroll组件可继续滑动

13. tabControl吸附效果
    + 获取组件的offsetTop
        - 必须在轮播图加载完成后，发送swipperImgLoad事件
        - 将offsetTop值使用data的tabControlTop属性保存
    + 监听滚动中设置替换tabControl
        - tabControl1默认固定在顶部，不可见；tabControl2跟随滚动
        - scroll监听事件的处理判断滚动，滚动值大于offsetTop则显现tabControl1

14. home滚动状态保存（导航切换保留home访问位置状态）
    + keep-alive标签缓存home组件
    + 添加activated和deactivated事件(第一次自动触发一次activated)
        - 记录scroll值和设置better-scroll滚动值
        - 暂停swipper动画和继续autoSlider轮播
        - 重新refresh计算better-scroll可滚动高度

#### 详情页开发
1. 详情页配置
    - 新建详情页视图，配置路由
    - GoodListItem绑定点击路由跳转，通过$router传递商品id至detail
    - Detail内created生命函数保存$route的查询id

2. 顶部导航
    - 组件选择
        + navbar
        当前页面导航，快速访问当前页面内容或跳转页面，分为左中右三部分，可回退
        + tabcontrol
        强调切换功能，点击tab切换当前页面的某部分，所以不选择该组件

3. detail请求商品数据
    - 新建network/detail.js，配置请求路径与参数，Detail视图调用请求
    - 在getDetail函数回调的Promise对象的then分离商品详情页数据并分别保存

4. 商品轮播图
    - 新建childComps/DetailSwipper，引入swipper，swipperItem组件
    - 传递topImages至detailswipperitem，遍历为swipperItem的图片
    - 附：Detail视图每次创建时才能接受新id，所以keep-alive不应该缓存detail

5. 商品基本信息
    - 从商品数据res中抽离分散的baseInfo
        + 在newwork/detail.js新建Goods类，接收分散的数据参数创建具有baseInfo的good对象实例
        + 在getDetail的回调中传入res的各部分为参调用类，保存返回的good实例
    - 传递good实例作为参数至detailbaseinfo，绑定基本数据的3大块

6. 店铺信息
    - 同上

7. 商品信息
    - 数据对象判断
        + 子组件接收父组件传递的数据后，不访问数据对象的属性可以直接使用，如直接遍历数组
        + 访问数据对象的属性，需要判断数据对象是否为默认值（空或null），为空则v-if不显示
    - refresh
        + better-scroll默认在new时计算滚动高度，不包含未加载完成图片的高度（导致不可滚动）
        + 监听图片加载完成再次refresh，可以load事件判断count是否等于图片数据长度得出是否为最后一张，仅调用一次refresh（适用于图片量较少，较多会过渡延迟refresh）
        + home的下拉加载图片是分批次，不固定量的图片，使用防抖函数避免多次refresh

8. 评论数据
    - 事件戳格式化为日期
    - 存在评论数据不存在情况，需判断后决定是否保存值

9. 推荐数据
    - detail.js单独新建访问推荐数据接口的请求函数
    - 调用并保存请求的推荐商品数据
    - 直接复用GoodList组件在detail页显示推荐商品

10. 问题
    - detail的goodlistitem的imgLoad事件会同时refresh主页和详情页
        + 解决：detail和home页面离开时关闭(off)当前imgLoad的监听处理函数goodsItemListener
        + 使用混入mixin两个视图的重复代码，如绑定事件，声明data

11. navBar的响应功能
    - 功能需求
        + 点击标题跳转至对应内容，滑到对应位置导航标题响应样式
    - 点击跳转
        + 添加positionsY数组用于保存标题对应y值，点击标题scrollTo至位置y
        + created周期debounce生成获取内容组件对应offsetTop的功能函数
        + 在detail的图片加载完成refresh时触发生成的获取位置的防抖
    - 滚动响应
        + 监听better-scroll的滚动，判断滚动y位于positionsY数组比较
        + 判断对应的位置，修改navbar组件的currentIndex为

12. mixin混入backTop功能

#### 购物车开发
1. detail页点击加入购物车
    + 添加点击事件
    + 添加商品信息至vuex状态管理
    + 设置vuex的state，mutations，actions

2. 复用navbar

3. 复用scroll
    + 默认购物车无内容，因此scroll初始计算高度为0
    + 添加购物车后scroll内会有新的内容高度没有计算在内
    + 所以每次激活购物车都refresh计算scroll内容高度

4. 封装cartlist
    + 购物车数据从vuex中获取

5. 封装check-button
    + 根据传递的checked布尔值控制选择样式
    + store的cartlist每个商品添加默认的checked值
    + 在cartlist组件中传递checked值至check-button
    + 点击checkbutton取反商品的checked值

6. 封装bottombar
    + 全选按钮check-button
        - 判断商品选中状态切换全选按钮选中
        - 全选按钮点击选中/反选商品

#### 分类页开发
1. 页面结构
    + 顶部navbar
    + 左侧tab栏
    + 右侧scroll内容

2. 分类数据
    + 数据结构
        - tabsData:左侧tab栏菜单数据，包含title，用于访问对应nav和good的key
        - navigation: 右侧内容区顶部导航数据，每个key串属性对应一个tab的nav
        - goods: 内容区域的商品数据，每个key串属性对应一个tab的good
            + 每个tab项good数据对象又分为pop,sell,new三个数组
    + 首次请求
        - 组件创建后请求tabs数据，以及第一个tab项nav数据和good数据
        - 切换tab时，通过点击的tab的key判断nav和goods是否存在对应key串属性值，不存在则请求对应nav与good并保存
    + 数据切换
        - 切换tab时，切换curMaitkey和curMiniWallkey，使绑定在对应组件上数据改变

## Toast弹窗插件
1. 加入购物车回调处理
    + addCart事件添加Promise异步回调

2. 封装Toast.vue组件

3. 编写插件对象
    + toast组件文件夹下添加index.js
    + 创建插件对象并添加插件安装时处理

4. 全局使用插件
    + main.js引入并use插件对象

5. 其他Vue组件使用toast
    + detail，cart组件界面使用
    + this.$toast.show('弹出文本',time)


## 优化处理
- fastclick解决移动端点击延迟300ms
    + 安装fastclick包
    + 导入fastclick模块
    + 调用fastclick的attach函数

- 图片懒加载
    + 安装vue-lazyload插件
    + main.js引入配置插件
    + 修改需要懒加载图片src属性为v-lazy

- postcss-px-to-vw单位转换
    + 单位转换根据视口大小缩放元素宽高
    + 定义不允许转换的固定大小元素，可在配置中填入类名或样式文件

## 部署项目
- 远程部署
    + 远程主机安装centus
    + 通过本地终端链接远程主机
    + 命令安装nginx服务
    + yam的ssh

