const nodemailer = require('nodemailer');
const SMSClient = require('@alicloud/sms-sdk');
const _ = require('lodash');
module.exports = {
    dumpConfig() {
        console.log('不导出配置文件 application');
    },
    /**
     * 发送邮件
     * @param {*} to 接收者
     * @param {*} subject 标题
     * @param {*} text 文本内容
     * @param {*} html html内容(如果存在,则会忽略text)
     * @param {*} attachments 附件
     */
    async sendEmail(to, subject, text = '', html, attachments = []) {
        const { env, nodemailer: nodemailerCfg } = this.config;
        if (env != 'prod' || !nodemailerCfg.enable) {
            return console.log('发送邮件:', to, subject, html || text, attachments);
        }
        if (!this.nodemailer) {
            this.nodemailer = nodemailer.createTransport(_.pick(nodemailerCfg, ['service', 'auth']));
        }
        const data = { from: nodemailerCfg.auth.user, to, subject, attachments }
        if (html) {
            data.html = html;
        } else {
            data.text = text;
        }
        try {
            await this.nodemailer.sendMail(data);
        } catch (error) {
            this.nodemailer = null;
        }
    },
    /**
     * 发送短信
     * @param {*} phone 手机号
     * @param {*} templateCode 短信模板
     * @param {*} templateParam 短信模板参数
     */
    async sendSms(PhoneNumbers, SignName, TemplateCode, code) {
        const { env, sms } = this.config;
        if (env != 'prod' || !sms.enable) {
            return console.log('发送短信:', PhoneNumbers, TemplateCode, code);
        }
        if (!this.sms) {
            this.sms = new SMSClient(_.pick(sms, ['accessKeyId', 'secretAccessKey']))
        }
        try {
            await this.sms.sendSMS({ PhoneNumbers, SignName: SignName || sms.SignName, TemplateCode: TemplateCode || sms.TemplateCode, TemplateParam: JSON.stringify({ code }) });
            this.logger.info('发送短信成功:', PhoneNumbers, TemplateCode, code);
        } catch (error) {
            this.logger.info('发送短信失败:', PhoneNumbers, TemplateCode, code, error.code || '未知', error.message);
            this.sms = null
        }
    },
}