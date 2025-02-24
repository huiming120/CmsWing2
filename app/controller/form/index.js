'use strict';
const Controller = require('../../core/base_controller');
const { Op } = require('sequelize');
const moment = require('moment');

/**
* @controller 表单功能
*/
class FormController extends Controller {
    constructor(ctx) {
		super(ctx);
        if (!ctx.userInfo) {
            ctx.userInfo = ctx.helper.deToken(ctx.session.mcToken);
        }
	}

    /**
     * @summary 表单前端页面
     * @description 表单前端页面
     * @router get /form/index
     * @request query int id 表单活动id
     * @response 200 baseRes desc
     */
    async index() {
        const { ctx } = this;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 },
                did: { type: 'int', required: false, min: 1 },
            }, ctx.query);
        } catch (error) {
            return this.notFound(JSON.stringify(error.errors[0]));
        }
        const { id, did } = ctx.query;
        const formInfo = await ctx.model.Form.findByPk(id);
        if (!formInfo) {
            return this.notFound('活动不存在');
        }
        // 活动时间
        if (formInfo.config.open_in_active_only) {
            let nowTime = Date.now()
            let sTime = new Date(formInfo.begin_at)
            let eTime = new Date(formInfo.end_at)
            if (nowTime < sTime || nowTime > eTime) {
                return this.notFound();
            }
        }
        const renderData = { formInfo };
        if (did) {
            if (!formInfo.config.can_edit) {
                return this.notFound('信息不存在');
            }
            let member_uuid = '';
            switch (formInfo.config.login_type) {
                case 0:
                    // 不限制登录
                    return this.notFound('信息不存在');
                case 1:
                    // 微信登录
                    if (!await ctx.service.mc.wxauth.checkLogin(false)) {
                        return this.fail('请先登录', 4001);
                    }
                    member_uuid = ctx.wxUserInfo.openid;
                    break;
                case 2:
                    // 账号登录
                    if (!ctx.userInfo) {
                        return this.fail('请先登录', 4002);
                    }
                    member_uuid = ctx.userInfo.uuid;
                    break;
            }
            const formDataInfo = await ctx.model.FormData.findOne({ where: { id: did, form_id: id, member_uuid } });
            if (!formDataInfo) {
                return this.notFound('信息不存在');
            }
            if (formDataInfo.status > 0) {
                return this.notFound('此信息已被官方确认,无法再修改,如有疑问请联系官方');
            }
            renderData.formDataInfo = formDataInfo;
        }
        if (formInfo.temp) {
            const templatePath = await ctx.service.cms.web.cmsTemplatePath();
            await ctx.render(`cms/${templatePath}/${formInfo.temp}`, renderData);
        } else {
            await ctx.render('form/index', renderData);
        }
    }

    /**
     * @summary 提交数据
     * @description 提交数据
     * @router post /form/submit
     * @request body form_data_add *body
     * @response 200 baseRes desc
     */
    async submit() {
        const { ctx } = this, data = ctx.request.body;
        try {
            ctx.validate({
                form_id: { type: 'int', required: true, min: 1 },
                id: { type: 'int', required: false, default: 0 },
            }, data.presets_info);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { presets_info: { form_id, id } } = data;
        if (!form_id) {
            return this.fail('活动不存在');
        }
        const formInfo = await ctx.model.Form.findByPk(form_id);
        if (!formInfo) {
            return this.fail('活动不存在');
        }
        // 活动时间
        let nowTime = Date.now()
        let sTime = new Date(formInfo.begin_at)
        let eTime = new Date(formInfo.end_at)
        if (nowTime < sTime) {
            return this.fail('活动未开始')
        } else if (nowTime > eTime) {
            return this.fail('活动已结束')
        }
        // 检查是否需要登录
        let member_uuid = ctx.userInfo ? ctx.userInfo.uuid : '0000000000000000000000000000', member_name = ctx.userInfo ? ctx.userInfo.username :  '游客';
        let limitFieldName = 'member_uuid', limitFieldValue = '';
        switch (formInfo.config.login_type) {
            case 0:
                // 不限制登录
                limitFieldName = 'ip';
                limitFieldValue = ctx.ip;
                break;
            case 1:
                // 微信登录
                if (!await ctx.service.mc.wxauth.checkLogin(false)) {
                    return this.fail('请先登录', 4001);
                }
                member_uuid = ctx.wxUserInfo.openid;
                member_name = ctx.wxUserInfo.nickname;
                limitFieldValue = member_uuid;
                break;
            case 2:
                // 账号登录
                if (!ctx.userInfo) {
                    return this.fail('请先登录', 4002);
                }
                if (formInfo.config.bind_mobile && !ctx.userInfo.mobile) {
                    return this.fail('请先绑定手机号', 4021);
                }
                if (formInfo.config.bind_email && !ctx.userInfo.email) {
                    return this.fail('请先绑定邮箱', 4022);
                }
                if (formInfo.config.bind_wechat && (!ctx.userInfo.third || !ctx.userInfo.third.wechat || !ctx.userInfo.third.wechat.openid)) {
                    return this.fail('请先绑定微信', 4024);
                }
                limitFieldValue = member_uuid;
                break;
        }
        const dataDB = ctx.model.FormData;
        if (id <= 0) {
            // 检查提交次数(只有新增才检查)
            const curmoment = moment();
            if (formInfo.config.limit_day > 0) {
                let datebegin = curmoment.startOf('day').format('YYYY-MM-DD HH:mm:ss');
                let dateend = curmoment.endOf('day').format('YYYY-MM-DD HH:mm:ss');
                let times = await dataDB.count({ where: { form_id, [limitFieldName]: limitFieldValue, createdAt: { [Op.between]: [datebegin, dateend] } } });
                if (times >= formInfo.config.limit_day) {
                    return this.fail('您今天的参与次数已用完了')
                }
            }
            if (formInfo.config.limit_week > 0) {
                let weekbegin = curmoment.startOf('week').format('YYYY-MM-DD HH:mm:ss');
                let weekend = curmoment.endOf('week').format('YYYY-MM-DD HH:mm:ss');
                let times = await dataDB.count({ where: { form_id, [limitFieldName]: limitFieldValue, createdAt: { [Op.between]: [weekbegin, weekend] } } });
                if (times >= formInfo.config.limit_week) {
                    return this.fail('您本周的参与次数已用完了')
                }
            }
            if (formInfo.config.limit_month > 0) {
                let monthbegin = curmoment.startOf('month').format('YYYY-MM-DD HH:mm:ss');
                let monthend = curmoment.endOf('month').format('YYYY-MM-DD HH:mm:ss');
                let times = await dataDB.count({ where: { form_id, [limitFieldName]: limitFieldValue, createdAt: { [Op.between]: [monthbegin, monthend] } } });
                if (times >= formInfo.config.limit_month) {
                    return this.fail('您本月的参与次数已用完了')
                }
            }
            if (formInfo.config.limit_total > 0) {
                let times = await dataDB.count({ where: { form_id, [limitFieldName]: limitFieldValue } });
                if (times >= formInfo.config.limit_total) {
                    return this.fail('您的参与次数已用完了')
                }
            }
        } else {
            // 如果是修改,检查是否有数据
            if (formInfo.config.login_type == 0 || !formInfo.config.can_edit) {
                return this.fail('此条信息不能再修改');
            }
            const formDataInfo = await dataDB.findOne({ where: { id, form_id, member_uuid } });
            if (!formDataInfo) {
                return this.fail('数据不存在');
            }
            if (formDataInfo.status != 0) {
                return this.fail('此信息已被官方确认,无法再修改,如有疑问请联系官方')
            }
        }
        // 图形验证码验证
        if (formInfo.config.need_verification && data.form_verification != ctx.session.captcha) {
            return this.fail('图形验证码错误');
        }
        const rule = {}, creatData = {};
        for (const field of formInfo.fields) {
            const ruleItem = { required: field.required };
            switch (field.type) {
                case 'number':
                    {
                        if (!field.required && data[field.name] == '') {
                            delete data[field.name];
                            continue;
                        }
                        const max = parseInt(field.max), min = parseInt(field.min), precision = parseInt(field.precision);
                        if (!isNaN(max)) {
                            ruleItem.max = max;
                        }
                        if (!isNaN(min)) {
                            ruleItem.min = min;
                        }
                        if (!isNaN(precision) && precision > 0) {
                            ruleItem.type = 'number';
                        } else {
                            ruleItem.type = 'int';
                        }
                        break;
                    }
                case 'mobile':
                    ruleItem.type = field.type;
                    if (field.verification) {
                        // 验证码
                        const code = data[field.name + '_code'];
                        const oldCode = await ctx.app.cache.get('sms_code_' + data[field.name]);
                        if (!code || !oldCode || oldCode !== code) {
                            return this.fail('验证码错误', 21);
                        }
                        creatData[field.name + '_code'] = code;
                        ctx.app.cache.del('sms_code_' + data[field.name]);
                    }
                    break;
                case 'date':
                case 'dateTime':
                    if (!field.required && data[field.name] == '') {
                        delete data[field.name];
                        continue;
                    }
                    ruleItem.type = field.type;
                    break;
                case 'editor':
                case 'string':
                    {
                        ruleItem.type = 'string';
                        ruleItem.trim = true;
                        const max = parseInt(field.max), min = parseInt(field.min);
                        if (!isNaN(max)) {
                            ruleItem.max = max;
                        }
                        if (!isNaN(min)) {
                            ruleItem.min = min;
                        }
                        break;
                    }
                case 'upload':
                case 'image':
                    {
                        ruleItem.type = 'array';
                        ruleItem.itemType = 'string';
                        const max = parseInt(field.max), min = parseInt(field.min)
                        if (!isNaN(max)) {
                            ruleItem.max = max;
                        }
                        if (!isNaN(min)) {
                            ruleItem.min = min;
                        }
                        break;
                    }
                case 'radios':
                case 'selectS':
                    ruleItem.type = 'int';
                    break;
                case 'checkboxes':
                case 'selectM':
                    ruleItem.type = 'array';
                    ruleItem.itemType = 'int';
                    break;
                default:
                    ruleItem.type = field.type;
                    break;
            }
            rule[field.name] = ruleItem;
            creatData[field.name] = data[field.name];
        };
        try {
            ctx.validate(rule, data);
        } catch (error) {
            const firstErr = error.errors[0]
            return this.fail(`${firstErr.field} ${firstErr.message}`, 1001);
        }
        if (id > 0) {
            await dataDB.update({ data: creatData }, { where: { id } });
            return this.success();
        } else {
            const formDataInfo = await dataDB.create({ form_id, data: creatData, member_uuid, member_name, ip: ctx.ip });
            return this.success(formDataInfo.id);
        }
    }

    /**
     * @summary 个人提交数据列表
     * @description 个人提交数据列表
     * @router get /form/list
     * @request query int id 表单活动id
     * @response 200 baseRes desc
     */
    async list() {
        const { ctx } = this;
        try {
            ctx.validate({
                form_id: { type: 'int', required: true, min: 1 },
                page: { type: 'int', required: false, min: 1, default: 1 },
                perPage: { type: 'int', required: false, min: 1, default: 10 }
            }, ctx.query);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { form_id, page, perPage } = ctx.query;
        const formInfo = await ctx.model.Form.findByPk(form_id, { attributes: ['id', 'title', 'begin_at', 'end_at', 'config'] });
        if (!formInfo) {
            return this.notFound('活动不存在');
        }
        let member_uuid;
        switch (formInfo.config.login_type) {
            case 0:
                // 不限制登录
                return this.notFound('活动不存在');
            case 1:
                // 微信登录
                if (!await ctx.service.mc.wxauth.checkLogin()) {
                    return this.notFound('请先登录');
                }
                member_uuid = ctx.wxUserInfo.openid;
                break;
            case 2:
                // 账号登录
                if (!ctx.userInfo) {
                    return ctx.redirect('/mc/login?retUrl=' + encodeURIComponent(ctx.url));  
                }
                member_uuid = ctx.userInfo.uuid;
                break;
        }
        const dataList = await ctx.model.FormData.findAndCountAll({
            // order: [['id', 'DESC']],
            offset: (page - 1) * perPage,
            limit: perPage,
            where: { form_id, member_uuid },
            attributes: { exclude: ['updatedAt', 'ip'] }
        });
        let columns = await this.app.cache.get(`form:${form_id}:columns`);
        if (!columns) {
            columns = ctx.service.sys.generate.amisColumns(formInfo);
            await this.app.cache.set(`form:${form_id}:columns`, columns);
        }
        if (ctx.request.accepts(['json', 'html']) === 'html') {
            await ctx.render('form/list', { formInfo, dataList, columns });
        } else {
            return this.success(dataList);
        }
    }

    /**
     * @summary 删除数据
     * @description 删除数据
     * @router post /form/del
     * @request body form_data_item
     * @response 200 baseRes desc
     */
    async del() {
        const { ctx } = this;
        try {
            ctx.validate({
                form_id: { type: 'int', required: true, min: 1 },
                id: { type: 'int', required: true, min: 1 },
            }, ctx.request.body);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { form_id, id } = ctx.request.body;
        const formInfo = await ctx.model.Form.findByPk(form_id);
        if (!formInfo) {
            return this.fail('活动不存在');
        }
        // 活动时间
        let nowTime = Date.now()
        let sTime = new Date(formInfo.begin_at)
        let eTime = new Date(formInfo.end_at)
        if (nowTime < sTime) {
            return this.fail('活动未开始')
        } else if (nowTime > eTime) {
            return this.fail('活动已结束')
        }
        // 检查是否需要登录
        let member_uuid = '';
        switch (formInfo.config.login_type) {
            case 0:
                // 不限制登录
                return this.fail('数据不存在');
            case 1:
                // 微信登录
                if (!await ctx.service.mc.wxauth.checkLogin(false)) {
                    return this.fail('请先登录', 4001);
                }
                member_uuid = ctx.wxUserInfo.openid;
                break;
            case 2:
                // 账号登录
                if (!ctx.userInfo) {
                    return this.fail('请先登录', 4002);
                }
                member_uuid = ctx.userInfo.uuid;
                break;
        }
        const formDataInfo = await ctx.model.FormData.findOne({ where: { id, form_id, member_uuid } });
        if (!formDataInfo) {
            return this.fail('数据不存在');
        }
        if (formDataInfo.status != 0) {
            return this.fail('数据已被编辑，不能再删除，如有问题请联系工作人员！');
        }
        await formDataInfo.destroy();
        return this.success();
    }
}
module.exports = FormController;