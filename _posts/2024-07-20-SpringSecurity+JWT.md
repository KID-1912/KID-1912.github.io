---
layout:     post
title:      SpringSecurity+JWT
subtitle:   Spring Security框架我们主要用它就是解决一个认证授权功能
date:       2024-07-20
author:     page
header-img: img/MySQL.png
catalog: true
tags:
    - Java
---

# Spring Security

## 工作流程

Spring Security 的web基础是Filters，即通过一层层的Filters来对web请求做处理。

一个web请求会经过一条过滤器链，在经过过滤器链的过程中会完成认证与授权，如果中间发现这条请求未认证或者未授权，会根据被保护API的权限去抛出异常，然后由异常处理器去处理这些异常。

![](https://raw.githubusercontent.com/KID-1912/Github-PicGo-Images/master/202407201133819.webp)

`Spring Security` 自带的过滤器中是没有针对JWT这种认证方式的，所以我们会写一个JWT的认证过滤器，然后放在绿色的位置进行认证工作。

## 基础概念（组件）

- **SecurityContext**：上下文对象，`Authentication` 对象会放在里面。
- **SecurityContextHolder**：用于拿到上下文对象的静态工具类。
- **Authentication**：认证接口，定义了认证对象的数据形式。
- **AuthenticationManager**：用于校验 `Authentication`，返回一个认证完成后的`Authentication` 对象。

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
 Authentication authenticate(Authentication authentication) throws AuthenticationException;
}
```

`AuthenticationManager`定义了一个认证方法，它将一个未认证的`Authentication`传入，返回一个已认证的`Authentication`，默认使用的实现类为：ProviderManager。

**认证流程**

以上构成Spring Security进行认证的流程：

1. 先是一个请求带着身份信息进来 

2. 经过 `AuthenticationManager` 的认证

3. 再通过 `SecurityContextHolder` 获取 `SecurityContext`

4. 最后将认证后的信息放入到 `SecurityContext`

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

    // 加密器
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new MD5PasswordEncoder();
    } 

    // 获取用户信息处理
    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomerUserDetailsService();
    }

    private static class CustomerUserDetailsService implements UserDetailsService {
      // UserDetailsService.loadUserByUsername实现
    }
    // 或者独立内部实现到 service/impl/CustomUserDetailsService.java

    // 认证（未登录）异常处理

    // 权限不足异常处理

    // jwt过滤器
    @Bean
    public JwtAuthenticationTokenFilter jwtAuthenticationTokenFilter(){
      return new JwtAuthenticationTokenFilter();
    }

    @Bean
    public AuthenticationConfiguration authenticationConfiguration() {
        return new AuthenticationConfiguration();
    }

    // 使用自带的 authenticationManager 代办认证操作
    @Bean
    public AuthenticationManager authenticationManager() throws Exception {
        AuthenticationConfiguration authenticationConfiguration = authenticationConfiguration();
        return authenticationConfiguration.getAuthenticationManager();
    }

    // 访问控制的投票器，决定是否允许访问某个资源
    // @Bean public AccessDecisionVoter<FilterInvocation> accessDecisionProcessor

    // 决策管理组件
    // @Bean
    // public AccessDecisionManager accessDecisionManager
}
```

### 定义组件

#### 加密器Bean

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

#### AuthenticationManager

```java
@Bean
public AuthenticationConfiguration authenticationConfiguration() {
    return new AuthenticationConfiguration();
}

@Bean
public AuthenticationManager authenticationManager() throws Exception {
    AuthenticationConfiguration authenticationConfiguration = authenticationConfiguration();
    return authenticationConfiguration.getAuthenticationManager();
}
```

这里将 `Spring Security` 自带的 `authenticationManager` 声明成Bean，作用是用它帮我们进行认证操作，调用这个Bean的 `authenticate` 方法会由 `Spring Security` 自动帮我们做认证。也支持修改逻辑实现自定以认证操作；

#### UserDetailsService

