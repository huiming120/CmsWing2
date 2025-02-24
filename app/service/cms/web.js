'use strict';
const Service = require('egg').Service;
const cheerio = require('cheerio');

class webService extends Service {
    async cmsTemplatePath() {
        const temp = await this.app.cache.get('templateInfo');
        this.ctx.templateInfo = temp;
		return `${temp.path}-${temp.uuid}`;
	}
    getHtmlSnippet(html, keyword) {
        const $ = cheerio.load(html);
        html = $('body').text()
        const index = html.indexOf(keyword);
        if (index == -1) {
            return '';
        }
        const start = Math.max(0, index - 50);
        const end = Math.min(html.length, index + keyword.length + 50);
        html = html.slice(start, end);
        const regex = new RegExp(`(${keyword})`, 'gi');
        if (index < 50) {
            html = '...' + html;
        }
        if (index + keyword.length + 50 < html.length) {
            html += '...';
        }
        return html.replace(regex, `<span class="keyword">$1</span>`);
    }
}
module.exports = webService;