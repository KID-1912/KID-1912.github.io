---
layout:     post
title:      RESTful API
subtitle:   互联网应用程序的API设计理论,规范前端设备与后端进行通信机制;
date:       2020-08-16
author:     page
header-img: img/post-bg-swift2.jpg
catalog: true
tags:
---
# RESTful API
RESTful API是目前比较成熟的一套互联网应用程序的API设计理论,规范前端设备与后端进行通信机制;  
### 路径  
1. 在RESTful架构中，每个网址代表一种资源，所以网址中不能有动词，只能有名词  
2. 所用的名词往往与数据库的表格名对应。一般来说，数据库中的表都是同种记录的"集合"，所以API中的名词也应该使用复数。  
举例来说，有一个API提供动物园（zoo）的信息，还包括各种动物和雇员的信息，则它的路径应该设计成下面这样。
https://api.example.com/v1/zoos  
https://api.example.com/v1/animals  
https://api.example.com/v1/employees  

### HTTP动词
- 对于资源(数据库)的具体操作类型，由HTTP请求方式表示。

    + GET（SELECT）：从服务器取出资源（一项或多项）。
    + POST（CREATE）：在服务器新建一个资源。
    + PUT（UPDATE）：在服务器更新资源（客户端提供改变后的完整资源）。
    + PATCH（UPDATE）：在服务器更新资源（客户端提供改变的属性）。
    + DELETE（DELETE）：从服务器删除资源。

- 通过指定资源路径的子路径传递操作项参数
    + GET /zoos：列出所有动物园
    + POST /zoos：新建一个动物园
    + GET /zoos/ID：获取某个指定动物园的信息
    + PUT /zoos/ID：更新某个指定动物园的信息（提供该动物园的全部信息）
    + PATCH /zoos/ID：更新某个指定动物园的信息（提供该动物园的部分信息）
    + DELETE /zoos/ID：删除某个动物园
    + GET /zoos/ID/animals：列出某个指定动物园的所有动物
    + DELETE /zoos/ID/animals/ID：删除某个指定动物园的指定动物

### 过滤信息
如果记录数量很多，服务器不可能都将它们返回给用户。API应该提供参数，过滤返回结果。

- ?limit=10：指定返回记录的数量
- ?offset=10：指定返回记录的开始位置。
- ?page=2&per_page=100：指定第几页，以及每页的记录数。
- ?sortby=name&order=asc：指定返回结果按照哪个属性排序，以及排序顺序。
- ?animal_type_id=1：指定筛选条件

### 返回结果
针对不同操作，服务器向用户返回的结果应该符合以下规范。

- GET /collection：返回资源对象的列表（数组）
- GET /collection/resource：返回单个资源对象
- POST /collection：返回新生成的资源对象
- PUT /collection/resource：返回完整的资源对象
- PATCH /collection/resource：返回完整的资源对象
- DELETE /collection/resource：返回一个空文档




部分转载自:阮一峰博客——RESTful API 设计指南   http://www.ruanyifeng.com/blog/2014/05/restful_api.html