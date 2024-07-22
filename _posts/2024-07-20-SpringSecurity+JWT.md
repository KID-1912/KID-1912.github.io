---
layout:     post
title:      SpringSecurity+JWT
subtitle:   Spring Security框架我们主要用它就是解决一个认证授权功能
date:       2024-07-20
author:     page
header-img: img/MySQL.png
catalog: true
tags:
    - Springboot
---

# Spring Security

## 工作流程

Spring Security 的web基础是Filters，即通过一层层的Filters来对web请求做处理。

一个web请求会经过一条过滤器链，在经过过滤器链的过程中会完成认证与授权，如果中间发现这条请求未认证或者未授权，会根据被保护API的权限去抛出异常，然后由异常处理器去处理这些异常。

![](https://raw.githubusercontent.com/KID-1912/Github-PicGo-Images/master/202407201133819.webp)

`Spring Security` 自带的过滤器中是没有针对JWT这种认证方式的，所以我们会写一个JWT的认证过滤器，然后放在绿色的位置进行认证工作。

## 基础概念（组件）

- **SecurityContext**：上下文对象，`Authentication`对象会放在里面。
- **SecurityContextHolder**：用于拿到上下文对象的静态工具类。
- **Authentication**：认证接口，定义了认证对象的数据形式。
- **AuthenticationManager**：用于校验`Authentication`，返回一个认证完成后的`Authentication`对象。

### SecurityContext

上下文对象，认证后的数据就放在这里面，接口定义如下：

```java
public interface SecurityContext extends Serializable {
 // 获取Authentication对象
 Authentication getAuthentication();

 // 放入Authentication对象
 void setAuthentication(Authentication authentication);
}
```

这个接口里面只有两个方法，其主要作用就是get or set `Authentication`。

### SecurityContextHolder

```java
public class SecurityContextHolder {

  public static void clearContext() {
    strategy.clearContext();
  }

  public static SecurityContext getContext() {
    return strategy.getContext();
  }

  public static void setContext(SecurityContext context) {
    strategy.setContext(context);
  }
}
```

`SecurityContext` 的工具类，用于get or set or clear `SecurityContext`，默认会把数据都存储到当前线程中。

### Authentication

```java
public interface Authentication extends Principal, Serializable {
   Collection<? extends GrantedAuthority> getAuthorities();
   Object getCredentials();
   Object getDetails();
   Object getPrincipal();
   boolean isAuthenticated();
   void setAuthenticated(boolean isAuthenticated) throws IllegalArgumentException;
}
```

这几个方法效果如下：

- **`getAuthorities`**: 获取用户权限，一般情况下获取到的是**用户的角色信息**。
- **`getCredentials`**: 获取证明用户认证的信息，通常情况下获取到的是密码等信息。
- **`getDetails`**: 获取用户的额外信息，（这部分信息可以是我们的用户表中的信息）。
- **`getPrincipal`**: 获取用户身份信息，在未认证的情况下获取到的是用户名，**在已认证的情况下获取到的是 UserDetails。**
- **`isAuthenticated`**: 获取当前 `Authentication` 是否已认证。
- **`setAuthenticated`**: 设置当前 `Authentication` 是否已认证（true or false）。

`Authentication`只是定义了一种在SpringSecurity进行认证过的数据的数据形式应该是怎么样的，要有权限，要有密码，要有身份信息，要有额外信息。

### AuthenticationManager

```java
public interface AuthenticationManager {
 // 认证方法
 Authentication authenticate(Authentication authentication)
   throws AuthenticationException;
}
```

`AuthenticationManager`定义了一个认证方法，它将一个未认证的`Authentication`传入，返回一个已认证的`Authentication`，默认使用的实现类为：ProviderManager。

**认证流程**

以上构成Spring Security进行认证的流程：

1. 先是一个请求带着身份信息进来 

2. 经过`AuthenticationManager`的认证

3. 再通过`SecurityContextHolder`获取`SecurityContext`

4. 最后将认证后的信息放入到`SecurityContext`

## 准备工作

### 依赖包

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>

<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.3.0</version>
</dependency>
```

### 安全配置类

为了让Spring知道我们想怎样控制安全性，建立一个安全配置类 `SpringSecurityConfig`：

```java
// config/SpringSecurity.java

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SpringSecurityConfig {
    // securityFilterChain 自定义访问控制
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception

    // 获取用户信息处理
    @Bean
    public UserDetailsService userDetailsService() {
      return new UserDetailsService(){ ...内部实现 }
    }
    // 或者独立内部实现到 service/impl/CustomUserDetailsService.java
    // @Bean
    // public UserDetailsService userDetailsService() {
    //    return new CustomUserDetailsService();
    // }

    // 未登录异常处理
    // 权限不足异常处理
    // 自定义jwt过滤器

    // 使用自带的 authenticationManager 代办认证操作
    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
      // ......
    }

    // 访问控制的投票器，决定是否允许访问某个资源
    // @Bean public AccessDecisionVoter<FilterInvocation> accessDecisionProcessor

    // 决策管理组件
    // @Bean
    // public AccessDecisionManager accessDecisionManager
}
```

### 定义组件

**定义加密器Bean**

```java
// config/SpringSecurityConfig.java
@Bean
public PasswordEncoder passwordEncoder() {
    return new SCryptPasswordEncoder();
}
```

这个Bean是不必可少的，`Spring Security` 在认证操作（`additionalAuthenticationChecks`），以及自己存储密文密码时使用我们定义加密器；

如果你需要自己定义的加密方式，如新增 `MD5PasswordEncoder` 实现：

```java
// util/MD5PasswordEncoder.java
public class MD5PasswordEncoder implements PasswordEncoder {

