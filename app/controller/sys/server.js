/* eslint-disable jsdoc/check-tag-names */
'use strict';
/**
* @controller 系统服务
*/
const Controller = require('../../core/base_controller');
class ServerController extends Controller {
	async index() {
		this.success(1);
	}
	/**
	* @summary 重启服务
	* @description 重启服务
	* @router post admin/sys/server/restart
	* @response 200 baseRes desc
	*/
	async restart() {
		// await this.ctx.helper.waitTime(5000);
		// this.ctx.status = 200;
		// this.ctx.set('Content-Type', 'text/plain');
		// this.ctx.res.write('🚗服务重启中... \n');
		// this.ctx.res.write('🚗关闭服务... \n');
		// await this.ctx.helper.waitTime(1500);
		// this.ctx.res.write('🚗重新启动服务... \n');
		// await this.ctx.helper.waitTime(1000);
		// this.ctx.res.end('\n🚗执行成功!!!!!!');
		this.service.sys.server.restart();
		this.success(null, '重启成功');
	}
	/**
	* @summary 获取中间件
	* @description 获取中间件
	* @router get /admin/sys/server/getMiddleware
	* @response 200 baseRes desc
	*/
	async getMiddleware() {
		const list = await this.ctx.service.sys.server.getMiddleware();
		this.success(list);
	}
	/**
	* @summary 获取控制器
	* @description 获取控制器
	* @router get /admin/sys/server/getController
	* @response 200 baseRes desc
	*/
	async getController() {
		const list = await this.ctx.service.sys.server.getController();
		this.success(list);
	}
	/**
	* @summary 获取控制器方法
	* @description 获取控制器方法
	* @router get /admin/sys/server/getAction
	* @request query integer *c 控制器名称
	* @response 200 baseRes errorCode:0成功
	*/
	async getAction() {
		const { c } = this.ctx.query;
		const data = await this.ctx.service.sys.server.getAction(c);
		this.success(data);
	}
    /**
	* @summary 更新缓存
	* @description 更新数据缓存
	* @router post /admin/sys/server/reloadCache/:type
	* @response 200 baseRes desc
	*/
    async reloadCache() {
        const { type } = this.ctx.params, cacheService = this.ctx.service.sys.cache;
        switch (type) {
            case 'all':
                await cacheService.reloadAll();
                break;
            case 'classify':
                await cacheService.classify();
                break;
            case 'template':
                await cacheService.template();
                break;
            case 'navigation':
                await cacheService.navigation();
                break;
            case 'static':
                cacheService.static();
                break;
        }
        this.success();
    }
}
module.exports = ServerController;
