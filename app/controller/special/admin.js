'use strict';
const Controller = require('../../core/base_controller');
const _ = require('lodash');
const { Op } = require('sequelize');

/**
* @controller 专题管理
*/
class SpecialAdminController extends Controller {
    /**
     * @summary 专题列表
     * @description 专题列表
     * @router get /admin/special/list
     * @request query integer perPage 每页数量
     * @request query integer page 当前页
     * @response 200 baseRes
     */
    async list() {
        const { ctx } = this;
        try {
            ctx.validate({
                keyword: 'string?',
                page: { type: 'int', required: false, min: 1, default: 1 },
                perPage: { type: 'int', required: false, min: 1, default: 20 }
            }, ctx.query);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { keyword, status ,perPage, page, orderBy, orderDir } = ctx.query;
        const map = {
            where: {},
            order: [['id', 'DESC']],
            offset: (page - 1) * perPage,
            limit: perPage
        }
        if (keyword) {
            map.where[Op.or] = {
                title: { [Op.substring]: keyword },
                description: { [Op.substring]: keyword },
                banners: { [Op.substring]: keyword }
            }
        }
        if (status != undefined && status != '') {
            map.where.status = status;
        }
        if (orderBy && orderDir) {
            map.order = [[orderBy, orderDir]]
        }
        const list = await ctx.model.Special.findAndCountAll(map);
        return this.success(list);
    }

    /**
     * @summary 专题数据列表
     * @description 专题详情
     * @router get /admin/special/dataList/:special_id
     * @response 200 baseRes
     */
    async dataList() {
        const { ctx } = this;
        try {
            ctx.validate({
                special_id: { type: 'int', required: true, min: 1 }
            }, ctx.params);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { special_id } = ctx.params;
        const { keyword, status, orderBy, orderDir } = ctx.query;

        /* 通过专题数据表可以分页查询
        const list = await ctx.model.SpecialData.findAndCountAll({
            where: { special_id },
            attributes: ['id', 'sort'],
            order: [['sort', 'DESC'], ['id', 'DESC']],
            include: [
                {
                    model: ctx.model.CmsDoc,
                    as: 'cms_doc2',
                    attributes: ['id', 'title', 'createdAt', 'updatedAt', 'description', 'status'],
                    include: [{ model: ctx.model.CmsClassify, attributes: ['id', 'title'] }]
                }
            ]
        })
        return this.success(list);
        //*/

        const docInclude = {
            model: ctx.model.CmsDoc,
            attributes: ['id', 'title', 'createdAt', 'updatedAt', 'description', 'status'],  
            through: {
                attributes: ['id', 'sort'],
                // where: { sort: { [Op.gt]: 0 } },
            },
            include: [{ model: ctx.model.CmsClassify, attributes: ['id', 'title'] }],
            required: false,
        };
        if (keyword) {
            docInclude.where = docInclude.where || {};
            docInclude.where[Op.or] = {
                title: { [Op.substring]: keyword },
                description: { [Op.substring]: keyword },
                tags: { [Op.substring]: keyword }
            }
        }
        if (status != undefined && status != '') {
            docInclude.where = docInclude.where || {};
            docInclude.where.status = status;
        }
        const map = {
            where: { id: special_id },
            attributes: ['id', 'title'],
            order: [[ctx.model.CmsDoc, ctx.model.SpecialData, 'sort', 'DESC'], [ctx.model.CmsDoc, ctx.model.SpecialData, 'id', 'DESC']],
            include: [ docInclude ],
        };
        if (orderBy && orderDir) {
            if (orderBy == 'special_data.sort') {
                map.order = [[ctx.model.CmsDoc, ctx.model.SpecialData, 'sort', orderDir]];
            } else {
                map.order = [[ctx.model.CmsDoc, orderBy, orderDir]];
            }
        }
        const specialInfo = await ctx.model.Special.findByPk(special_id, map);
        specialInfo.dataValues.count = specialInfo.cms_docs.length;
        return this.success(specialInfo);
    }
}
module.exports = SpecialAdminController;