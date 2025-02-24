/* eslint-disable jsdoc/check-tag-names */
'use strict';
const fs = require('fs/promises');
const path = require('path');
const Controller = require('../../core/base_controller');
class ObjectStorageController extends Controller {
	// 获取对象储存配置
	async objectStorageConfig() {
		this.success(this.config.objectStorage);
	}
	async edit() {
		const data = this.ctx.request.body;
		if (!data) return this.fail('参数不正确');
		const dataStr = `'use strict';
// eslint-disable-next-line eol-last, object-curly-spacing, quotes, quote-props, key-spacing, comma-spacing
module.exports = {objectStorage: ${JSON.stringify(data)}};`;
		// console.log(dataStr);
		const appDir = path.join(this.app.baseDir, 'config');
		const fileName = 'objectStorage.config.js';
		const file = path.join(appDir, fileName);
		try {
			const data = new Uint8Array(Buffer.from(dataStr));
			await fs.writeFile(file, data);
			// Abort the request before the promise settles.
		} catch (err) {
			// When a request is aborted - err is an AbortError
			console.error(err);
		}
		this.success(1);
	}
	/**
	 * 系统上传接口
	 * /upload 前后端分离接口
	 * type: 类型 qiniu|七牛 oss|阿里云OSS  cos|腾讯云COS obs|华为云OBS ,如果不传该参数 使用系统默认类型
	 * resBody: 返回格式, 可以根据实际需求定制返回格式，默认格式 '{"status": 0,"msg": "","data":{"name":"{{name}}","mime":"{{mime}}","size":{{size}},"type":"{{type}}","savename":"{{savename}}","value":"{{url}}","url":"{{url}}"}}'
	 * token: 如果不是前后端分离应使用 /upload/你设置的session key,如果是是前后端分离 那么必须传该字段。
	 * type，resBody 根据实际需求可以不传，token必须携带。 这三个参数可以通过body,或者header 携带
	 * @memberof ObjectStorageController
	 */
	async upload() {
		const { ctx } = this;
		const data = ctx.request.body;
		const file = ctx.request.files[0];
		const { sessionKey } = ctx.params;
		data.type = data.type || ctx.get('type');
        if (data.remark) {
            try {
                const remark = JSON.parse(data.remark);
                data.remark = remark;
            } catch (error) {}
        }
		try {
			// 处理文件，比如上传到云端
			// console.log(file);
			// 身份验证
			let token = '';
			if (sessionKey) {
				token = ctx.session[sessionKey];
			} else {
				token = data.token || ctx.get('token');
			}
            const status = sessionKey == 'adminToken';
            let userInfo;
            if (token) {
                userInfo = ctx.helper.deToken(token);
                if (!userInfo && (data.open != 1 || status)) throw new Error('无效toekn');
            } else {
                if (status || data.open != 1) {
                    throw new Error('请在接口携带toekn');
                }      
            }
			data.resBody = data.resBody || ctx.get('resBody');
			data.resBody = data.resBody ? data.resBody : '{"status": 0,"msg": "","data":{"name":"{{name}}","mime":"{{mime}}","size":{{size}},"type":"{{type}}","savename":"{{savename}}","value":"{{url}}","url":"{{url}}"}}';
			const upload = await ctx.service.sys.objectStorage.upload(data, file, status);
			if (upload) {
                let uuid
                if (userInfo) {
                    uuid = userInfo.uuid;
                } else {
                    if (await ctx.service.mc.wxauth.checkLogin(false)) {
                        uuid = ctx.wxUserInfo.openid;
                    } else {
                        uuid = '0000000000000000000000000000';
                    }
                }
                const attachment = await ctx.model.CmsAttachment.create({
                    name: upload.name,
                    description: data.description || '',
                    path: upload.savename,
                    url: upload.url,
                    size: upload.size,
                    mime: upload.mime,
                    location: upload.location,
                    upload_user_uuid: uuid,
                    upload_ip: ctx.ip,
                    status,
                    remark: status ? { from: 'admin' } : data.remark ? data.remark : { from: 'unkonwn' },
                })
                if (!status) {
                    upload.url = upload.url + attachment.id;
                    await attachment.update({ url: upload.url })
                }
                const resdata = {};
				resdata.name = upload.name;// 原始文件名
				resdata.mime = upload.mime;// 文件mime类型
				resdata.size = upload.size;// 文件大小kb
				resdata.type = upload.location;// 文件保存位置
				resdata.savename = upload.savename;// 保存名称
				resdata.url = upload.url;
				// console.log(resdata);
				const reshtml = await ctx.renderString(data.resBody, resdata);
				// console.log(reshtml);
				ctx.body = JSON.parse(reshtml);
			} else {
				throw new Error('上传失败');
			}
		} catch (e) {
			// console.log(e);
			this.fail(e.toString());
		} finally {
			// 需要删除临时文件
			await fs.unlink(file.filepath);
		}
	}

}
module.exports = ObjectStorageController;
