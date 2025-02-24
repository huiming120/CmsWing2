/* eslint valid-jsdoc: "off" */

'use strict';
/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
const path = require('path');
const redisStore = require('cache-manager-ioredis');
module.exports = appInfo => {
	// console.log(appInfo.baseDir)
    const exeDir = process.cwd()
	const config = exports = {};
    config.session = {
		key: 'CMSWING_SESS',
		httpOnly: true,
		encrypt: true,
		maxAge: 24 * 60 * 60 * 1000,
        renew: true,    // 如session剩余有效期少于半时，重置有效期
	};
	// 运行配置文件导出路径
    config.rundir = path.join(exeDir, 'run');
    // 未发布附件上传文件夹路径
    config.privateUploadDir = path.join(exeDir, 'upload');
    // 远程配置保存本地文件路径
    config.remoteConfigFile = path.join(config.rundir, 'remote_config');
	// 静态资源配置
    config.static = {
        prefix: '/public/',
        dir: path.join(exeDir, 'public')
    }
	// 中间件
	config.middleware = ['graphql', 'authAdminTokenConmon'];
    // 文件上传,此配置已放到后台动态配置中,这里的配置会被覆盖
	config.multipart = {
		mode: 'file',
	};
    // graphql配置
	config.graphql = {
		router: '/graphql-dev',
		// 是否加载到 app 上，默认开启
		app: true,
		// 是否加载到 agent 上，默认关闭
		agent: false,
		// 是否加载开发者工具 graphiql, 默认开启。路由同 router 字段。使用浏览器打开该可见。
		graphiql: true,
		// 是否设置默认的Query和Mutation, 默认关闭
		defaultEmptySchema: false,
		// graphQL 路由前的拦截器
		async onPreGraphQL(ctx) { // console.log(ctx); return { a: 1 };
			const userInfo = ctx.helper.deToken(ctx.session.adminToken);
			if (!userInfo || !userInfo?.admin) {
				throw new Error('response status is not 200');
			}
		},
		// 开发工具 graphiQL 路由前的拦截器，建议用于做权限操作(如只提供开发者使用)
		async onPreGraphiQL(ctx) {
			const userInfo = ctx.helper.deToken(ctx.session.adminToken);
			if (!userInfo || !userInfo?.admin) {
				ctx.redirect('/admin/login');
			}
		},
		// apollo server的透传参数，参考[文档](https://www.apollographql.com/docs/apollo-server/api/apollo-server/#parameters)
		// apolloServerOptions: {
		//   rootValue,
		//   formatError,
		//   formatResponse,
		//   mocks,
		//   schemaDirectives,
		//   introspection,
		//   playground,
		//   debug,
		//   validationRules,
		//   tracing,
		//   cacheControl,
		//   subscriptions,
		//   engine,
		//   persistedQueries,
		//   cors,
		// },
	};
    //* swagger相关接口增加权限验证
    config.authAdminTokenConmon = {
        match: /^\/swagger/,
        // enable: false
    };
    //*/
    /* 微信公众号网页授权配置(已放入数据库配置)
    config.wxauth = {
        appid: '公众号appid',
        appsecret: '公众号appsecret'
    };
    //*/
    // 模板渲染配置
	config.view = {
		root: [path.join(exeDir, 'view'), path.join(appInfo.baseDir, 'app/view')].join(','),
		defaultViewEngine: 'nunjucks',
		defaultExtension: '.html'
	};
    // 安全配置
	config.security = {
		csrf: {
			enable: false,
		},
	};
    // 缓存配置
    config.cache = {
        default: 'redis',
        stores: {
            memory: {
                driver: 'memory',
                max: 100,
                ttl: 0
            },
            redis: { // full config: https://github.com/dabroek/node-cache-manager-ioredis#single-store
                driver: redisStore,
                host: '127.0.0.1',
                port: 6379,
                password: '',
                db: 0,
                ttl: 0,
                valid: _ => _ !== null,
            }
        },
    };
    // 接口参数校验配置
    config.validate = {
        convert: true,
        validateRoot: true
    };
    /* 邮件配置(使用的qq邮箱服务,其他邮箱配置参考nodemailer包官方文档,已放入数据库配置)
    config.nodemailer = {
        enable: false,
        service: 'qq',
        auth: {
            user: '邮箱服务账号',
            pass: '邮箱服务授权码' //授权码,通过QQ获取  
        }
    };
    //*/
    /* 手机短信配置(已放入数据库配置)
    config.sms = {
        enable: false,
        SignName: '测试',   // 通用短信签名
        TemplateCode: '通用短信模板id',  // 通用短信模板id
        accessKeyId: '短信accessKeyId',
        secretAccessKey: '短信secretAccessKey'
    };
    //*/
    // swagger接口文档配置
	config.swaggerdoc = require('./swagger');
    // 数据库配置
	config.sequelize = require('./sequelize');
	// 用户配置(暂时没用)
	const userConfig = {
		// myAppName: 'egg',
	};
    // 开发文件修改检测刷新配置
	config.development = {
        watchDirs: ['app/controller', 'app/service'],
        // ignoreDirs: ['app/pages', 'app/graphql'],
		overrideDefault: true,
		reloadOnDebug: false
	}
	return {
		...config,
		...userConfig,
	};
};
