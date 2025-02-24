const fs = require('fs-extra');
const _ = require('lodash');
const helper = require('./app/extend/helper');
const { Op } = require('sequelize');
const { isJSON, isIP, isMobilePhone } = require('validator');
class AppBootHook {
    constructor(app) {
        this.app = app;
    }
    configWillLoad() {
        // 此时 config 文件已经被读取并合并，但是还并未生效
        // 这是应用层修改配置的最后时机
        // 注意：此函数只支持同步调用

        // 加载远程配置(参考于：egg-remote-config插件,因需要加密,所以不直接用插件),直接读取agent.js保存的本地文件
        try {
            const res = fs.readFileSync(this.app.config.remoteConfigFile);
            const result = JSON.parse(helper.decipher(res.toString()));
            _.merge(this.app.config, result);
        } catch (err) { }
    }
    async willReady() {
        // 所有插件已启动完毕，但应用整体尚未 ready
        // 可进行数据初始化等操作，这些操作成功后才启动应用
        console.log('app will ready');
        const app = this.app, { nunjucks, Sequelize } = app;
        // cms模板路径 {{'cms'|@template('path')}}
        nunjucks.addFilter('@template', async (m, n, callback) => {
            let res = '';
            if (m === 'cms') {
                const temp = await this.app.cache.get('templateInfo');
                if (n === 'path') {
                    res = `${temp.path}-${temp.uuid}`;
                } else {
                    res = temp[n] ? temp[n] : '';
                }
            }
            callback(null, res);
        }, true);
        // findOne {{'mdoel'|@findOne('{where:{a:1}}')}}
        nunjucks.addFilter('@findOne', async (model, map, ctx, callback) => {
            try {
                const modelName = _.upperFirst(_.camelCase(model));
                // Sequelize.where(Sequelize.fn('FIND_IN_SET', v, Sequelize.col('position')), '>', 0)
                if (map.where) {
                    for (const key in map.where) {
                        if (Object.hasOwnProperty.call(map.where, key)) {
                            if (key === 'FIND_IN_SET') {
                                map.where.op_and = [];
                                map.where.op_and.push(Sequelize.where(Sequelize.fn('FIND_IN_SET', map.where.FIND_IN_SET[1], Sequelize.col(map.where.FIND_IN_SET[0])), '>', 0));
                                delete map.where.FIND_IN_SET;
                            }
                        }
                    }
                }
                map.raw = true;
                const res = await app.model[modelName].findOne(map);
                callback(null, res);
            } catch (error) {
                callback(null, {});
            }
        }, true);
        // findAll {{'mdoel'|@findAll('{where:{a:1}}')}}
        nunjucks.addFilter('@findAll', async (model, map, ctx, callback) => {
            try {
                const modelName = _.upperFirst(_.camelCase(model));
                if (map.where) {
                    for (const key in map.where) {
                        if (Object.hasOwnProperty.call(map.where, key)) {
                            if (key === 'FIND_IN_SET') {
                                map.where.op_and = [];
                                map.where.op_and.push(Sequelize.where(Sequelize.fn('FIND_IN_SET', map.where.FIND_IN_SET[1], Sequelize.col(map.where.FIND_IN_SET[0])), '>', 0));
                                delete map.where.FIND_IN_SET;
                            }
                        }
                    }
                }
                map.raw = true;
                const res = await app.model[modelName].findAll(map);
                callback(null, res);
            } catch (error) {
                callback(null, []);
            }
        }, true);
        // 系统导航标签 {{'header'|@navigation}} header/footer
        nunjucks.addFilter('@navigation', async (m = 'header', ctx, callback) => {
            const tree = await app.cache.get('navigation:' + m);
            callback(null, tree);
        }, true);
        // mc 菜单 {{ctx.userInfo.uuid|@mc_menu}}
        nunjucks.addFilter('@mc_menu', async (uuid, ctx, callback) => {
            const map = {};
            map.order = [['sort', 'ASC']];
            map.where = { is_menu: true, class_uuid: '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9' };
            const ml = (await app.model.SysRoutes.findAll(map)).map(item => item.toJSON());
            const tree = helper.arr_to_tree(ml, '0', 'uuid', 'puuid');
            callback(null, tree);
        }, true);
        // 分类标签 {{'cid'|@classify(type)}}
        // type等于 top 获取当前栏目最顶级父栏目下所有的子栏目
        // type等于 sub 获取当前栏目的子分类
        nunjucks.addFilter('@classify', async (cid, type, ctx, callback) => {
            if (type === 'top') {
                const topid = await ctx.service.cms.classify.getTopId(cid);
                const ids = await ctx.service.cms.classify.getSubClassifyIds(topid);
                const classifyList = (await ctx.model.CmsClassify.findAll({ where: { id: { [Op.in]: ids }, status: true } })).map(item => item.toJSON());
                let topclass = {};
                for (const v of classifyList) {
                    v.url = `/cms/list/${v.name ? v.name : v.id}.html`;
                    if (v.id === topid) {
                        v.title = '全部分类';
                        topclass = v;
                    }
                }
                const tree = ctx.helper.arr_to_tree(classifyList, topid);
                callback(null, tree.length > 0 ? [topclass, ...tree] : null);
            } else if (type === 'sub') {
                const { sub } = ctx.query;
                const subobj = {};
                if (sub) {
                    const str = sub.split('|');
                    for (const v of str) {
                        const strarr = v.split('-');
                        subobj[strarr[0]] = strarr[1].split(',');
                    }
                }
                const classify = await ctx.model.CmsClassify.findOne({ where: { id: cid } });
                const res = [];
                if (classify.sub) {
                    const sub = JSON.parse(classify.sub);
                    for (const v of sub) {
                        const obj = {};
                        obj.label = v.label;
                        obj.url = `/cms/list/${classify.name ? classify.name : classify.id}.html`;
                        obj.name = `${v.name}${classify.id}`;
                        obj.type = v.type;
                        obj.options = [];
                        for (const key in v.options) {
                            const o = {};
                            o.label = key;
                            o.value = v.options[key];
                            o.check = subobj[obj.name] ? subobj[obj.name].includes(v.options[key]) : false;
                            obj.options.push(o);
                        }
                        res.push(obj);
                    }
                }
                callback(null, res);
            }
        }, true);
        // 缓存 {{'templateInfo'|@cache}}
        nunjucks.addFilter('@cache', async (key, callback) => {
            const res = await this.app.cache.get(key)
            callback(null, res);
        }, true);

        // 添加校验规则
        app.validator.addRule('json', (rule, value) => {
            if (!isJSON(value)) {
                return '必须是 JSON 字符串';
            }
        });
        app.validator.addRule('ip', (rule, value) => {
            if (!isIP(value, 4)) {
                return 'ip格式错误';
            }
        });
        app.validator.addRule('mobile', (rule, value) => {
            if (!isMobilePhone(value, 'zh-CN')) {
                return '手机号格式错误';
            }
        });
        app.validator.addRule('idCard', (rule, value) => {
            const regex = /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[0-9Xx]$/;
            if (!regex.test(value)) {
                return '身份证号格式错误';
            }
            const factors = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
            const parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
            let sum = 0;
            for (let i = 0; i < 17; i++) {
                sum += parseInt(value.charAt(i), 10) * factors[i];
            }
            const lastDigit = value.charAt(17).toUpperCase();
            if (lastDigit != parity[sum % 11]) {
                return '身份证号格式错误';
            }
        });
    }
    async didReady() {
        // 所有的配置已经加载完毕
        // 可以用来加载应用自定义的文件，启动自定义的服务
        console.log('app ready');
        const app = this.app;
        /*
        app.on('request', (ctx) => {
            // 记录收到的请求
            console.log('收到请求')
        })
        app.on('response', (ctx) => {
            // ctx.starttime 是由框架设置的
            const used = Date.now() - ctx.starttime;
            // 记录请求总耗时
            console.log('请求用时:', used, ctx.path, ctx.method)
        })
        //*/

        // 动态刷新配置
        app.messenger.on('reload-config', async (data) => {
            const { name } = data;
            // const ctx = app.createAnonymousContext();
            const cfg = await app.model.SysConfig.findOne({ where: { name } });
            if (name === 'egg') {
                _.merge(app.config, cfg.value);
            } else {
                _.merge(app.config, { [name]: cfg.value });
            }
        })

        // 清除模板引擎缓存
        app.messenger.on('clear-nunjucks-cache', () => {
            app.nunjucks.cleanCache();
        })
    }

    async serverDidReady() {
        console.log('egg-ready on app');

        // 一些必要信息进缓存
        const temp = await this.app.cache.get('templateInfo');
        if (!temp) {
            const ctx = this.app.createAnonymousContext()
            const cacheService = ctx.service.sys.cache
            cacheService.reloadAll()
        }
    }

    async beforeClose() {
        // 请将你的 app.beforeClose 中的代码置于此处
        this.app.logger.info('app close');
    }
}
module.exports = AppBootHook;