'use strict';
const { Controller } = require('egg');
const { Op } = require('sequelize');
class BaseController extends Controller {
	constructor(ctx) {
		super(ctx);
	}
	get user() {
		return this.ctx.userInfo;
	}

	success(data, msg = '操作成功') {
		this.ctx.body = {
			status: 0,
			msg,
			data,
		};
	}
	fail(msg, status = 1000, data) {
		this.ctx.body = {
			status,
			msg,
			data,
		};
	}
	notFound(msg) {
		msg = msg || 'not found';
		this.ctx.throw(404, msg);
	}
}
module.exports = BaseController;