```java
// service/impl/CustomUserDetailsService.java
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private UserService userService;
    // @Autowired
    // private RoleInfoService roleInfoService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.debug("开始登陆验证，用户名为: {}", username);

        // 根据用户名验证用户
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.lambda().eq(User::getLoginAccount, username);
        User user = userService.getOne(queryWrapper);
        if (user == null) {
            throw new UsernameNotFoundException("用户名不存在，登陆失败。");
        }

        // 构建 UserDetail 对象
        UserDetail userDetail = new UserDetail();
        userDetail.setUser(user);
        // List<RoleInfo> roleInfoList = roleInfoService.listRoleByUserId(userInfo.getUserId());
        // userDetail.setRoleInfoList(roleInfoList);
        return userDetail;
    }
}
```

实现 `UserDetailsService` 的抽象方法并返回一个 **UserDetails** 对象，逻辑完全自定义但必须将将用户信息和权限信息组装成一个 **UserDetails** 返回。(若项目无权限设计，可忽略roleInfo部分）

Spring Security在用户认证过程中（authenticate）会使用它来获取用户信息，并基于这些信息执行身份验证。

**UserDetail**

其中 **UserDetails** 也是一个定义了数据形式的接口，用于保存我们从数据库中查出来的数据，其功能主要是验证账号状态和获取权限。见 `entity/UserDetail.java` 对其实现；

#### JwtProvider

采用JWT认证模式，需要一个帮我们操作Token的工具类，它至少具有以下三个方法：  

- 创建token
- 验证token
- 反解析token中的信息

**JwtProperties**

定义配置类JwtProperties，从 `application.yml` 读取jwt配置

```java
// properties/JwtProperties.java
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {

    /**
     * 密钥
     */
    @Value("${jwt.apiSecretKey:JWT_SECRET_KEY}")
    private String apiSecretKey;

    /**
     * 过期时间-默认半个小时
     */
    @Value("${jwt.expirationTime:1800}")
    private Long expirationTime;

    /**
     * 默认存放token的请求头
     */
    @Value("${jwt.requestHeader:Authorization}")
    private String requestHeader;

    /**
     * 默认token前缀
     */
    @Value("${jwt.tokenPrefix:Bearer}")
    private String tokenPrefix;
}
```

**AccessToken**

```java
// bo/AccessToken.java
@Data
@Builder
public class AccessToken {
    private String loginAccount;
    private String token;
    private Date expirationTime;
}
```

**JwtProvider**

```java
// provider/JwtProvider.java
@Component
public class JwtProvider {
    // 请求中获取token
    public String getToken(HttpServletRequest request) 
    // 根据用户信息生成token
    public AccessToken createToken(UserDetails userDetails) 
    // 生成token
    // 参数是放入token中的字符串
    public AccessToken createToken(String subject) 
    // 验证token是否有效
    // 反解析token中的信息，与参数中的信息比较，再校验过期时间
    public boolean validateToken(String token, UserDetails userDetails) 
    // 从token解析出负载信息
    // 生成token
    // 参数是放入token中的字符串
    public AccessToken createToken(String subject) {
        // 当前时间
        final Date now = new Date();
        // 过期时间
        final Date expirationDate = new Date(now.getTime() + jwtProperties.getExpirationTime() * 1000);

        // jjwt 
        // 生成密钥 SecretKey key = Keys.secretKeyFor(SignatureAlgorithm.HS512);
        SecretKey key = Keys.hmacShaKeyFor(jwtProperties.getApiSecretKey().getBytes(StandardCharsets.UTF_8));
        String token = jwtProperties.getTokenPrefix() + Jwts.builder()
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expirationDate)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
        return AccessToken.builder().loginAccount(subject).token(token).expirationTime(expirationDate).build();
    }
    ......
}
```

## 具体实现

### 认证方法

```java
// service/impl/UserServiceImpl.java
private AuthenticationManager authenticationManager;

@Autowired
public void setAuthenticationManager(@Lazy AuthenticationManager authenticationManager) {
    this.authenticationManager = authenticationManager;
}

@Autowired
JwtProvider jwtProvider;

public String signin(String username, String password) {
    // 认证方法
    // 1. 创建usernameAuthenticationToken
    UsernamePasswordAuthenticationToken usernamePasswordAuthentication = new UsernamePasswordAuthenticationToken(username, password);
    // 2. 认证
    Authentication authentication;
    try {
        authentication = this.authenticationManager.authenticate(usernamePasswordAuthentication);
    }catch(BadCredentialsException e ){
        throw new ServiceException(StatusEnum.LOGIN_ERROR);
    }
    // 3. 保存认证信息
    SecurityContextHolder.getContext().setAuthentication(authentication);
    // 4. 生成自定义token
    AccessToken accessToken = jwtProvider.createToken((UserDetails) authentication.getPrincipal());
    // 5. 放入缓存
    // UserDetail userDetail = (UserDetail) authentication.getPrincipal();
    // caffeineCache.put(CacheName.USER, userDetail.getUsername(), userDetail);
    return accessToken.getToken();
}
```

- 传入用户名和密码创建了一个`UsernamePasswordAuthenticationToken`对象，这是我们前面说过的`Authentication`的实现类，传入用户名和密码做构造参数，这个对象就是我们创建出来的未认证的`Authentication`对象。
- 使用我们先前已经声明过的Bean-`authenticationManager`调用它的`authenticate`方法进行认证，返回一个认证完成的`Authentication`对象。
- 认证完成没有出现异常，就会走到第三步，使用`SecurityContextHolder`获取`SecurityContext`之后，将认证完成之后的`Authentication`对象，放入上下文对象。
- 从`Authentication`对象中拿到我们的`UserDetails`对象，之前我们说过，认证后的`Authentication`对象调用它的`getPrincipal()`方法就可以拿到我们先前数据库查询后组装出来的`UserDetails`对象，然后创建token。
- 把`UserDetails`对象放入缓存中，方便后面过滤器使用。

主要认证操作都会由 `authenticationManager.authenticate()` 帮助完成

通过 `AbstractUserDetailsAuthenticationProvider` 下 `authenticate` 源代码，了解Spring Security的操作包括：

**loadUserByUsername**

调用我们重写UserDetailsService的loadUserByUsername方法，根据用户名验证用户存在，并拿到我们自己组装好的UserDetails对象；

**additionalAuthenticationChecks**

通过对UserDetails和authentication实现密码一致对比

### JWT过滤器

`config/SpringSecurityConfig` 配置 jwt过滤器，并添加到 SecurityFilterChain上

```java
// config/SpringSecurityConfig.java
// 自定义的jwt过滤器
@Bean
public JwtAuthenticationTokenFilter jwtAuthenticationTokenFilter() {
    return new JwtAuthenticationTokenFilter();
}
```

```java
// config/SpringSecurityConfig.java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(authorizeRequests -> authorizeRequests)
        .addFilterBefore(jwtAuthenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class)
    // ......
}
```

**JwtAuthenticationTokenFilter**

```java
// component/JwtAuthenticationTokenFilter.java

public class JwtAuthenticationTokenFilter extends OncePerRequestFilter {
    @Autowired
    private JwtProvider jwtProvider;

    @Autowired
    private JwtProperties jwtProperties;

    @Autowired
    UserService userService;

    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest request,
                                    @NotNull HttpServletResponse response,
                                    @NotNull FilterChain chain) throws ServletException, IOException {
        String authToken = jwtProvider.getToken(request);
        if(authToken != null && !authToken.isEmpty() && authToken.startsWith(jwtProperties.getTokenPrefix())){
            authToken = authToken.substring(jwtProperties.getTokenPrefix().length());
            String loginAccount = jwtProvider.getSubjectFromToken(authToken); // 解析Token，若token过期或无效，将返回null
            // loginAccount存在且无authentication验证信息
            if(loginAccount != null && !loginAccount.isEmpty() && SecurityContextHolder.getContext().getAuthentication() == null) {
                // 查询缓存中用户userDetail
                // UserDetail userDetail = caffeineCache.get(CacheName.USER, loginAccount, UserDetail.class);
                // 由于目前未支持缓存，改查询数据库
                QueryWrapper<User> queryWrapper = new QueryWrapper<>();
                queryWrapper.eq("username", loginAccount);
                User user = userService.getOne(queryWrapper);
                if (user != null) {
                    UserDetail userDetails = new UserDetail();
                    userDetails.setUser(user);
                    // 创建已认证UsernamePasswordAuthenticationToken
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, userDetails.getPassword(), userDetails.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication); // 供后续Filter使用
                }
            }
        }
        chain.doFilter(request, response);
    }
}
```

## 验证/鉴权失败处理

默认未认证的Authentication或者无权限接口（包括不存在的接口转到/error）都会被SpringSecurity空响应且 403 Forbidden Status；支持自定义处理：

**验证失败处理**

```java
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {
    private final ObjectMapper objectMapper = new ObjectMapper();
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authenticationException)
    throws IOException, ServletException
    {
        response.setHeader("Cache-Control", "no-cache");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(objectMapper.writeValueAsString(ResultResponse.error(StatusEnum.UNAUTHORIZED)));
        response.getWriter().flush();
    }
}
```

**权限不足处理**

注：目前暂未添加权限逻辑，此处仅展示错误处理逻辑

```java
// component/RestfulAccessDeniedHandler
public class RestfulAccessDeniedHandler implements AccessDeniedHandler {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void handle(
            HttpServletRequest request,
            HttpServletResponse response,
            AccessDeniedException e) throws IOException, ServletException {
        response.setHeader("Cache-Control", "no-cache");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(objectMapper.writeValueAsString(ResultResponse.error(StatusEnum.FORBIDDEN)));
        response.getWriter().flush();
    }
}
```

**SpringSecurityConfig配置错误处理**

```java
// config/SpringSecurityConfig.java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
            .authorizeHttpRequests(authorizeRequests ->
                    authorizeRequests
                            // ......
                            // 新增：放行 SpringMVC "/error"
                            .requestMatchers("/error").permitAll()
                            // 放行登录/注册方法
                            .requestMatchers("/signin", "/register").permitAll()
                            // 除上面的其他所有请求全部需要鉴权认证
                            .anyRequest().authenticated()
            )
            // 新增：配置自定义错误处理
            .exceptionHandling()
            .authenticationEntryPoint(restAuthenticationEntryPoint())
            .accessDeniedHandler(restfulAccessDeniedHandler())
            .and()
            .addFilterBefore(jwtAuthenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class)
```

**注入异常处理**

```java
// config/SpringSecurityConfig.java
    // 未登录异常处理
    @Bean
    public RestAuthenticationEntryPoint restAuthenticationEntryPoint(){
        return new RestAuthenticationEntryPoint();
    }

    // 权限不足异常处理
    @Bean
    public RestfulAccessDeniedHandler restfulAccessDeniedHandler(){
        return new RestfulAccessDeniedHandler();
    }
```

## 退出登录

```java
// 退出登录
@Override
public void logout() {
    // caffeineCache.remove(CacheName.USER, AuthProvider.getLoginAccount());
    SecurityContextHolder.clearContext();
}
```

## Token刷新

```java
// provider/JwtProvider.java

    // ......

        // 刷新token
    // 过滤器会对请求进行验证，此处不用验证
    public AccessToken refreshToken(String oldToken) {
        String token = oldToken.substring(jwtProperties.getTokenPrefix().length());
        Claims claims = getClaimsFromToken(token);
        // 旧token签发时间30分钟内，返回原token
        System.out.println(tokenRefreshJustBefore(claims));
        if (tokenRefreshJustBefore(claims)) {
            return AccessToken.builder().loginAccount(claims.getSubject()).token(oldToken).expirationTime(claims.getExpiration()).build();
        }else{
            return createToken(claims.getSubject());
        }
    }

    // 判断token在30分钟内签发的
    private boolean tokenRefreshJustBefore(Claims claims){
        Date nowDate = new Date();
        Date tokenCreateDate = new Date(claims.getExpiration().getTime() - jwtProperties.getExpirationTime() * 1000);
        // 当前时间在token创建时间30分钟范围内
        return nowDate.after(tokenCreateDate) && nowDate.before(new Date(tokenCreateDate.getTime() + 3 * 60 * 1000));
    }
```
