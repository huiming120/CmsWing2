'use strict';
const Controller = require('../../core/base_controller');
const fs = require('fs/promises');
const { Op } = require('sequelize');
/**
* @controller 会员设置
*/
class IndexController extends Controller {
	/**
	* @summary 会员设置
	* @description 会员设置
	* @router get /mc/setup
	* @response 200 baseRes desc
	*/
	async index() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
		ctx.meta_title = '会员设置';
		const member = await ctx.model.McMember.findOne({ where: { uuid: ctx.userInfo.uuid } });
        const templatePath = await ctx.service.cms.web.cmsTemplatePath();
		await ctx.render(`cms/${templatePath}/mc_setup_index`, { member });
	}
	/**
	* @summary 更新头像
	* @description 更新头像
	* @router post /mc/setup/avatar
	* @request body mc_member_edit *body desc
	* @response 200 baseRes desc
	*/
	async avatar() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
		const data = ctx.request.body;
        const member = await ctx.model.McMember.findOne({ where: { uuid: ctx.userInfo.uuid, state: true } });
		if (data.action === 'delete') {
            await member.update({ avatar: '' });
			const token = ctx.helper.generateToken(member);
			ctx.session.mcToken = token;
			return this.success(member);
		}
		const file = ctx.request.files[0];
		try {
			// 处理文件，比如上传到云端
			const upload = await ctx.service.sys.objectStorage.upload(data, file, false);
			if (upload) {
                const attachment = await ctx.model.CmsAttachment.create({
                    name: upload.name,
                    description: `用户 ${member.username} 的头像`,
                    path: upload.savename,
                    url: upload.url,
                    compressed_url: upload.compressed_url,
                    size: upload.size,
                    mime: upload.mime,
                    location: upload.location,
                    upload_user_uuid: member.uuid,
                    upload_ip: ctx.ip,
                    status: false,
                    remark: { from: 'avatar' }
                })
                upload.url = upload.url + attachment.id;
                upload.compressed_url = upload.url;
                await attachment.update({ url: upload.url, compressed_url: upload.compressed_url });
                await member.update({ avatar: upload.url });
				const token = ctx.helper.generateToken(member);
				ctx.session.mcToken = token;
				this.success(upload);
			} else {
				throw new Error('上传失败');
			}
		} catch (e) {
			// console.log(e);
			this.fail(e.toString());
		} finally {
			// 需要删除临时文件
			await fs.unlink(file.filepath);
		}
	}
	/**
	* @summary 更新会员信息
	* @description 更新会员信息
	* @router post /mc/setup/updateInfo
	* @request body mc_member_edit *body desc
	* @response 200 baseRes desc
	*/
	async updateInfo() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
        try {
            ctx.validate({
                username: { type: 'string', required: true, min: 2, max: 15, trim: true, format: /^[a-zA-Z0-9\u4e00-\u9fa5_\-@.+]{2,20}$/ }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('账号密码格式错误');
        }
        const { username } = ctx.request.body;
        const userInfo = await ctx.model.McMember.findOne({ where: { uuid: ctx.userInfo.uuid } });
        if (userInfo.username) {
            return this.fail('你已经设置过账号，无法再次设置！');
        }
		const exist = await ctx.model.McMember.findOne({ where: { username } });
		if (exist) {
			return this.fail('已存在相同的账号，请重试！');
		}
        await userInfo.update({ username });
		ctx.session.mcToken = ctx.helper.generateToken(userInfo);
		this.success(userInfo);
	}
    /**
	* @summary 更新手机号
	* @description 更新手机号
	* @router post /mc/setup/upMobile
	* @request body mc_member_edit *body desc
	* @response 200 baseRes desc
	*/
    async upMobile() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                mobile: 'mobile',
                code: 'string',
                password: { type: 'password', min: 6, max: 20 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('参数错误');
        }
        const { mobile, code, password } = ctx.request.body;
        const oldCode = await ctx.app.cache.get('sms_code_' + mobile);
        if (oldCode !== code) {
            return this.fail('验证码错误', 21);
        }
        ctx.app.cache.del('sms_code_' + mobile);
        const mcMemberModel = ctx.model.McMember;
        const exist = await mcMemberModel.findOne({ where: { mobile } });
		if (exist) {
			return this.fail('此手机号已经被绑定过！', 22);
		}
        const info = await mcMemberModel.findOne({ where: { password: ctx.helper.cipher(password), uuid: ctx.userInfo.uuid } });
		if (!info) return this.fail('密码错误！');
        await info.update({ mobile });
		ctx.session.mcToken = ctx.helper.generateToken(info);
		this.success(info);
	}
	/**
	* @summary 更新邮箱
	* @description 更新邮箱
	* @router post /mc/setup/upEmail
	* @request body mc_member_edit *body desc
	* @response 200 baseRes desc
	*/
	async upEmail() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
        try {
            ctx.validate({
                email: 'email',
                password: { type: 'password', min: 6, max: 20 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('密码格式错误');
        }
		const { email, password } = ctx.request.body;
        const mcMemberModel = ctx.model.McMember;
        const exist = await mcMemberModel.findOne({ where: { email } });
		if (exist) {
			return this.fail('此邮箱已经被绑定过！', 22);
		}
		const info = await mcMemberModel.findOne({ where: { password: ctx.helper.cipher(password), uuid: ctx.userInfo.uuid } });
		if (!info) return this.fail('密码错误！');
        const sessionId = ctx.helper.uuid();
        ctx.app.sendEmail(email, '邮箱激活', '请前往邮箱激活账号', '<p><a href="' + ctx.helper.urlFor('激活邮箱', { sessionId }) + '">' + '请点击此链接激活账号' + '</a></p>')
        await ctx.app.cache.set('up_email_' + sessionId, email, 60 * 5);
        this.success(null, '请在5分钟内前往邮箱激活并刷新此页面！')
	}
    async upEmailActiveLink() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx } = this;
        try {
            ctx.validate({
                sessionId: 'string'
            }, ctx.query);
        } catch (error) {
            return this.fail('密码格式错误');
        }
        const email = await ctx.app.cache.get('up_email_' + ctx.query.sessionId);
        if (email) {
            const info = await ctx.model.McMember.findOne({ where: { uuid: ctx.userInfo.uuid } });
            await info.update({ email });
            ctx.app.cache.del('up_email_' + ctx.query.sessionId);
            ctx.session.mcToken = ctx.helper.generateToken(info);
            this.success('绑定邮箱成功！');
        } else {
            this.notFound();
        }
    }
	/**
	* @summary 更新密码
	* @description 更新密码
	* @router post /mc/setup/upPassword
	* @request body mc_member_edit *body desc
	* @response 200 baseRes desc
	*/
	async upPassword() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
		const { ctx } = this;
        try {
            ctx.validate({
                password: { type: 'password', min: 6, max: 20 },
                password_new: { type: 'password', min: 6, max: 20 }
            }, ctx.request.body);
        } catch (error) {
            return this.fail('密码格式错误');
        }
		const { password_new, password } = ctx.request.body;
		const info = await ctx.model.McMember.findOne({ where: { password: ctx.helper.cipher(password), uuid: ctx.userInfo.uuid } });
		if (!info) return this.fail('密码错误！');
        await info.update({ password: ctx.helper.cipher(password_new) });
		this.success('ok');
	}
    /**
	* @summary 绑定微信
	* @description 绑定微信
	* @router get /mc/setup/bindWechat
	* @response 200 baseRes desc
	*/
    async bindWechat() {
        if (!this.config.cms.openLogin) {
            return this.notFound();
        }
        const { ctx, app } = this, Sequelize = app.Sequelize;
        // 强制拿微信最新信息
        ctx.session.wxToken = null;
        ctx.wxUserInfo = null
        if (!await ctx.service.mc.wxauth.checkLogin()) {
            return this.fail('请先授权微信登录！');
        }
        // 检查微信是否绑定过其他账号
        const mcMemberModel = ctx.model.McMember;
        const exist = await mcMemberModel.findOne({ 
            where: Sequelize.and(
                Sequelize.where(
                    Sequelize.fn('json_extract', Sequelize.col('third'), Sequelize.literal(`'$.wechat.openid'`)),
                    ctx.wxUserInfo.openid
                ),
                { uuid: { [Op.ne]: ctx.userInfo.uuid } }
            )
        });
        if (exist) {
            return this.fail('此微信号已经被绑定过！', 22);
        }
        const info = await mcMemberModel.findOne({ where: { uuid: ctx.userInfo.uuid } });
        // if (info.third) {
        //     info.third.wechat = ctx.wxUserInfo;
        // } else {
        //     info.third = { wechat: ctx.wxUserInfo };
        // }
        // info.avatar = ctx.wxUserInfo.headimgurl;
        // await mcMemberModel.update({ third: info.third, avatar: info.avatar }, { where: { uuid: info.uuid } });
        
        await info.update({ third: info.third ? { ...info.third, wechat: ctx.wxUserInfo } : { wechat: ctx.wxUserInfo }, avatar: ctx.wxUserInfo.headimgurl });
		ctx.session.mcToken = ctx.helper.generateToken(info);
		const retUrl = ctx.query.retUrl || '/'
        ctx.redirect(decodeURIComponent(retUrl))
    }
}
module.exports = IndexController;
