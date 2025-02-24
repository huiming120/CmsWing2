'use strict';
const Service = require('egg').Service;

class AttachmentService extends Service {
    // 根据url发布附件(url必须是一条私有链接)
    async publishWithUrl(url) {
        const { ctx } = this;
        const privateUrl = ctx.helper.pathFor('获取附件文件')
        if (url.includes(privateUrl.substring(0, privateUrl.lastIndexOf('/')))) {
            const attachmentId = url.substring(url.lastIndexOf('/') + 1);
            const attachment = await ctx.model.CmsAttachment.findByPk(attachmentId);
            if (attachment && !attachment.status) {
                await ctx.service.sys.objectStorage.toggleStatus(attachment)
            }
            return attachment;
        } else {
            return null;
        }
    }
}
module.exports = AttachmentService;