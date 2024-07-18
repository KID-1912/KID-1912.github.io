---
layout:     post
title:      MyBatis-Plus
subtitle:   一个 MyBatis 的增强工具
date:       2024-07-18
author:     page
header-img: img/MySQL.png
catalog: true
tags:
    - SQL
---

# MyBatis-Plus

- **无侵入**：只做增强不做改变，引入它不会对现有工程产生影响，如丝般顺滑
- **损耗小**：启动即会自动注入基本 CURD，性能基本无损耗，直接面向对象操作
- **强大的 CRUD 操作**：内置通用 Mapper、通用 Service，仅仅通过少量配置即可实现单表大部分 CRUD 操作，更有强大的条件构造器，满足各类使用需求
- **支持 Lambda 形式调用**：通过 Lambda 表达式，方便的编写各类查询条件，无需再担心字段写错
- **支持主键自动生成**：支持多达 4 种主键策略（内含分布式唯一 ID 生成器 - Sequence），可自由配置，完美解决主键问题
- **支持 ActiveRecord 模式**：支持 ActiveRecord 形式调用，实体类只需继承 Model 类即可进行强大的 CRUD 操作
- **支持自定义全局通用操作**：支持全局通用方法注入（ Write once, use anywhere ）
- **内置代码生成器**：采用代码或者 Maven 插件可快速生成 Mapper 、 Model 、 Service 、 Controller 层代码，支持模板引擎，更有超多自定义配置等您来使用
- **内置分页插件**：基于 MyBatis 物理分页，开发者无需关心具体操作，配置好插件之后，写分页等同于普通 List 查询
- **分页插件支持多种数据库**：支持 MySQL、MariaDB、Oracle、DB2、H2、HSQL、SQLite、Postgre、SQLServer 等多种数据库
- **内置性能分析插件**：可输出 SQL 语句以及其执行时间，建议开发测试时启用该功能，能快速揪出慢查询
- **内置全局拦截插件**：提供全表 delete 、 update 操作智能分析阻断，也可自定义拦截规则，预防误操作

![](https://img.quanxiaoha.com/quanxiaoha/167299448922118)

## 快速开始

**添加依赖**

创建 mapper 包，存放UserMapper

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.2</version>
</dependency>
```

## 定义实体类

```java
// entity/User.java
@Data
@TableName("t_user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    @NotBlank(message="用户名不能为空")
    private String username;

    @NotBlank(message="密码不能为空")
    private String password;

    private long createdAt;
}
```

### @TableName

表名注解，标识实体类对应的表；

注：当实体类名称和实际表名一致时，可不用添加该注解，Mybatis Plus 会自动识别并映射到该表。

### @TableId

主键注解，声明实体类中的主键对应的字段；

| 属性    | 类型     | 必须指定 | 默认值         | 描述     |
| ----- | ------ | ---- | ----------- | ------ |
| value | String | 否    | ""          | 主键字段名  |
| type  | Enum   | 否    | IdType.NONE | 指定主键类型 |

**IdType 主键类型**

| 值           | 描述                                                                                                                                    |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| AUTO        | 数据库 ID 自增                                                                                                                             |
| NONE        | 无状态，该类型为未设置主键类型（默认）                                                                                                                   |
| INPUT       | 插入数据前，需自行设置主键的值                                                                                                                       |
| ASSIGN_ID   | 分配 ID(主键类型为 Number(Long 和 Integer)或 String)(since 3.3.0),使用接口`IdentifierGenerator`的方法`nextId`(默认实现类为`DefaultIdentifierGenerator`雪花算法) |
| ASSIGN_UUID | 分配 UUID,主键类型为 String(since 3.3.0),使用接口`IdentifierGenerator`的方法`nextUUID` (默认 default 方法)                                              |

## Mapper层

项目根目录下新建 config 包，并创建 MybatisPlusConfig 配置类：  

```java
// config.MyBatisPlusConfig
@Configuration  
@MapperScan("com.huaer.resource.admin")  
public class MyBatisPlusConfig {
}  
```

项目根目录下新建 mapper 包，添加 Mapper 类  

```java
// mapper/UserMapper
public interface UserMapper extends BaseMapper<User> {
}
```

## Service层

## 新增数据

![Mybatis Plus 新增数据思维导图](https://img.quanxiaoha.com/quanxiaoha/167213988351654)
