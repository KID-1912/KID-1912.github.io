---
layout:     post
title:      Java
subtitle:   
date:       2024-06-01
author:     page
header-img: img/SpringBoot.webp
catalog: true
tags:
    - Java
---

# Spring Boot

通过 `WebMvcConfigurer` Bean映射 static资源

**版本对应**

| Spring Boot版本 | Spring Boot 2.x | Spring Boot 3.x |
|:-------------:|:---------------:|:---------------:|
| Spring版本      | Spring 5.x      | Spring 6.x      |
| JDK版本         | >= 1.8          | >= 17           |
| Tomcat版本      | 9.x             | 10.x            |

前面我们定义的数据源、声明式事务、JdbcTemplate在哪创建的？怎么就可以直接注入到自己编写的 `UserService` 中呢？

这些自动创建的Bean就是Spring Boot的特色：AutoConfiguration。

当我们引入`spring-boot-starter-jdbc`时，启动时会自动扫描所有的`XxxAutoConfiguration`：

- `DataSourceAutoConfiguration`：自动创建一个`DataSource`，其中配置项从`application.yml`的`spring.datasource`读取；
- `DataSourceTransactionManagerAutoConfiguration`：自动创建了一个基于JDBC的事务管理器；
- `JdbcTemplateAutoConfiguration`：自动创建了一个`JdbcTemplate`。

因此，我们自动得到了一个`DataSource`、一个`DataSourceTransactionManager`和一个`JdbcTemplate`。

类似的，当我们引入`spring-boot-starter-web`时，自动创建了：

- `ServletWebServerFactoryAutoConfiguration`：自动创建一个嵌入式Web服务器，默认是Tomcat；
- `DispatcherServletAutoConfiguration`：自动创建一个`DispatcherServlet`；
- `HttpEncodingAutoConfiguration`：自动创建一个`CharacterEncodingFilter`；
- `WebMvcAutoConfiguration`：自动创建若干与MVC相关的Bean。
- ...

引入第三方`pebble-spring-boot-starter`时，自动创建了：

- `PebbleAutoConfiguration`：自动创建了一个`PebbleViewResolver`。

可见，Spring Boot自动装配功能是通过自动扫描+条件装配实现的，这一套机制在默认情况下工作得很好，但是，如果我们要手动控制某个Bean的创建，就需要详细地了解Spring Boot自动创建的原理，很多时候还要跟踪`XxxAutoConfiguration`，以便设定条件使得某个Bean不会被自动创建。

**编写controller**

idea设置：
“项目结构”里：项目-jdk指定，模块-语言级别指定
”运行“ “修改运行设置“里：java 版本设置

“设置” “java编译器” “项目字节码版本“ 8支持

Pebble Spring Boot Starter 根据官方文档说明使用最新版 3.2.2

后续：

回顾Spring笔记以及java基础，java核心笔记

根据官方实例编写文档
