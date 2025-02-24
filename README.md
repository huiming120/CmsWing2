<div align="center">
  <p>
    <img width="280" src="https://oss.cmswing.com/gitee/logo_dark.svg">
  </p>

[CmsWing 是什么](https://www.cmswing.net/cms/detail/2) |
[快速入门](https://www.cmswing.net/cms/detail/3) |
[CMS 使用指南](https://www.cmswing.net/cms/detail/6) |
[开发手册](https://www.cmswing.net/cms/detail/11) |
[CmsWing 官网](https://www.cmswing.net) |
[GitHub](https://github.com/arterli/CmsWing) |
[Gitee](https://gitee.com/cmswing/CmsWing) |
[GitHub-二开版本](https://github.com/huiming120/CmsWing) |

</div>

<div align="center">
  QQ 群: 49757468
</div>

# CmsWing 是什么？

> CmsWing 是基于 Egg.js 开发的WEB开发框架，帮助开发团队和开发人员降低开发和维护成本。
> CmsWing 内置了 CMS 应用，可以直接使用。
> CmsWing 对Egg.js的路由，模型，配置等进行了应用层面的扩展开发，遵循Egg.js的约束规范开发者有开发Egg.js的开发经验可以直接上手

## 主要特性
* 对Egg.js的路由进行了应用层开发扩展，直接在后台可以设置路由并且生产菜单和权限，开发者无需在配置文件手动配置。
* 对Egg.js的模型进行了应用层开发扩展，直接在后台可以添加模型会自动动生产实体模型文件，包括字段，所以，关联查询等
* 集成GraphQL ，根据模型会自动生成GraphQL的增删改查，方便Api调用。
* 后台使用amis，amis 是一个低代码前端框架，它使用 JSON 配置来生成页面，可以减少页面开发工作量，极大提升效率。不懂前端的后台开发人员也能轻松开发复杂的后台页面。
* 集成 主流的对象储存接口，目前支持七牛，阿里云，腾讯云，华为云，后台配置好就可以使用

## 二开版本说明
基于原版本，增加功能如：
* 支持将项目打包成可执行文件运行，支持mac，linux，windows。
* 附件功能
* 专题功能
* 表单功能
* 签到墙抽奖活动功能
* 稿件内容支持直接配置成amis
* 模型数据导出和同步
* 配置可动态修改
* 微信、短信登录
* 应用插件化，支持应用导入导出
* 将amis升级到6.11.0
  
修复bug如：
* 修复模板过滤器内存无限泄露问题
* 修复graphql:mc接口权限bug
* 修复模型生成问题
* 还修复了很多问题，就不在此列举了
  
此二开版本完全遵守原作者所有版权和开源协议，如有任何侵权，请联系我(QQ:271628543)删除。
如需要此项目上的帮助，同样可联系我。

# 启动说明
git clone 到本地后，进入项目根目录
### 安装数据库
/config/sequelize.js
```bash
{
  dialect: 'mysql',
  host: '127.0.0.1',
  port: 3306,
  database: 'cmswing2',
  username: 'root',
  password: '123456',
}
```
修改成你自己的数据库，先创建数据库cmswing2，导入/init_model.sql文件，然后把数据库配置文件的信息修改成你实际的数据库信息。

### 安装redis

/config/config.default.js
```bash
{
    driver: redisStore,
    host: '127.0.0.1',
    port: 6379,
    password: '',
    db: 0,
    ttl: 0,
    valid: _ => _ !== null,
}
```
然后把配置文件redis的信息修改成你实际的信息。

### 启动项目

```bash
$ npm i
$ npm run dev
$ open http://localhost:7001/
```

### 打包项目

```bash
$ npm i -g pkg
$ npm run pkg
```

### 后台登录

> 后台地址：http://localhost:7001/admin  
> 账号：admin  
> 密码：123456  

# 技术栈
### [web技术](https://developer.mozilla.org/zh-CN/docs/Web/Guide)
web技术是指通过 javaScript，HTML，css 来构建web应用的技术，mdn 提供了相关方便的文档来帮我们学习这些知识。

### [Node.js 基础开发环境](https://nodejs.org/zh-cn/)
Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行时，Node.js 的出现极大的推动了 javascript 的工程化。Node.js 已经是当前前端开发的基础环境，也是任何工作流开始的地方。

### [Egg.js](https://www.eggjs.org/zh-CN)
Egg.js 为企业级框架和应用而生，我们希望由 Egg.js 孕育出更多上层框架，帮助开发团队和开发人员降低开发和维护成本。CmsWing 基于Egg.js 所以使用CmsWing 开发前请先学习Egg.js!

### [Sequelize](https://www.sequelize.cn/)
Sequelize 是一个基于 promise 的 Node.js ORM, 目前支持 Postgres, MySQL, MariaDB, SQLite 以及 Microsoft SQL Server. 它具有强大的事务支持, 关联关系, 预读和延迟加载,读取复制等功能

### [GraphQL](https://graphql.cn/)
GraphQL 既是一种用于 API 的查询语言也是一个满足你数据查询的运行时。 GraphQL 对你的 API 中的数据提供了一套易于理解的完整描述，使得客户端能够准确地获得它需要的数据，而且没有任何冗余，也让 API 更容易地随着时间推移而演进，还能用于构建强大的开发者工具。

### [amis-6.11.0](https://aisuda.bce.baidu.com/amis/zh-CN/docs/index)
amis 是一个低代码前端框架，它使用 JSON 配置来生成页面，可以减少页面开发工作量，极大提升效率。CmsWing后台页面使用它构建，非常好用特别适合后台开发人员。

### [Bootstrap](https://v5.bootcss.com/)
Bootstrap 是全球最流行的前端开源工具包，它支持 Sass 变量和 mixins、响应式网格系统、大量的预建组件和强大的 JavaScript 插件，助你快速设计和自定义响应式、移动设备优先的站点。为了SEO CmsWing cms的前台页面使用它构建。

##### 默认模板前端技术栈
> jQuery v3.6.0  
> js-cookie v3.0.1  
> Bootstrap v5.1.3  
> Jarallax v1.12.8  
> Sortable v1.10.2  
> typed.js v2.0.12  
> slimScroll v1.3.8  
> Nestable jQuery Plugin  