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

Spring框架主要功能包括IoC容器、AOP支持、事务支持、MVC开发以及强大的第三方集成功能等。

Spring Boot是一个基于Spring的套件，它帮我们预组装了Spring的一系列组件，以便以尽可能少的代码和配置来开发基于Spring的Java应用程序。

Spring Boot的目标就是提供一个开箱即用的应用程序架构，我们基于Spring Boot的预置结构继续开发，省时省力。

## Spring Boot应用

创建标准的Maven目录结构如下：

![](https://raw.githubusercontent.com/KID-1912/Github-PicGo-Images/master/202406301327545.png)

**项目构成**

Application：静态资源映射，拦截器

DatabaseInitializer：数据库初始化

web：Controller

service：服务层

entity：实体类

### application.yml

Spring Boot默认的一种层级格式的YAML配置文件

**环境变量**

在配置文件中，我们经常使用如下的格式对某个key进行配置：

```yml
app:
  db:
    host: ${DB_HOST:localhost}
    user: ${DB_USER:root}
    password: ${DB_PASSWORD:password}
```

`${DB_HOST:localhost}` 意思是，首先从环境变量查找 `DB_HOST`，如果环境变量定义了，那么使用环境变量的值，否则，使用默认值 `localhost`

开发时无需设定任何环境变量，直接使用默认值即本地数据库，而实际线上运行的时候，只需要传入环境变量即可：

```bash
$ DB_HOST=10.0.1.123 DB_USER=prod DB_PASSWORD=xxxx java -jar xxx.jar
```

### logback-spring.xml

Spring Boot的logback配置文件名称（也可以使用 `logback.xml` ）

通过 `<include resource="..." />` 引入了Spring Boot的一个缺省配置，这样我们就可以引用类似 `${CONSOLE_LOG_PATTERN}` 这样的变量。上述配置定义了一个控制台输出和文件输出，可根据需要修改；

### java

![](https://raw.githubusercontent.com/KID-1912/Github-PicGo-Images/master/202406301402423.png)

Spring Boot对Java包的层级结构有一个要求。注意到我们的根package是`com.itranswarp.learnjava`，下面还有`entity`、`service`、`web`等子package。Spring Boot要求`main()`方法所在的启动类必须放到根package下，命名不做要求，这里我们以`Application.java`命名，它的内容如下：

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
```

### pom.xml

**版本对应**

| Spring Boot版本 | Spring Boot 2.x | Spring Boot 3.x |
| ------------- | --------------- | --------------- |
| Spring版本      | Spring 5.x      | Spring 6.x      |
| JDK版本         | >= 1.8          | >= 17           |
| Tomcat版本      | 9.x             | 10.x            |

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.0.0</version>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <groupId>com.itranswarp.learnjava</groupId>
    <artifactId>springboot-hello</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>22</maven.compiler.source>
        <maven.compiler.target>22</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>

        <!-- 集成Pebble View -->
        <dependency>
            <groupId>io.pebbletemplates</groupId>
            <artifactId>pebble-spring-boot-starter</artifactId>
            <version>3.2.2</version>
        </dependency>

        <!-- JDBC驱动 -->
        <dependency>
            <groupId>org.hsqldb</groupId>
            <artifactId>hsqldb</artifactId>
        </dependency>
    </dependencies>

</project>
```

从`spring-boot-starter-parent`继承，因为这样就可以引入Spring Boot的预置配置；

引入了依赖`spring-boot-starter-web`和`spring-boot-starter-jdbc`，它们分别引入了Spring MVC相关依赖和Spring JDBC相关依赖，无需指定版本号，因为引入的`<parent>`内已经指定了，只有我们自己引入的某些第三方jar包需要指定版本号。

引入`pebble-spring-boot-starter`作为View，以及`hsqldb`作为嵌入式数据库。`hsqldb`已在`spring-boot-starter-jdbc`中预置了版本号`3.0.0`，因此此处无需指定版本号。

根据`pebble-spring-boot-starter`的[文档](https://pebbletemplates.io/wiki/guide/spring-boot-integration/)，加入如下配置到`application.yml`：

```yml
pebble:
  # 默认为".peb"，改为"":
  suffix:
  # 开发阶段禁用模板缓存:
  cache: false
```

**WebMvcConfigurer**

通过 `WebMvcConfigurer` Bean映射 static路径的资源

```java
@SpringBootApplication
public class Application {
    ...

    @Bean
    WebMvcConfigurer createWebMvcConfigurer(@Autowired HandlerInterceptor[] interceptors) {
        return new WebMvcConfigurer() {
            @Override
            public void addResourceHandlers(ResourceHandlerRegistry registry) {
                // 映射路径`/static/`到classpath路径:
                registry.addResourceHandler("/static/**")
                        .addResourceLocations("classpath:/static/");
            }
        };
    }
}
```

前面我们定义的数据源、声明式事务、JdbcTemplate在哪创建的？怎么就可以直接注入到自己编写的 `UserService` 中呢？

这些自动创建的Bean就是Spring Boot的特色：**AutoConfiguration**。

当我们引入 `spring-boot-starter-jdbc` 时，启动时会自动扫描所有的 `XxxAutoConfiguration`：

- `DataSourceAutoConfiguration`：自动创建一个`DataSource`，其中配置项从`application.yml`的`spring.datasource`读取；
- `DataSourceTransactionManagerAutoConfiguration`：自动创建了一个基于JDBC的事务管理器；
- `JdbcTemplateAutoConfiguration`：自动创建了一个 `JdbcTemplate`。

因此，我们自动得到了一个 `DataSource`、一个 `DataSourceTransactionManager` 和一个`JdbcTemplate`。

类似的，当我们引入 `spring-boot-starter-web`时，自动创建了：

- `ServletWebServerFactoryAutoConfiguration`：自动创建一个嵌入式Web服务器，默认是Tomcat；
- `DispatcherServletAutoConfiguration`：自动创建一个 `DispatcherServlet`；
- `HttpEncodingAutoConfiguration`：自动创建一个 `CharacterEncodingFilter`；
- `WebMvcAutoConfiguration`：自动创建若干与MVC相关的Bean。
- ...

引入第三方 `pebble-spring-boot-starter` 时，自动创建了：

- `PebbleAutoConfiguration`：自动创建了一个 `PebbleViewResolver`。

可见，Spring Boot自动装配功能是通过自动扫描+条件装配实现的，这一套机制在默认情况下工作得很好，但是，如果我们要手动控制某个Bean的创建，就需要详细地了解Spring Boot自动创建的原理，很多时候还要跟踪 `XxxAutoConfiguration`，以便设定条件使得某个Bean不会被自动创建。

**编写controller**

SpringMvc 开发：

```java
@Controller
public class UserController {
    @GetMapping("/")
    public ModelAndView index(){
        return new ModelAndView("index.html");
    }
}
```

**IDEA JDK相关设置**：
“项目结构”里：项目-jdk指定版本号，模块-语言级别指定版本号
”运行“ “修改运行设置“里：java 版本设置

“设置” “java编译器” “项目字节码版本“，“目标字节码版本” 都设置JDK17支持

## 开发者工具

Spring Boot提供了一个开发者工具，监控classpath路径上的文件。源码或配置文件发生修改，Spring Boot应用可以自动重启：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
</dependency>
```

确保IDEA的”文件“—“设置”中：

- “编译器”—“自动编译项目”勾选

- “高级设置”—“编译器”—“即使开发的应用程序当前正在运行，也允许自动make启用”勾选

## 打包应用

Spring Boot自带一个 `spring-boot-maven-plugin` 插件用来打包，我们只需要在`pom.xml`中加入以下配置：

```xml
<project ...>
    ...
    <build>
        <finalName>awesome-app</finalName> 此项可选，用于指定文件名覆盖默认名称
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

无需任何配置，自动定位应用程序的入口Class，执行Maven命令即可打包：

```bash
mvn clean package
```

直接运行：

```bash
$ java -jar springboot-exec-jar-1.0-SNAPSHOT.jar
```

## 瘦身应用

`spring-boot-maven-plugin` 打包应用，最大的缺点就是包体积过大；

如何只打包我们自己编写的代码，同时又自动把依赖包下载到某处，并自动引入到classpath中。解决方案就是使用 `spring-boot-thin-launcher`：

修改 `pom.xml` 中 `<build>`-`<plugins>`-`<plugin>`，给原来的 `spring-boot-maven-plugin` 增加一个 `<dependency>` 如下：

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot.experimental</groupId>
            <artifactId>spring-boot-thin-layout</artifactId>
            <version>1.0.27.RELEASE</version>
        </dependency>
    </dependencies>
</plugin>
```

运行 `mvn clean package`，最终生成的可执行 `jar`，只有79KB左右

`spring-boot-thin-launcher` 插件改变了 `spring-boot-maven-plugin` 默认行为。它输出的jar包只包含我们自己代码编译后的class，一个很小的 `ThinJarWrapper`，以及解析`pom.xml` 后得到的所有依赖jar的列表。

运行的时候，入口实际上是 `ThinJarWrapper`，它会先在指定目录搜索看看依赖的jar包是否都存在，如果不存在，先从Maven中央仓库下载到本地，然后，再执行我们自己编写的`main()` 入口方法。

`spring-boot-thin-launcher`在启动时搜索的默认目录是用户主目录的`.m2`，我们也可以指定运行jar时下载目录，例如，将下载目录指定为当前目录：

```shell
$ java -Dthin.root=. -jar awesome-app.jar
```

上述命令通过环境变量 `thin.root` 传入当前目录，执行后发现当前目录下自动生成了一个`repository`目录，这和Maven的默认下载目录 `~/.m2/repository` 的结构是完全一样的，只是它仅包含 `awesome-app.jar` 所需的运行期依赖项。

**预热**

第一次在服务器上运行`awesome-app.jar`时，仍需要从Maven中央仓库下载大量的jar包；

下载所有依赖项，但并运行实际运行 `main()` 方法，即 “预热”（warm up）：

```shell
java -Dthin.dryrun=true -Dthin.root=. -jar awesome-app.jar
```

如果服务器由于安全限制不允许从外网下载文件，那么可以本地预热，然后把 `awesome-app.jar` 和 `repository` 目录上传到服务器；
