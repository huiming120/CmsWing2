'use strict';
const Service = require('egg').Service;

class wxAuthService extends Service {
    async checkLogin(needLogin = true) {
        const { ctx } = this;
        if (ctx.wxUserInfo) {
            return true
        }
        let wxToken = ctx.session.wxToken || ctx.get('wxToken');
        let wxUserInfo = ctx.helper.deToken(wxToken);
        if (wxUserInfo) {
            ctx.wxUserInfo = wxUserInfo
            return true
        } else {
            if (ctx.query.code) {
                try {
                    wxUserInfo = await this.getUserInfo()
                    ctx.wxUserInfo = wxUserInfo
                    wxToken = ctx.helper.generateToken(wxUserInfo);
                    ctx.session.wxToken = wxToken;
                    return true;
                } catch (error) {
                    return false;
                }
            } else {
                if (needLogin) {
                    this.getCode(ctx.href, 'snsapi_userinfo');
                }
                return false
            }
        }
    }
    getCode(redirectUri, snsapiType = 'snsapi_base') {
        const { appid } = this.app.config.wxauth
        const getCodeUrl = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri=${redirectUri}&response_type=code&scope=${snsapiType}&state=PH_STATE#wechat_redirect`
        this.ctx.redirect(encodeURI(getCodeUrl))
    }
    async getAccessToken() {
        // redirectUri中设置的回调地址会进入这个methods
        const { code, state } = this.ctx.query
        // 只有state等于配置中的state,才是微信浏览器返回的
        if (!state || state !== 'PH_STATE') {
            // 就不允许访问
            return
        }
        const { appid, appsecret } = this.app.config.wxauth
        const tokenUrl = `https://api.weixin.qq.com/sns/oauth2/access_token?appid=${appid}&secret=${appsecret}&code=${code}&grant_type=authorization_code`
        let result
        try {
            result = await this.ctx.curl(tokenUrl, { dataType: 'json' })
            // 如果存在错误码,则access_token获取失败
            if (result.data.errcode) {
                this.logger.error(`access_token获取失败: ${JSON.stringify(result.data)}`)
                return
            }
            return result.data
        } catch (error) {
            this.logger.error(`getAccessToken接口异常: ${JSON.stringify(result.data)}`)
            return
        }
    }
    async getUserInfo() {
        const data = await this.getAccessToken()
        if (data) {
            const { access_token, openid } = data
            // 获取微信的用户数据
            // 如果前面传入的scope不一致,获取到数据信息量不一样
            const userinfoUrl = `https://api.weixin.qq.com/sns/userinfo?access_token=${access_token}&openid=${openid}&lang=zh_CN`
            try {
                const userData = await this.ctx.curl(userinfoUrl, { dataType: 'json' })
                if (userData.data.errcode) {
                    this.logger.error(`微信用户信息获取失败: ${JSON.stringify(userData.data)}`)
                    return
                }
                return userData.data
            } catch (error) {
                this.logger.error('获取用户数据失败,' + JSON.stringify(error))
                return
            }
        }
    }
}
module.exports = wxAuthService;