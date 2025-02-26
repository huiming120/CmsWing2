'use strict';
const Service = require('egg').Service;
const qiniu = require('qiniu');
const ObsClient = require('esdk-obs-nodejs');
const OSS = require('ali-oss');
const COS = require('cos-nodejs-sdk-v5');
const path = require('path');
const fs = require('fs/promises');
const fsSync = require('fs');
const images = require('images');
class objectStorageService extends Service {
	constructor(app) {
		super(app);
		this.con = this.config.objectStorage;
		this.type = this.config.objectStorage.type;
	}
	// 上传接口
	async upload(body, file, status = true) {
		const res = {};
		const type = body.type ? body.type : this.type;
		const config = this.con[type], helper = this.ctx.helper;
		const localFile = file.filepath;
		let keyname = path.basename(localFile), dayDir = helper.moment().format('YYYYMMDD'), key = path.join(config.path, dayDir, keyname);
		const filestat = await fs.stat(localFile);
		res.name = file.filename;
		res.mime = file.mimeType;
		// res.size = Math.round(filestat.size / 1024);
        res.size = filestat.size;
		res.location = type;
        if (!status) {
            // 不对外的话全部放在本地临时目录
            const privateUploadDir = this.config.privateUploadDir
            const targetDir = path.join(privateUploadDir, config.path, dayDir), compressedDir = path.join(targetDir, 'compressed');
			if (!fsSync.existsSync(targetDir)) {
                helper.mkdirsSync(targetDir);
			}
            if (!fsSync.existsSync(compressedDir)) {
                helper.mkdirsSync(compressedDir);
			}
			await fs.copyFile(localFile, path.join(privateUploadDir, key));
			res.savename = `${config.path}/${dayDir}/${keyname}`;
			res.url = `${config.domain}/cms/attachment/getFile/`;
            if (res.mime == 'image/png' || res.mime == 'image/jpeg') {
                this.compressImage(localFile, path.join(compressedDir, keyname));
            }
            res.compressed_url = res.url;
			res.result = {};
            return res;
        }
		if (type === 'local') { // 本地上传
            const staticCfg = this.config.static
            const targetDir = path.join(staticCfg.dir, config.path, dayDir), compressedDir = path.join(targetDir, 'compressed');
			if (!fsSync.existsSync(targetDir)) {
                helper.mkdirsSync(targetDir);
			}
            if (!fsSync.existsSync(compressedDir)) {
                helper.mkdirsSync(compressedDir);
			}
			// await fs.rename(localFile, path.join(this.app.baseDir, 'app', 'public', config.path, key));
			await fs.copyFile(localFile, path.join(staticCfg.dir, key));
			res.savename = `${config.path}/${dayDir}/${keyname}`;
			res.url = `${config.domain}${staticCfg.prefix}${res.savename}`;
            if (res.mime == 'image/png' || res.mime == 'image/jpeg') {
                this.compressImage(localFile, path.join(compressedDir, keyname));
                res.compressed_url = `${config.domain}${staticCfg.prefix}${config.path}/${dayDir}/compressed/${keyname}`;
            } else {
                res.compressed_url = res.url;
            }
			res.result = {};
		} else if (type === 'kodo') { // 七牛上传
			const mac = new qiniu.auth.digest.Mac(config.AccessKey, config.SecretKey);
			const options = {
				scope: config.Bucket,
			};
			const putPolicy = new qiniu.rs.PutPolicy(options);
			const uploadToken = putPolicy.uploadToken(mac);
			const upconfig = new qiniu.conf.Config();
			const formUploader = new qiniu.form_up.FormUploader(upconfig);
			const putExtra = new qiniu.form_up.PutExtra();
			// 文件上传
			const uploadFile = async () => new Promise((resolve, reject) => {
				formUploader.putFile(uploadToken, key, localFile, putExtra, function (respErr,
					respBody, respInfo) {
					if (respErr) {
						reject(respErr);
						throw respErr;
					}
					if (respInfo.statusCode === 200) {
						resolve(respBody);
					} else {
						resolve(respInfo.statusCode);
					}
				});
			});
			try {
				const result = await uploadFile();
				res.savename = result.key;
				res.url = `${config.domain}/${result.key}`;
				res.result = result;
			} catch (error) {
				return false;
			}
		} else if (type === 'obs') { // 华为云

			const obsClient = new ObsClient({
				access_key_id: config.AccessKey,
				secret_access_key: config.SecretKey,
				server: `https://obs.${config.Region}.myhuaweicloud.com`,
			});
			const dconfig = {
				Bucket: config.Bucket,
				Key: key,
				SourceFile: localFile,
			};
			const uploadFile = () => new Promise((resolve, reject) => {
				obsClient.putObject(dconfig, (err, result) => {
					if (err) {
						reject(err);
					} else {
						result.key = key;
						resolve(result);
					}
				});
			});
			try {
				const result = await uploadFile();
				res.savename = result.key;
				res.url = `${config.domain}/${result.key}`;
				res.result = result;
			} catch (error) {
				return false;
			}
		} else if (type === 'oss') { // 阿里云oss
			const client = new OSS({
				// yourregion填写Bucket所在地域。以华东1（杭州）为例，Region填写为oss-cn-hangzhou。
				region: config.Region,
				// 阿里云账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM用户进行API访问或日常运维，请登录RAM控制台创建RAM用户。
				accessKeyId: config.AccessKey,
				accessKeySecret: config.SecretKey,
				// 填写Bucket名称。
				bucket: config.Bucket,
			});
			try {
				// 填写OSS文件完整路径和本地文件的完整路径。OSS文件完整路径中不能包含Bucket名称。
				// 如果本地文件的完整路径中未指定本地路径，则默认从示例程序所属项目对应本地路径中上传文件。
				const result = await client.put(key, path.normalize(localFile)
					// 自定义headers
					// ,{headers}
				);
				res.savename = result.name;
				res.url = `${config.domain}/${result.name}`;
				res.result = result;
			} catch (e) {

			}
		} else if (type === 'cos') { // 腾讯云上传
			// SECRETID 和 SECRETKEY请登录 https://console.cloud.tencent.com/cam/capi 进行查看和管理
			const cos = new COS({
				SecretId: config.AccessKey,
				SecretKey: config.SecretKey,
			});
			const uploadFile = () => new Promise((resolve, reject) => {
				cos.uploadFile({
					Bucket: config.Bucket, /* 填入您自己的存储桶，必须字段 */
					Region: config.Region, /* 存储桶所在地域，例如ap-beijing，必须字段 */
					Key: key, /* 存储在桶里的对象键（例如1.jpg，a/b/test.txt），必须字段 */
					FilePath: localFile, /* 必须 */
					SliceSize: 1024 * 1024 * 500, /* 触发分块上传的阈值，超过500MB使用分块上传，非必须 */
					onTaskReady(taskId) { /* 非必须 */
						// console.log(taskId);
					},
					onProgress(progressData) { /* 非必须 */
						// console.log(JSON.stringify(progressData));
					},
					onFileFinish(err, data, options) { /* 非必须 */
						// console.log(options.Key + '上传' + (err ? '失败' : '完成'));
					},
				}, function (err, data) {
					//   console.log(err || data);
					if (err) {
						// console.error('Error-->' + err);
						reject(err);
					} else {
						// console.log('Status-->' + data);
						data.key = key;
						resolve(data);
					}
				});
			});
			try {
				const result = await uploadFile();
				// console.log(result);
				res.savename = result.key;
				res.url = `${config.domain}/${result.key}`;
				res.result = result;
			} catch (error) {
				return false;
			}
		}
		return res;
	}
    // 删除附件
    async del(attachment) {
        if(!attachment.status) {
            // 未对外
            const filePath = path.join(this.config.privateUploadDir, attachment.path), compressedPath = path.join(path.dirname(filePath), 'compressed', path.basename(filePath));
            if (fsSync.existsSync(filePath)) {
                await fs.unlink(filePath);
            }
            if (fsSync.existsSync(compressedPath)) {
                await fs.unlink(compressedPath);
            }
            return;
        }
        switch (attachment.location) {
            case 'local':
                const filePath = path.join(this.config.static.dir, attachment.path), compressedPath = path.join(path.dirname(filePath), 'compressed', path.basename(filePath));
                if (fsSync.existsSync(filePath)) {
                    await fs.unlink(filePath)
                }
                if (fsSync.existsSync(compressedPath)) {
                    await fs.unlink(compressedPath);
                }
                break;
            case 'kodo':
                
                break;
            case 'obs':
                
                break;
            case 'oss':
                
                break;
            case 'cos':
                
                break;
        }
    }
    // 编辑附件裁剪图片
    async editUpload(attachment, file) {
        if(!attachment.status) {
            // 未对外
            const filePath = path.join(this.config.privateUploadDir, attachment.path);
            await fs.copyFile(file.filepath, filePath);
            if (attachment.mime == 'image/png' || attachment.mime == 'image/jpeg') {
                const compressedPath = path.join(path.dirname(filePath), 'compressed', path.basename(filePath));
                this.compressImage(file.filepath, compressedPath);
            }
            return;
        }
        switch (attachment.location) {
            case 'local':
                const filePath = path.join(this.config.static.dir, attachment.path);
                await fs.copyFile(file.filepath, filePath);
                if (attachment.mime == 'image/png' || attachment.mime == 'image/jpeg') {
                    const compressedPath = path.join(path.dirname(filePath), 'compressed', path.basename(filePath));
                    this.compressImage(file.filepath, compressedPath);
                }
                break;
            case 'kodo':
                
                break;
            case 'obs':
                
                break;
            case 'oss':
                
                break;
            case 'cos':
                
                break;
        }
    }
    // 切换附件状态(目前都只处理了本地存储,其他云存储需要再做处理)
    async toggleStatus(attachment) {
        const privateUploadDir = this.config.privateUploadDir;
        const { status, url, upload_user_uuid } = attachment;
        switch (attachment.location) {
            case 'local':
                const publicUploadDir = this.config.static.dir;
                if (attachment.status) {
                    var targePath = path.join(privateUploadDir, attachment.path), filePath = path.join(publicUploadDir, attachment.path);
                    attachment.status = false;
                    attachment.url = `${this.con.local.domain}/cms/attachment/getFile/${attachment.id}`;
                    attachment.compressed_url = attachment.url;
                } else {
                    var targePath = path.join(publicUploadDir, attachment.path), filePath = path.join(privateUploadDir, attachment.path);
                    attachment.status = true;
                    attachment.url = `${this.con.local.domain}${this.config.static.prefix}${attachment.path}`;
                    attachment.compressed_url = `${this.con.local.domain}${this.config.static.prefix}${path.dirname(attachment.path)}/compressed/${path.basename(attachment.path)}`;
                }
                const targetDir = path.dirname(targePath), targetCompressedDir = path.join(targetDir, 'compressed');
                const targeCompressedPath = path.join(targetCompressedDir, path.basename(attachment.path));
                const fileCompressedPath = path.join(path.dirname(filePath), 'compressed', path.basename(attachment.path));
                if (!fsSync.existsSync(targetDir)) {
                    this.ctx.helper.mkdirsSync(targetDir);
                }
                if (!fsSync.existsSync(targetCompressedDir)) {
                    this.ctx.helper.mkdirsSync(targetCompressedDir);
                }
                try { 
                    await fs.copyFile(filePath, targePath);
                    await fs.unlink(filePath);
                    if (fsSync.existsSync(fileCompressedPath)) {
                        await fs.copyFile(fileCompressedPath, targeCompressedPath);
                        await fs.unlink(fileCompressedPath);
                    }
                } catch (error) {}
                break;
            case 'kodo':
                
                break;
            case 'obs':
                
                break;
            case 'oss':
                
                break;
            case 'cos':
                
                break;
        }
        await attachment.save({ fields: ['status', 'url', 'compressed_url'] });
        if (!status && status != attachment.status && attachment.remark && attachment.remark.from) {
            switch (attachment.remark.from) {
                case 'avatar':
                    // 更新头像
                    const member = await this.ctx.model.McMember.findOne({ where: { uuid: upload_user_uuid } });
                    if (member && member.avatar && member.avatar.includes(url)) {
                        await member.update({ avatar: attachment.url });
                    }
                    break;
                case 'form':
                    // TODO 表单
                    break;
                case 'article':
                    // TODO 稿库
                    break;
            }
        }
    }
    // 压缩图片保存
    compressImage(filePath, savePath) {
        let img = images(filePath);
        let imgWidth = img.width();
        if (imgWidth > 200) {
            img.size(200);
        }
        img.save(savePath, { quality: 50 });
    }
}
module.exports = objectStorageService;
