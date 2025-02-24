'use strict';
const Controller = require('../../core/base_controller');
const _ = require('lodash');
const { Op } = require('sequelize');

/**
* @controller 表单管理
*/
class FormAdminController extends Controller {

    /**
     * @summary 表单列表
     * @description 表单列表
     * @router get /admin/form/list
     * @request query integer perPage 每页数量
     * @request query integer page 当前页
     * @response 200 baseRes
     */
    async list() {
        const { ctx } = this;
        try {
            ctx.validate({
                page: { type: 'int', required: false, min: 1, default: 1 },
                perPage: { type: 'int', required: false, min: 1, default: 20 }
            }, ctx.query);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { perPage, page, orderBy, orderDir } = ctx.query;
        const map = {
            where: {},
            order: [['id', 'DESC']],
            offset: (page - 1) * perPage,
            limit: perPage
        }
        if (orderBy && orderDir) {
            map.order = [[orderBy, orderDir]]
        }
        const list = await ctx.model.Form.findAndCountAll(map);
        return this.success({ items: list.rows, total: list.count });
    }

    /**
     * @summary 添加表单
     * @description 添加表单
     * @router post /admin/form/add
     * @request body form_add form
     * @response 200 baseRes
     */
    async add() {
        const { ctx } = this, data = ctx.request.body;
        try {
            ctx.validate({
                title: { type: 'string', required: true, trim: true, max: 200 },
                begin_at: { type: 'datetime', required: true },
                end_at: { type: 'datetime', required: true },
                config: { type: 'object', required: true, rule: {
                    login_type: { type: 'enum', required: true, values: [0, 1, 2] },    // 登录方式 0:不限制 1:微信登录 2:账号登录
                    limit_day: { type: 'int', default: 1, min: 0 },          // 限制每天提交次数
                    limit_week: { type: 'int', default: 1, min: 0 },          // 限制每周提交次数
                    limit_month: { type: 'int', default: 1, min: 0 },          // 限制每月提交次数
                    limit_total: { type: 'int', default: 1, min: 0 },          // 限制总共提交次数
                    bind_email: { type: 'boolean', required: false, default: false },
                    bind_mobile: { type: 'boolean', required: false, default: false },
                    bind_wechat: { type: 'boolean', required: false, default: false },
                    can_edit: { type: 'boolean', required: false, default: true },
                    need_verification: { type: 'boolean', required: false, default: false },
                    open_in_active_only: { type: 'boolean', required: false, default: false },
                } },
                fields: { type: 'array', itemType: 'object', required: false, default: [], rule: {
                    name: { type: 'string', required: true, trim: true, max: 20 },      // 字段表单名称(不可重复,因为字符串或数字的组合,不能是特殊字符)
                    type: { type: 'enum', required: true, values: ['number', 'string', 'boolean', 'mobile', 'email', 'url', 'idCard', 'date', 'dateTime', 'upload', 'image', 'radios', 'selectS', 'checkboxes', 'selectM', 'editor'] },
                    label: { type: 'string', required: true, trim: true, max: 200 },     // 字段标签
                    required: { type: 'boolean', default: false },                      // 是否必填
                    // verification: { type: 'boolean', default: false },      // 手机号时是否需要短信验证
                    // max: { type: 'int', required: false },                                   // 最小、最短、最少上传文件个数
                    // min: { type: 'int', required: false },                                   // 最大、最长、最多上传文件个数
                    precision: { type: 'int', required: false, min: 0, default: 0 },                             // 小数位数
                    options: { type: 'array', itemType: 'object', required: false, rule: {  // 字段为select,radio,checkbox,switch时必填
                        label: { type: 'string', required: true, trim: true, max: 200 },
                        value: { type: 'int', required: true },
                    }}
                } },
                temp: { type: 'string', required: false, trim: true, allowEmpty: true }
            }, data);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        // 检查fileds是否有重名字段
        // 使用 _.uniqBy 获取唯一的 name 字段
        const uniqueFields = _.uniqBy(data.fields, 'name');
        // 找出重复的项
        const duplicates = _.difference(data.fields, uniqueFields);
        if (duplicates.length > 0) {
            return this.fail(`存在重复的 ${duplicates[0].name} 字段`);
        }
        const formInfo = await ctx.model.Form.create(data);
        const amis = ctx.service.sys.generate.amis(formInfo);
        await formInfo.update({ amis })
        // 生成后台表单展示项到缓存
        const columns = ctx.service.sys.generate.amisColumns(formInfo);
        await this.app.cache.set(`form:${formInfo.id}:columns`, columns);
        return this.success();
    }

    /**
     * @summary 编辑表单
     * @description 编辑表单
     * @router post /admin/form/edit
     * @request body form_item form
     * @response 200 baseRes
     */
    async edit() {
        const { ctx } = this, data = ctx.request.body;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 },
                title: { type: 'string', required: true, trim: true, max: 200 },
                begin_at: { type: 'datetime', required: true },
                end_at: { type: 'datetime', required: true },
                config: { type: 'object', required: true, rule: {
                    login_type: { type: 'enum', required: true, values: [0, 1, 2] },    // 登录方式 0:不限制 1:微信登录 2:账号登录
                    limit_day: { type: 'int', default: 1, min: 0 },          // 限制每天提交次数
                    limit_week: { type: 'int', default: 1, min: 0 },          // 限制每周提交次数
                    limit_month: { type: 'int', default: 1, min: 0 },          // 限制每月提交次数
                    limit_total: { type: 'int', default: 1, min: 0 },          // 限制总共提交次数
                    bind_email: { type: 'boolean', required: false, default: false },
                    bind_mobile: { type: 'boolean', required: false, default: false },
                    bind_wechat: { type: 'boolean', required: false, default: false },
                    can_edit: { type: 'boolean', required: false, default: true },
                    need_verification: { type: 'boolean', required: false, default: false },
                    open_in_active_only: { type: 'boolean', required: false, default: false },
                } },
                fields: { type: 'array', itemType: 'object', required: true, rule: {
                    name: { type: 'string', required: true, trim: true, max: 20 },      // 字段表单名称(不可重复,因为字符串或数字的组合,不能是特殊字符)
                    type: { type: 'enum', required: true, values: ['number', 'string', 'boolean', 'mobile', 'email', 'url', 'idCard', 'date', 'dateTime', 'upload', 'image', 'radios', 'selectS', 'checkboxes', 'selectM', 'editor'] },
                    label: { type: 'string', required: true, trim: true, max: 200 },     // 字段标签
                    required: { type: 'boolean', default: false },                      // 是否必填
                    // verification: { type: 'boolean', default: false },      // 手机号时是否需要短信验证
                    // max: { type: 'int', required: false },                                   // 最小、最短、最少上传文件个数
                    // min: { type: 'int', required: false },                                   // 最大、最长、最多上传文件个数
                    precision: { type: 'int', required: false, min: 0, default: 0 },                             // 小数位数
                    options: { type: 'array', itemType: 'object', required: false, rule: {  // 字段为select,radio,checkbox,switch时必填
                        label: { type: 'string', required: true, trim: true, max: 200 },
                        value: { type: 'int', required: true },
                    }}
                } },
                temp: { type: 'string', required: false, trim: true, allowEmpty: true },
                generateAmis: { type: 'boolean', required: false, default: false }
            }, data);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        // 检查fileds是否有重名字段
        // 使用 _.uniqBy 获取唯一的 name 字段
        const uniqueFields = _.uniqBy(data.fields, 'name');
        // 找出重复的项
        const duplicates = _.difference(data.fields, uniqueFields);
        if (duplicates.length > 0) {
            return this.fail(`存在重复的 ${duplicates[0].name} 字段`);
        }
        if (data.generateAmis) {
            data.amis = ctx.service.sys.generate.amis(data);
        }
        await ctx.model.Form.update(data, { where: { id: data.id } });
        // 生成后台表单展示项到缓存
        const columns = ctx.service.sys.generate.amisColumns(data);
        await this.app.cache.set(`form:${data.id}:columns`, columns);
        return this.success();
    }

    /**
     * @summary 删除表单
     * @description 删除表单
     * @router post /admin/form/del
     * @request body form_item form
     * @response 200 baseRes
     */
    async del() {
        const { ctx } = this, data = ctx.request.body;
        try {
            ctx.validate({
                id: { type: 'int', required: true, min: 1 },
            }, data);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        // 删除记录
        await ctx.model.Form.destroy({ where: { id: data.id } });
        await ctx.model.FormData.destroy({ where: { form_id: data.id } });
        return this.success();
    }

    /**
     * @summary 表单数据列表
     * @description 表单数据列表
     * @router get /admin/form/dataList/:form_id
     * @request query int page 当前页
     * @request query int perPage 每页数量
     * @response 200 baseRes
     */
    async dataList() {
        const { ctx } = this;
        try {
            ctx.validate({
                form_id: { type: 'int', required: true, min: 1 }
            }, ctx.params);
            ctx.validate({
                page: { type: 'int', required: false, min: 1, default: 1 },
                perPage: { type: 'int', required: false, min: 1, default: 20 },
                keyword: 'string?',
                member_uuid: 'string?',
                member_name: 'string?',
                ip: 'string?',
                isExport: { type: 'boolean', required: false, default: false }
            }, ctx.query);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { page, perPage, orderBy, orderDir, keyword, id, member_uuid, member_name, status, ip, isExport } = ctx.query;
        const { form_id } = ctx.params;
        if (isExport) {
            // 导出全量数据
            const list = await ctx.model.FormData.findAndCountAll({ where: { form_id } });
            return this.success({ items: list.rows, total: list.count });
        } else {
            const map = {
                where: { form_id },
                order: [['id', 'DESC']],
                offset: (page - 1) * perPage,
                limit: perPage
            }
            if (orderBy && orderDir) {
                map.order = [[orderBy, orderDir]]
            }
            if (keyword) {
                map.where.data = { [Op.substring]: keyword };
            }
            if (id != undefined && id != '') {
                map.where.id = id;
            }
            if (member_uuid) {
                map.where.member_uuid = member_uuid;
            }
            if (member_name) {
                map.where.member_name = { [Op.substring]: member_name };
            }
            if (status != undefined && status != '') {
                map.where.status = status;
            }
            if (ip) {
                map.where.ip = ip;
            }
            const list = await ctx.model.FormData.findAndCountAll(map);
            let columns = await this.app.cache.get(`form:${form_id}:columns`);
            if (!columns) {
                const formInfo = await ctx.model.Form.findByPk(form_id);
                if (!formInfo) {
                    return this.fail('活动不存在');
                }
                const columns = ctx.service.sys.generate.amisColumns(formInfo);
                await this.app.cache.set(`form:${form_id}:columns`, columns);
            }
            return this.success({ items: list.rows, total: list.count, columns });
        }
    }

    /**
     * @summary 表单数据编辑
     * @description 表单数据编辑(目前主要修改审核状态)
     * @router post /admin/form/dataEdit
     * @request body form_data_edit form
     * @response 200 baseRes
     */
    async dataEdit() {
        const { ctx } = this;
        try {
            ctx.validate({
                form_id: { type: 'int', required: true, min: 1 },
                ids: 'string',
                status: { type: 'enum', required: true, values: [0, 1, 2, 3] },
            }, ctx.request.body);
        } catch (error) {
            return this.fail(JSON.stringify(error.errors[0]));
        }
        const { form_id, ids, status } = ctx.request.body;
        const idsArr = ids.split(',');
        if (status == 2) {
            // 审核通过 检查是否有附件需要发布
            const formInfo = await ctx.model.Form.findByPk(form_id);
            if (!formInfo) {
                return this.fail('活动不存在');
            }
            const attachmentFields = formInfo.fields.filter(item => item.type == 'upload' || item.type == 'image' || item.type == 'url');
            if (attachmentFields.length > 0) {
                const dataList = await ctx.model.FormData.findAll({ where: { id: { [Op.in]: idsArr }, status: { [Op.ne]: 2 } } });
                for (const data of dataList) {
                    data.status = status;
                    for (const field of attachmentFields) {
                        const value = data.data[field.name];
                        if (value != undefined) {
                            switch (field.type) {
                                case 'upload':
                                case 'image':
                                    for (let i = 0; i < value.length; i++) {
                                        const url = value[i];
                                        const attachment = await ctx.service.cms.attachment.publishWithUrl(url);
                                        if (attachment) {
                                            value[i] = attachment.url;
                                        }
                                    }
                                    break;
                                case 'url':
                                    const attachment = await ctx.service.cms.attachment.publishWithUrl(value);
                                    if (attachment) {
                                        data.data[field.name] = attachment.url;
                                    }
                                    break;
                            }
                        }
                    }
                    await data.save({ fields: ['status', 'data'] });
                }
            } else {
                await ctx.model.FormData.update({ status }, { where: { id: { [Op.in]: idsArr } } });
            }
        } else {
            await ctx.model.FormData.update({ status }, { where: { id: { [Op.in]: idsArr } } });
        }
        return this.success();
    }
}
module.exports = FormAdminController;