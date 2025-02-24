'use strict';
const Controller = require('../../core/base_controller');
const { Op } = require('sequelize');
const fs = require('fs/promises');
const path = require('path');
/**
* @controller 附件管理
*/
class AttachmentController extends Controller {
    /**
     * @summary 获取附件列表
     * @description 获取附件列表
     * @router get /admin/cms/attachment/list
     * @request query string? [keyword] 关键字
     * @request query datetime? [createdAtBegin] 附件创建时间开始区间
     * @request query datetime? [createdAtEnd] 附件创建时间结束区间
     * @request query integer [page=1] 当前页数
     * @request query integer [perPage=20] 每页数量
     * @response 200 baseRes successed
     */
    async list() {
        const { ctx } = this;
        ctx.validate({
            keyword: 'string?',
            createdAtBegin: { type: 'datetime', required: false, allowEmpty: true },
            createdAtEnd: { type: 'datetime', required: false, allowEmpty: true },
            sizeMin: 'number?',
            sizeMax: 'number?',
            mime: 'string?',
            location: 'string?',
            upload_user_uuid: 'string?',
            upload_ip: 'ip?',
            status: 'int?',
            page: { type: 'int', required: false, default: 1 },
            perPage: { type: 'int', required: false, default: 20 }
        }, ctx.query);
        const { keyword, createdAtBegin, createdAtEnd, sizeMin, sizeMax, mime, location, upload_user_uuid, upload_ip, status, page, perPage, orderBy, orderDir } = ctx.query;
        const map = {
            where: {},
            order: [['id', 'DESC']],
            offset: (page - 1) * perPage,
            limit: perPage
        }
        if (keyword) {
            map.where[Op.or] = {
                name: { [Op.substring]: keyword },
                description: { [Op.substring]: keyword },
                path: { [Op.substring]: keyword }
            }
        }
        if (createdAtBegin) {
            map.where.createdAt = { [Op.gte]: createdAtBegin }
        }
        if (createdAtEnd) {
            map.where.createdAt = { [Op.lte]: createdAtEnd }
        }
        if (mime) {
            const mineIdArr = mime.split(','), mineArr = []
            if (mineIdArr.length < 5) {
                for (const l of mineIdArr) {
                    switch (l) {
                        case '1':
                            // 图片
                            mineArr.push('image/gif', 'image/png', 'image/jpeg', 'image/x-icon', 'image/bmp', 'image/webp')
                            break;
                        case '2':
                            // 音视频
                            mineArr.push('video/mp4', 'video/mpeg', 'video/avi', 'audio/mp3', 'audio/mpeg', 'audio/x-wav', 'audio/x-m4a')
                            break;
                        case '3':
                            // office文档
                            mineArr.push('application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/pdf', 'application/kswps', 'application/kset', 'application/ksdps')
                            break;
                        case '4':
                            // 文本文档
                            mineArr.push('text/plain', 'application/x-javascript', 'text/javascript', 'text/css', 'text/html', 'text/xml')
                            break;
                        case '5':
                            // 压缩文档
                            mineArr.push('application/zip', 'application/x-gzip', 'application/rar', 'application/x-tar', 'application/x-zip-compressed')
                            break;
                    }
                }
            }
            map.where.mime = { [Op.in]: mineArr }
        }
        if (sizeMin) {
            map.where.size = { [Op.between]: [sizeMin * 1024 * 1024, sizeMax * 1024 * 1024] }
        }
        if (location) {
            const locationArr = location.split(',')
            map.where.location = { [Op.in]: locationArr }
        }
        if (upload_user_uuid) {
            map.where.upload_user_uuid = upload_user_uuid
        }
        if (upload_ip) {
            map.where.upload_ip = upload_ip
        }
        if (status == 0) {
            map.where.status = false
        } else if (status == 1) {
            map.where.status = true            
        }
        if (orderBy && orderDir) {
            map.order = [[orderBy, orderDir]]
        }
        const list = await ctx.model.CmsAttachment.findAndCountAll(map)
        return this.success({ items: list.rows, total: list.count });
    }
    
    /**
     * @summary 新增附件
     * @description 上传附件，可一次上传多个
     * @router post /admin/cms/attachment/add
     * @request formData files *file 文件列表
     * @request body string [description] 附件描述
     * @request body string type=local、kodo、obs、oss、cos 附件描述
     * @response 200 baseRes successed
     */
    async add() {
        const { ctx } = this;
        ctx.validate({
            description: { type: 'string', required: false, default: '' },
            type: { type: 'enum', required: false, values: ['local', 'kodo', 'obs', 'oss', 'cos'] }
        }, ctx.request.body);
        const { description, type } = ctx.request.body;
        const files = ctx.request.files
        if (!files || files.length == 0) {
            return this.fail('请上传文件', 21);
        }
        for (const file of files) {
            try {
                const upload = await ctx.service.sys.objectStorage.upload(ctx.request.body, file)
                if (upload) {
                    await ctx.model.CmsAttachment.create({
                        name: upload.name,
                        description: description,
                        path: upload.savename,
                        url: upload.url,
                        size: upload.size,
                        mime: upload.mime,
                        location: type,
                        upload_user_uuid: this.user.uuid,
                        upload_ip: ctx.ip,
                        remark: { from: 'admin' }
                    })
                }
            } catch (error) {
                
            } finally {
                // 需要删除临时文件
                fs.unlink(file.filepath);
            }
        }
        return this.success();
    }

