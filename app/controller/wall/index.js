'use strict';
const Controller = require('../../core/base_controller');

/**
* @controller 签到墙活动
*/
class WallController extends Controller {
    /**
     * @summary 表单前端页面
     * @description 表单前端页面
     * @router get /wall/index
     * @request query int id 表单活动id
     * @response 200 baseRes desc
     */
    async index() {
        const { ctx } = this;
        if (!await ctx.service.mc.wxauth.checkLogin()) {
            return this.fail('请先登录', 4001);
        }
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 }
            }, ctx.query);
        } catch (error) {
            return this.notFound(JSON.stringify(error.errors[0]));
        }
        const { id } = ctx.query;
        const wallInfo = await ctx.model.Wall.findByPk(id);
        if (!wallInfo) {
            return this.notFound('活动不存在');
        }
        const { open_in_active_only, qd_begin_at, cj_begin_at, qd_end_at, cj_end_at, qd_temp } = wallInfo.config;
        // 活动时间
        if (open_in_active_only) {
            let nowTime = Date.now();
            let sTime = Math.min(new Date(qd_begin_at), new Date(cj_begin_at));
            let eTime = Math.min(new Date(qd_end_at), new Date(cj_end_at));
            if (nowTime < sTime || nowTime > eTime) {
                return this.notFound();
            }
        }
        const signInfo = await ctx.model.WallQdData.findOne({ where: { wall_id: id, openid: ctx.wxUserInfo.openid } });
        if (qd_temp) {
            const templatePath = await ctx.service.cms.web.cmsTemplatePath();
            await ctx.render(`cms/${templatePath}/${qd_temp}`, { wallInfo, signInfo });
        } else {
            await ctx.render('wall/qd', { wallInfo, signInfo });
        }
    }
    /**
     * @summary 签到接口
     * @description 用户提交数据签到
     * @router post /wall/sign
     * @request body wall_qd_data_add *body
     * @response 200 baseRes desc
     */
    async sign() {
        const { ctx } = this;
        if (!await ctx.service.mc.wxauth.checkLogin()) {
            return this.fail('请先登录', 4001);
        }
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 },
                data: { type: 'object', required: true, rule: {
                    name: { type: 'string', required: true },
                    mobile: { type: 'mobile', required: true, trim: true, max: 50 },
                } }
            }, ctx.request.body);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { id, data } = ctx.request.body;
        const wallInfo = await ctx.model.Wall.findByPk(id);
        if (!wallInfo) {
            return this.notFound('活动不存在');
        }
        // 检查是否有参与资格
        const openIds = await ctx.app.cache.get('wall:openIds_' + id);
        if (openIds && openIds.indexOf(ctx.wxUserInfo.openid) == -1) {
            return this.notFound('活动不存在');
        }
        const signInfo = await ctx.model.WallQdData.findOne({ where: { wall_id: id, openid: ctx.wxUserInfo.openid } });
        if (signInfo) {
            return this.fail('您已经签到过了', 21);
        } else {
            const nowTime = Date.now();
            const sTime = new Date(wallInfo.config.qd_begin_at), eTime = new Date(wallInfo.config.qd_end_at);
            if (nowTime < sTime || nowTime > eTime) {
                return this.fail('不在活动期间内', 22);
            }
            if (wallInfo.config.verification) {
                // 需要验证短信
                const code = data.verification;
                const oldCode = await ctx.app.cache.get('sms_code_' + data.mobile);
                if (!code || !oldCode || oldCode !== code) {
                    return this.fail('验证码错误');
                }
                ctx.app.cache.del('sms_code_' + data[field.name]);
                delete data.verification;
            }
            data.nickname = ctx.wxUserInfo.nickname;
            data.headimgurl = ctx.wxUserInfo.headimgurl;
            await ctx.model.WallQdData.create({ wall_id: id, openid: ctx.wxUserInfo.openid, data });
            return this.success();
        }
    }
}
module.exports = WallController;