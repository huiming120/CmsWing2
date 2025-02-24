/* eslint-disable jsdoc/check-tag-names */
'use strict';
const Controller = require('../../core/base_controller');
const { Op } = require('sequelize');
const fs = require('fs-extra');
const path = require('path');
const compressing = require('compressing');
/**
* @controller 应用管理
*/
class ApplicationController extends Controller {
	/**
	* @summary 应用列表
	* @description 应用列表
	* @router get /admin/sys/application
	* @request query string keywords desc
	* @response 200 baseRes desc
	*/
	async index() {
		const { ctx } = this;
		const data = ctx.query;
		const page = data.page || 1;
		const limit = data.perPage || 15;
		// console.log(ctx.query);
		const map = {};
		map.offset = (Number(page) - 1) * limit;
		map.limit = Number(limit);
		map.order = [['id', 'ASC']];
		map.where = {};
		if (data.keywords) {
			map.where.op_or = [{ name: { [Op.like]: `%${data.keywords}%` } }, { title: { [Op.like]: `%${data.keywords}%` } }];
		}
		// map.raw = true;
		const list = await ctx.model.SysApplication.findAndCountAll(map);
		for (const v of list.rows) {
			//   console.log(v);
			v.dataValues.version = v.version === 'sys' ? this.config.pkg.version : v.version;
		}
		this.success({ items: list.rows, total: list.count });
	}
	/**
	* @summary 添加应用
	* @description 添加应用
	* @router post /admin/sys/application/add
	* @request body sys_application_add *body desc
	* @response 200 baseRes desc
	*/
	async add() {
		const { ctx } = this;
		const data = ctx.request.body;
		const isc = await ctx.model.SysApplication.findOne({ where: { name: data.name } });
		if (isc) return this.fail('应用标识不能重复');
		const add = await ctx.model.SysApplication.create(data);
		this.success(add);
	}
	/**
	* @summary 编辑应用
	* @description 编辑应用
	* @router post /admin/sys/application/edit
	* @request body sys_application_edit *body desc
	* @response 200 baseRes desc
	*/
	async edit() {
		const { ctx } = this;
		const data = ctx.request.body;
		const edit = await ctx.model.SysApplication.update(data, { where: { name: data.name } });
		this.success(edit);
	}
    /**
	* @summary 删除应用
	* @description 删除应用
	* @router post /admin/sys/application/del
	* @request body sys_application_edit *body 传入应用标识name
	* @response 200 baseRes desc
	*/
    async del() {
		const { ctx } = this;
		const { name } = ctx.request.body;
        const app = await ctx.model.SysApplication.findOne({ where: { name, sys: false } });
		if (!app) return this.fail('应用不存在');
        // 模型表
        const models = await ctx.model.SysModels.findAll({ where: { app: name }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        const uuids = models.map(v => v.uuid);
        await ctx.model.SysModels.destroy({ where: { app: name } });
        // 相关数据表(暂时不删除表)
        // for (const model of models) {
        //     const modelName = ctx.helper._.upperFirst(ctx.helper._.camelCase(model.name));
        //     await ctx.model[modelName].drop();
        // }
        // 模型字段表
        await ctx.model.SysModelsFields.destroy({ where: { models_uuid: { [Op.in]: uuids } } });
        // 模型索引表
        await ctx.model.SysModelsIndexes.destroy({ where: { models_uuid: { [Op.in]: uuids } } });
        // 模型关联表
        await ctx.model.SysModelsAssociate.destroy({ where: { models_uuid: { [Op.in]: uuids } } });
        // 路由表
        await ctx.model.SysRoutes.destroy({ where: { app: name } });
        // controller
        try {
            await fs.remove(path.join(this.app.baseDir, 'app', 'controller', name));
        } catch (error) {}
        // middleware
        try {
            await fs.remove(path.join(this.app.baseDir, 'app', 'middleware', name));
        } catch (error) {}
        // pages
        try {
            await fs.remove(path.join(this.app.baseDir, 'app', 'pages', name));
        } catch (error) {}
        // service
        try {
            await fs.remove(path.join(this.app.baseDir, 'app', 'service', name));
        } catch (error) {}
        // view
        try {
            await fs.remove(path.join(this.app.baseDir, 'app', 'view', name));
        } catch (error) {}
        // 应用表
        await app.destroy();
        const generateService = ctx.service.sys.generate;
        // 生成实体模型
		await generateService.modelsAll();
		// 生成graphql
		await generateService.graphqlAll();
		// 生成contract
		await generateService.contract();
        // 生成路由
        await generateService.routes();
		this.success();
	}
    /**
	* @summary 导出应用
	* @description 导出应用
	* @router get /admin/sys/application/export
	* @request query string *name 应用标识
	* @response 200 baseRes desc
	*/
    async export() {
		const { ctx } = this;
		const { name } = ctx.query;
		const app = await ctx.model.SysApplication.findOne({ where: { name }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
		if (!app) return this.fail('应用不存在');
        const dirPath = path.join(this.config.rundir, `${name}-${new Date().getTime()}`);
        ctx.helper.mkdirsSync(dirPath);
        const filePath = dirPath + '.tar';
        // 应用表
        await fs.writeJSON(path.join(dirPath, 'application.json'), app);
        // 模型表
        const models = await ctx.model.SysModels.findAll({ where: { app: name }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_models.json'), models);
        // 相关数据表
        for (const model of models) {
            const modelName = ctx.helper._.upperFirst(ctx.helper._.camelCase(model.name));
            const modelData = await ctx.model[modelName].findAll();
            await fs.writeJSON(path.join(dirPath, model.name + '.json'), modelData);
        }
        const uuids = models.map(v => v.uuid);
        // 模型字段表
        const fields = await ctx.model.SysModelsFields.findAll({ where: { models_uuid: { [Op.in]: uuids } }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_models_fields.json'), fields);
        // 模型索引表
        const indexes = await ctx.model.SysModelsIndexes.findAll({ where: { models_uuid: { [Op.in]: uuids } }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_models_indexes.json'), indexes);
        // 模型关联表
        const associate = await ctx.model.SysModelsAssociate.findAll({ where: { models_uuid: { [Op.in]: uuids } }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_models_associate.json'), associate);
        // 路由表
        const routers = await ctx.model.SysRoutes.findAll({ where: { app: name }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_routes.json'), routers);
        // 配置表
        const configs = await ctx.model.SysConfig.findAll({ where: { name }, attributes: { exclude: ['id', 'createdAt', 'updatedAt'] } });
        await fs.writeJSON(path.join(dirPath, 'sys_config.json'), configs);
        // controller
        try {
            await fs.copy(path.join(this.app.baseDir, 'app', 'controller', name), path.join(dirPath, 'controller', name));
        } catch (error) {}
        // middleware
        try {
            await fs.copy(path.join(this.app.baseDir, 'app', 'middleware', name), path.join(dirPath, 'middleware', name));
        } catch (error) {}
        // pages
        try {
            await fs.copy(path.join(this.app.baseDir, 'app', 'pages', name), path.join(dirPath, 'pages', name));
        } catch (error) {}
        // service
        try {
            await fs.copy(path.join(this.app.baseDir, 'app', 'service', name), path.join(dirPath, 'service', name)); 
        } catch (error) {}
        // view
        try {
            await fs.copy(path.join(this.app.baseDir, 'app', 'view', name), path.join(dirPath, 'view', name));
        } catch (error) {}
        // public
        try {
            await fs.copy(path.join(this.config.static.dir, 'assets', name), path.join(dirPath, 'public', 'assets', name));
        } catch (error) {}
        await compressing.tar.compressDir(dirPath, filePath);
        await ctx.downloader(filePath);
        fs.remove(filePath);
        fs.remove(dirPath);
    }
    /**
	* @summary 导入应用
	* @description 导入应用
	* @router post /admin/sys/application/import
	* @request formData file *file 导入文件
	* @response 200 baseRes desc
	*/
    async import() {
        const { ctx } = this;
        const file = ctx.request.files[0], dirName = path.basename(file.filename, path.extname(file.filename)), dirPath = path.join(this.config.rundir, dirName);
        try {
            await compressing.tar.uncompress(file.filepath, this.config.rundir);
            const app = await fs.readJSON(path.join(dirPath, 'application.json'));
            // public
            try {
                await fs.copy(path.join(dirPath, 'public', 'assets', app.name), path.join(this.config.static.dir, 'assets', app.name));
            } catch (error) {}
            // view
            try {
                await fs.copy(path.join(dirPath, 'view', app.name), path.join(this.app.baseDir, 'app', 'view', app.name));
            } catch (error) {}
            // service
            try {
                await fs.copy(path.join(dirPath, 'service', app.name), path.join(this.app.baseDir, 'app', 'service', app.name)); 
            } catch (error) {}
            // pages
            try {
                await fs.copy(path.join(dirPath, 'pages', app.name), path.join(this.app.baseDir, 'app', 'pages', app.name));
            } catch (error) {}
            // middleware
            try {
                await fs.copy(path.join(dirPath, 'middleware', app.name), path.join(this.app.baseDir, 'app', 'middleware', app.name));
            } catch (error) {}
            // controller
            try {
                await fs.copy(path.join(dirPath, 'controller', app.name), path.join(this.app.baseDir, 'app', 'controller', app.name));
            } catch (error) {}
            // 应用表
            await ctx.model.SysApplication.create(app);
            // 模型表
            const models = await fs.readJSON(path.join(dirPath, 'sys_models.json'));
            if (models.length > 0) {
                await ctx.model.SysModels.bulkCreate(models);
            }
            // 模型字段表
            const fields = await fs.readJSON(path.join(dirPath, 'sys_models_fields.json'));
            if (fields.length > 0) {
                await ctx.model.SysModelsFields.bulkCreate(fields);
            }
            // 模型索引表
            const indexes = await fs.readJSON(path.join(dirPath, 'sys_models_indexes.json'));
            if (indexes.length > 0) {
                await ctx.model.SysModelsIndexes.bulkCreate(indexes);
            }
            // 模型关联表
            const associate = await fs.readJSON(path.join(dirPath, 'sys_models_associate.json'));
            if (associate.length > 0) {
                await ctx.model.SysModelsAssociate.bulkCreate(associate);
            }
            // 路由表
            const routers = await fs.readJSON(path.join(dirPath, 'sys_routes.json'));
            if (routers.length > 0) {
                await ctx.model.SysRoutes.bulkCreate(routers);
            }
            // 配置表
            const configs = await fs.readJSON(path.join(dirPath, 'sys_config.json'));
            if (configs.length > 0) {
                await ctx.model.SysConfig.bulkCreate(configs);
            }
            const generateService = ctx.service.sys.generate;
            // 生成实体模型
            await generateService.modelsAll();
            // 生成graphql
            await generateService.graphqlAll();
            // 生成contract
            await generateService.contract();
            // 生成路由
            await generateService.routes();
            // 相关数据表(没办法同步数据表,需要重启服务器才能生效)
        } catch (error) {
            return this.fail(error.toString());
        } finally {
            // 需要删除临时文件
            fs.remove(dirPath);
            fs.remove(file.filepath);
        }
        this.success(null, '应用导入成功,但你需要重启服务才能生效,且需要你手动同步表结构,请检查应用包里是否有相关表初始数据,如果有需要你手动导入到对应模型表!');
    }
}
module.exports = ApplicationController;