    /**
     * @summary 编辑附件
     * @description 编辑附件的名字和描述，可批量，批量编辑时只编辑描述
     * @router post /admin/cms/attachment/edit
     * @request body string ids 附件id组
     * @request body string description 附件描述
     * @request body string [name] 附件名字
     * @response 200 baseRes successed
     */
    async edit() {
        const { ctx } = this
        ctx.validate({
            ids: 'string',
            description: 'string',
            name: 'string?'
        }, ctx.request.body)
        const { ids, description, name } = ctx.request.body
        const idsArr = ids.split(',')
        const data = { description }
        if (name) {
            data.name = name
        }
        await ctx.model.CmsAttachment.update(data, {
            where: { id: { [Op.in]: idsArr } }
        })
        return this.success()
    }

    /**
     * @summary 编辑附件裁剪图片
     * @description 裁剪现有图片附件后上传
     * @router post /admin/cms/attachment/editUpload/:id
     * @request formData file *file 文件列表
     * @response 200 baseRes successed
     */
    async editUpload() {
        const { ctx } = this
        const files = ctx.request.files
        if (!files || files.length == 0) {
            return this.fail('请上传文件', 21);
        }
        const id = ctx.params.id
        const attachment = await ctx.model.CmsAttachment.findOne({ where: { id } })
        if (!attachment) {
            return this.fail('附件不存在', 22);
        }
        await ctx.service.sys.objectStorage.editUpload(attachment, files[0])
        return this.success({ url: attachment.url, value: attachment.url })
    }

    /**
     * @summary 删除附件
     * @description 删除附件
     * @router post /admin/cms/attachment/del
     * @request body string ids 附件id组
     * @response 200 baseRes successed
     */
    async del() {
        const { ctx } = this;
        ctx.validate({
            ids: 'string'
        }, ctx.request.body);
        const { ids } = ctx.request.body;
        const idsArr = ids.split(',');
        const list = await ctx.model.CmsAttachment.findAll({
            attributes: ['id', 'path', 'location'],
            where: { id: { [Op.in]: idsArr } }
        })
        for (const file of list) {
            await ctx.service.sys.objectStorage.del(file)
        }
        await ctx.model.CmsAttachment.destroy({ where: { id: { [Op.in]: idsArr } } });
        return this.success()
    }

    /**
     * @summary 切换附件状态
     * @description 切换附件状态
     * @router post /admin/cms/attachment/toggleStatus/:id
     * @response 200 baseRes successed
     */
    async toggleStatus() {
        const { ctx } = this;
        ctx.validate({
            id: 'int'
        }, ctx.params);
        const { id } = ctx.params;
        const attachment = await ctx.model.CmsAttachment.findByPk(id);
        if (!attachment) {
            return this.fail('附件不存在', 22);
        }
        await ctx.service.sys.objectStorage.toggleStatus(attachment)
        this.success(attachment);
    }

    /**
     * @summary 获取附件文件
     * @description 获取附件文件
     * @router get /cms/attachment/getFile/:id
     * @response 200 baseRes successed
     */
    async getFile() {
        const { ctx } = this;
        const token = ctx.session.adminToken || ctx.session.mcToken;
        const userInfo = ctx.helper.deToken(token);
        const defaultImgUrl = '/public/assets/images/default_image.svg';
        if (!userInfo) {
            return ctx.redirect(defaultImgUrl);
        }
        const id = ctx.params.id;
        if (!id) {
            return ctx.redirect(defaultImgUrl);
        }
        const attachment = await ctx.model.CmsAttachment.findByPk(id);
        if (!attachment) {
            return ctx.redirect(defaultImgUrl);
        }
        if (attachment.status && !attachment.url.includes(ctx.path.substring(0, ctx.path.lastIndexOf('/')))) {
            return ctx.redirect(attachment.url);
        }
        if (userInfo.admin == undefined && userInfo.uuid != attachment.upload_user_uuid) {
            return ctx.redirect(defaultImgUrl);
        }
        try {
            await ctx.downloader(path.join(this.config.privateUploadDir, attachment.path), attachment.name);
        } catch (error) {
            ctx.redirect(defaultImgUrl);
        } 
    }
}
module.exports = AttachmentController;