    @Override
    public String encode(CharSequence rawPassword) {
        return MD5Util.encrypt((String) rawPassword);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        return MD5Util.encrypt((String) rawPassword).equals(encodedPassword);
    }
}
```

```java
// config/SpringSecurityConfig.java
@Bean
public PasswordEncoder passwordEncoder() {
    return new MD5PasswordEncoder();
}
```

**定义AuthenticationManager**

```java
@Bean
public AuthenticationManager authenticationManager() throws Exception {
    AuthenticationConfiguration authenticationConfiguration = authenticationConfiguration();
    return authenticationConfiguration.getAuthenticationManager();
}
```

这里将 `Spring Security` 自带的 `authenticationManager` 声明成Bean，作用是用它帮我们进行认证操作，调用这个Bean的`authenticate`方法会由 `Spring Security` 自动帮我们做认证。也支持修改逻辑实现自定以认证操作；

### 实现UserDetailsService

```java
// service/impl/CustomUserDetailsService.java
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private UserService userService;
    @Autowired
    private RoleInfoService roleInfoService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.debug("开始登陆验证，用户名为: {}", username);

        // 根据用户名验证用户
        QueryWrapper<UserInfo> queryWrapper = new QueryWrapper<>();
        queryWrapper.lambda().eq(UserInfo::getLoginAccount, username);
        UserInfo userInfo = userService.getOne(queryWrapper);
        if (userInfo == null) {
            throw new UsernameNotFoundException("用户名不存在，登陆失败。");
        }

        // 构建 UserDetail 对象
        UserDetail userDetail = new UserDetail();
        userDetail.setUserInfo(userInfo);
        List<RoleInfo> roleInfoList = roleInfoService.listRoleByUserId(userInfo.getUserId());
        userDetail.setRoleInfoList(roleInfoList);
        return userDetail;
    }
}
```

实现 `UserDetailsService` 的抽象方法并返回一个 **UserDetails** 对象，逻辑完全自定义但必须将将用户信息和权限信息组装成一个 **UserDetails** 返回。(若项目无权限设计，可忽略roleInfo部分）

Spring Security在用户认证过程中会使用它来获取用户信息，并基于这些信息执行身份验证。

**TokenUtil**

采用JWT认证模式，需要一个帮我们操作Token的工具类，它至少具有以下三个方法：  

- 创建token
- 验证token
- 反解析token中的信息

## 具体实现
