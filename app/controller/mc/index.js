/* eslint-disable jsdoc/check-tag-names */
'use strict';
const Controller = require('../../core/base_controller');
const { isMobilePhone, isEmail } = require('validator');
/**
* @controller MC会员中心入口
*/
class IndexController extends Controller {
	async index() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
		ctx.meta_title = '会员中心';
        const templatePath = await ctx.service.cms.web.cmsTemplatePath();
		await ctx.render(`cms/${templatePath}/mc_index`);
	}
	/**
	* @summary MC登录页面
	* @description MC登录页面
	* @router get /mc/login
	* @response 200 baseRes desc
	*/
	async login() {
        if (!this.config.cms.openLogin && ctx.query.onlyWechat != 1) {
            return this.notFound();
        }
		const { ctx } = this, Sequelize = this.app.Sequelize;
        const templatePath = await ctx.service.cms.web.cmsTemplatePath();
        if (ctx.request.accepts(['json', 'html']) === 'html') {
            const retUrl = ctx.query.retUrl || '/'
            if (ctx.query.loginType == 'wechat' && !await ctx.service.mc.wxauth.checkLogin()) {
                return await ctx.render(`cms/${templatePath}/mc_login_view`);
            }
            let token = ctx.session.mcToken || ctx.get('mcToken');
		    let userInfo = ctx.helper.deToken(token);
            if (userInfo) {
                return ctx.redirect(decodeURIComponent(retUrl));
            }
            if (ctx.query.loginType == 'wechat') {
                if (ctx.query.onlyWechat == 1) {
                    return ctx.redirect(decodeURIComponent(retUrl));
                }
                userInfo = await ctx.model.McMember.findOne({ 
                    where: Sequelize.where(
                        Sequelize.fn('json_extract', Sequelize.col('third'), Sequelize.literal(`'$.wechat.openid'`)),
                        ctx.wxUserInfo.openid
                    )
                })
                if (userInfo) {
                    if (userInfo.state) {
                        token = ctx.helper.generateToken(userInfo);
                        ctx.session.mcToken = token;
                        // 如果绑定了管理员账号,登录管理员
                        if (userInfo.sys_user_uuid && !ctx.session.adminToken) {
                            const sysUser = await ctx.model.SysUser.findOne({ where: { uuid: member.sys_user_uuid, state: true } });
                            if (sysUser) {
                                ctx.session.adminToken = ctx.helper.generateToken(sysUser);
                            }
                        }
                        return ctx.redirect(decodeURIComponent(retUrl));
                    } else {
                        return this.notFound('账号被禁用');
                    }
                }
            }
            await ctx.render(`cms/${templatePath}/mc_login_view`);
        } else {
            await ctx.render(`cms/${templatePath}/mc_login_modal`);
        }
	}
	/**
	* @summary 登录接口
	* @description 登录接口
	* @router post /mc/loginPost
	* @request body mc_member_add *body desc
	* @response 200 baseRes desc
	*/
	async lginPost() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
        try {
            ctx.validate({
                username: { type: 'string', required: true, min: 2, max: 40, trim: true, format: /^[a-zA-Z0-9\u4e00-\u9fa5_\-@.+]{2,40}$/ },
                password: { type: 'password', min: 6, max: 20 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('账号密码格式错误');
        }
		let { username, password } = ctx.request.body;
		password = ctx.helper.cipher(password);
        if (isMobilePhone(username, 'zh-CN')) {
            var member = await ctx.model.McMember.findOne({ where: { mobile: username, password } });
        } else if (isEmail(username)) {
            var member = await ctx.model.McMember.findOne({ where: { email: username, password } });
        } else {
            var member = await ctx.model.McMember.findOne({ where: { username, password } });
        }
		if (member) {
            if (member.state == true) {
                /* 绑定微信信息(不直接绑定,防止此微信已绑定过其他账号)
                if (!member.third || !member.third.wechat) {
                    if (await ctx.service.mc.wxauth.checkLogin(false)) {
                        await member.update({ third: member.third ? { ...member.third, wechat: ctx.wxUserInfo } : { wechat: ctx.wxUserInfo }, avatar: ctx.wxUserInfo.headimgurl });
                    }
                }
                //*/
                const token = ctx.helper.generateToken(member);
                // 设置 Session
                ctx.session.mcToken = token;
                // 如果绑定了管理员账号,登录管理员
                if (member.sys_user_uuid && !ctx.session.adminToken) {
                    const sysUser = await ctx.model.SysUser.findOne({ where: { uuid: member.sys_user_uuid, state: true } });
                    if (sysUser) {
                        ctx.session.adminToken = ctx.helper.generateToken(sysUser);
                    }
                }
                // 如果绑定了微信,登录微信
                if (member.third && member.third.wechat && member.third.wechat.openid) {
                    ctx.wxUserInfo = member.third.wechat
                    const wxToken = ctx.helper.generateToken(ctx.wxUserInfo);
                    ctx.session.wxToken = wxToken;
                }
                this.success(null, '登录成功');
            } else {
                this.fail('此账号已被禁用', 21);
            }
		} else {
			this.fail('账号密码错误');
		}
	}
    /**
	* @summary 手机短信登录
	* @description 手机短信登录
	* @router post /mc/loginByMobileCode
    * @request body mc_member_add *body desc
	* @response 200 baseRes desc
	*/
    async loginByMobileCode() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                mobile: 'mobile',
                code: 'string',
            }, ctx.request.body);
        } catch (error) {
            return this.fail('账号密码格式错误');
        }
        const { mobile, code } = ctx.request.body;
        const oldCode = await ctx.app.cache.get('sms_code_' + mobile);
        if (oldCode !== code) {
            return this.fail('验证码错误');
        }
        ctx.app.cache.del('sms_code_' + mobile);
        /* 考虑到可能没开放注册,所以不使用此API
        const [member, created] = await ctx.model.McMember.findOrCreate({
			where: { mobile }, defaults: { mobile }
		});
        //*/
        let member = await ctx.model.McMember.findOne({ where: { mobile } });
        if (!member) {
            if (!this.config.cms.openRegister) {
                return this.fail('用户不存在！');
            }
            member = await ctx.model.McMember.create({ mobile });
        }
        if (member.state == true) {
            /* 绑定微信信息(不直接绑定,防止此微信已绑定过其他账号)
            if (!member.third || !member.third.wechat) {
                if (await ctx.service.mc.wxauth.checkLogin(false)) {
                    await member.update({ third: member.third ? { ...member.third, wechat: ctx.wxUserInfo } : { wechat: ctx.wxUserInfo }, avatar: ctx.wxUserInfo.headimgurl });
                }
            }
            //*/
            const token = ctx.helper.generateToken(member);
            // 设置 Session
            ctx.session.mcToken = token;
            // 如果绑定了管理员账号,登录管理员
            if (member.sys_user_uuid && !ctx.session.adminToken) {
                const sysUser = await ctx.model.SysUser.findOne({ where: { uuid: member.sys_user_uuid, state: true } });
                if (sysUser) {
                    ctx.session.adminToken = ctx.helper.generateToken(sysUser);
                }
            }
            // 如果绑定了微信,登录微信
            if (member.third && member.third.wechat && member.third.wechat.openid) {
                ctx.wxUserInfo = member.third.wechat
                const wxToken = ctx.helper.generateToken(ctx.wxUserInfo);
                ctx.session.wxToken = wxToken;
            }
            this.success(null, '登录成功');
        } else {
            this.fail('此账号已被禁用', 21);
        }
	}
	/**
	* @summary 用户注册
	* @description 用户中心注册
	* @router post /mc/signup
	* @request body mc_member_add *body desc
	* @response 200 baseRes desc
	*/
	async signup() {
        if (!this.config.cms.openRegister) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                username: { type: 'string', required: true, min: 2, max: 15, trim: true, format: /^[a-zA-Z0-9\u4e00-\u9fa5_\-@.+]{2,20}$/ },
                password: { type: 'password', min: 6, max: 20 },
                passwordSure: { type: 'password', min: 6, max: 20 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('账号密码格式错误');
        }
		let { username, password, passwordSure } = ctx.request.body;
        if (password != passwordSure) {
            return this.fail('两次密码不一致');
        }
		password = ctx.helper.cipher(password);
		const [member, created] = await ctx.model.McMember.findOrCreate({
			where: { username }, defaults: { username, password }
		});
		if (created) {
            /* 绑定微信信息(不直接绑定,防止此微信已绑定过其他账号)
            if (await ctx.service.mc.wxauth.checkLogin(false)) {
                await member.update({ third: { wechat: ctx.wxUserInfo }, avatar: ctx.wxUserInfo.headimgurl });
            }
            //*/
			this.success(member, '恭喜您注册成功，请登录！');
		} else {
			this.fail('用户名重复,请重试！');
		}
	}
	/**
	* @summary 退出登录
	* @description 退出登录
	* @router get /mc/logout
	* @response 200 baseRes desc
	*/
	async logout() {
		const { ctx } = this;
		const { url } = ctx.query;
		ctx.session.mcToken = null;
        ctx.session.wxToken = null;
		ctx.redirect(url ? url : '/');
	}
    /**
    * @summary 重置密码
    * @description 重置密码
    * @router post /mc/resetPassword
    * @request body mc_member_add *body desc
    * @response 200 baseRes desc
    */
    async resetPassword() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                reset_email: { type: 'string', max: 40, trim: true }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('请输入正确的邮箱或者手机号');
        }
		let { reset_email } = ctx.request.body;
        if (isMobilePhone(reset_email, 'zh-CN')) {
            var member = await ctx.model.McMember.findOne({ where: { mobile: reset_email} });
            if (!member) {
                return this.fail('此手机号未注册');
            }
            const password = ctx.helper.utils.randomString(10);
            await member.update({ password: ctx.helper.cipher(password) });
            ctx.app.sendSms(reset_email, '', '', password);
            return this.success(null, '新密码已发送到您的手机上，请注意查收！');
        } else if (isEmail(reset_email)) {
            var member = await ctx.model.McMember.findOne({ where: { email: reset_email } });
            if (!member) {
                return this.fail('此邮箱未注册');
            }
            const password = ctx.helper.utils.randomString(10);
            await member.update({ password: ctx.helper.cipher(password) });
            ctx.app.sendEmail(reset_email, '重置密码，请不要告诉别人！', '您的新密码是：' + password)
            return this.success(null, '新密码已发送到您的邮箱，请注意查收！');
        } else {
            return this.fail('请输入正确的邮箱或者手机号');
        }
    }
    /**
    * @summary 发送短信验证码
    * @description 发送短信验证码
    * @router post /mc/sendSms
    * @response 200 baseRes desc
    */
    async sendSms() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                mobile: 'mobile'
            }, ctx.request.body);
        } catch (error) {
            return this.fail('手机号错误');
        }
        const { mobile } = ctx.request.body;
        const cacheDriver = this.app.cache.store('redis').driver;
        const ttl = await cacheDriver.ttl('sms_code_' + mobile);
        if (ttl > 240) {
            return this.fail('请勿频繁发送', 21, { ttl });
        }
        const code = ctx.helper.utils.randomString(6, '0123456789');
        ctx.app.sendSms(mobile, '', '', code);
        await ctx.app.cache.set('sms_code_' + mobile, code, 60 * 5);
        return this.success();
    }
    /**
    * @summary 发送图形验证码
    * @description 发送图形验证码
    * @router get /mc/captcha
    * @response 200 baseRes desc
    */
    async captcha() {
        const { ctx } = this;
        const { data, text } = ctx.genCaptcha();
        ctx.body = data;
        ctx.type = 'image/png';
        ctx.session.captcha = text;
        this.success({ captcha: data });
    }
}
module.exports = IndexController;
