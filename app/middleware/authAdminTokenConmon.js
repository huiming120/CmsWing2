'use strict';
module.exports = options => {
	return async function authAdminToken(ctx, next) {
		const token = ctx.session.adminToken || ctx.get('adminToken');
		const userInfo = ctx.helper.deToken(token);
		if (userInfo) {
			ctx.userInfo = userInfo;
			await next();
		} else {
            ctx.session.adminToken = null;
			if (ctx.request.accepts(['json', 'html']) === 'html') {
				ctx.redirect('/');
			} else {
				ctx.body = {
					status: 401,
					msg: '未登录',
					data: { isLogin: false },
				};
			}
		}
	};
};
