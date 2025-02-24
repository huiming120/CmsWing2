'use strict';
const Controller = require('../../core/base_controller');

/**
* @controller 专题功能
*/
class SpecialController extends Controller {
    /**
    * @summary 专题首页
    * @description 专题首页
    * @router get /special
    * @request query integer *page
    * @response 200 baseRes
    */
    async index() {
        const { ctx } = this;
        const { page = 1 } = ctx.query;
        const limit = 10;
        const list = await ctx.model.Special.findAndCountAll({
            where: {
                status: true
            },
            order: [['sort', 'DESC'], ['id', 'DESC']],
            offset: (page - 1) * limit,
            limit: limit
        });
        if (ctx.request.accepts(['json', 'html']) === 'html') {
            const templatePath = await ctx.service.cms.web.cmsTemplatePath();
            if (ctx.templateInfo.special_use) {
                await ctx.render(`cms/${templatePath}/special_${ctx.templateInfo.special_use}.html`);
            } else {
                await ctx.render('special/index', { list });
            }
        } else {
            return this.success(list);
        }
    }

    /**
     * @summary 专题详情
     * @description 专题详情
     * @router get /special/:id
     */
    async info() {
        const { ctx } = this;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 }
            }, ctx.params)
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { id } = ctx.params;
        const specialInfo = await ctx.model.Special.findOne({
            attributes: { exclude: ['createdAt', 'updatedAt', 'sort', 'status'] },
            where: { id, status: true }
        });
        if (!specialInfo) {
            return this.notFound();
        }
        const { page = 1 } = ctx.query, limit = 10;
        const dataList = await ctx.model.SpecialData.findAndCountAll({
            where: { special_id: id },
            attributes: ['id', 'sort'],
            order: [['sort', 'DESC'], ['id', 'DESC']],
            offset: (page - 1) * limit,
            limit: limit,
            include: [
                {
                    model: ctx.model.CmsDoc,
                    as: 'cms_doc2',
                    attributes: ['id', 'title', 'createdAt', 'updatedAt', 'description', 'cover_url', 'view', 'tags', 'deadline', 'models_uuid'],
                    // include: [{ model: ctx.model.CmsClassify, attributes: ['id', 'title'] }],
                    where: { status: true }
                }
            ]
        })
        if (ctx.request.accepts(['json', 'html']) === 'html') {
            if (specialInfo.temp) {
                const templatePath = await ctx.service.cms.web.cmsTemplatePath();
                await ctx.render(`cms/${templatePath}/${specialInfo.temp}`);
            } else {
                await ctx.render('special/show', { specialInfo, dataList });
            }
        } else {
            return this.success({ specialInfo, dataList });
        }
    }
}
module.exports = SpecialController;