const GRAPHQLQUERY = Symbol('Context#graphqlQuery');
const svgCaptcha = require('svg-captcha');
module.exports = {
    graphqlQuery(query) {
        // this 就是 ctx 对象，在其中可以调用 ctx 上的其他方法，或访问属性
        if (!this[GRAPHQLQUERY]) {
            // 例如，从 header 中获取，实际情况肯定更复杂
            this[GRAPHQLQUERY] = this.graphql.query(query);
        }
        return this[GRAPHQLQUERY];
    },
    get isIOS() {
        const iosReg = /iphone|ipad|ipod/i;
        return iosReg.test(this.get('user-agent'));
    },
    // 是否是微信浏览器
    get isweixin() {
        const ua = this.get('user-agent').toLowerCase()
        let ma = ua.match(/MicroMessenger/i)
        if (ma && ma[0] === 'micromessenger') {
            return true
        } else {
            return false
        }
    },
    get isMobile() {
        const ua = this.get('user-agent')
        const mobileAgents = ["Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"]
        for (let i = 0; i < mobileAgents.length; i++) {
            if (ua.indexOf(mobileAgents[i]) > 0) {
                return true
            }
        }
        return false
    },
    genCaptcha() {
        const captcha = svgCaptcha.create({
			size: 4, // 验证码长度
			fontSize: 45, // 验证码字号
			noise: 2, // 干扰线条数目
			ignoreChars: '0o1i',   //验证码字符中排除'0o1i'
			width: 120, // 宽度
			height: 36, // 高度
			color: true, // 验证码字符是否有颜色，默认是没有，但是如果设置了背景颜色，那么默认就是有字符颜色
			background: '#ccc' // 背景颜色
		});
        return captcha;
    }
};
