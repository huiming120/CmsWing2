'use strict';
const Controller = require('../../core/base_controller');
const { Op } = require('sequelize');
// cms web前台
class WebController extends Controller {
	constructor(ctx) {
		super(ctx);
		ctx.userInfo = ctx.helper.deToken(ctx.session.mcToken);
	}
	// 首页
	async index() {
		const { ctx } = this;
		ctx.meta_title = '首页';
		ctx.keywords = this.config.cms.keywords;
		ctx.description = this.config.cms.description;
        const templatePath = await ctx.service.cms.web.cmsTemplatePath();
		await ctx.render(`cms/${templatePath}/index_${ctx.templateInfo.index_use}.html`);
	}
	// 列表
	async list() {
		const { ctx } = this;
		const templatePath = await ctx.service.cms.web.cmsTemplatePath();
		let { id } = ctx.params;
		const query = ctx.query;
		const isnum = ctx.helper.isStringNumber(id) || id.endsWith('.html') && !isNaN(parseInt(id));
        id = isnum ? parseInt(id) : id;
		const idKey = isnum ? 'id' : 'name';
		const classify = await ctx.model.CmsClassify.findOne({ where: { [idKey]: id, status: true } });
		if (!classify) return await ctx.render(`cms/${templatePath}/inc_404`);
		ctx.meta_title = classify.meta_title || classify.title;
		ctx.keywords = classify.keywords;
		ctx.description = classify.description;
		classify.url = `/cms/list/${classify.name ? classify.name : classify.id}.html`;
		const breadcrumb = await ctx.service.cms.classify.breadcrumb(classify.id);
		const orderby = query.orderby || '1';
		const map = {};
		const page = query.page || 1;
		const limit = 10;
		map.offset = (Number(page) - 1) * limit;
		map.limit = Number(limit);
		if (orderby === '1') {
			map.order = [['level', 'DESC'], ['id', 'DESC']];
		} else if (orderby === '2') {
			map.order = [['updatedAt', 'DESC']];
		} else if (orderby === '3') {
			map.order = [['view', 'DESC']];
		} else if (orderby === '4') {
			map.order = [['view', 'ASC']];
		}
		map.where = {};
		const subobj = {};
		if (query.sub) {
			const str = query.sub.split('|');
			map.where.classify_sub = {};
			for (const v of str) {
				const strarr = v.split('-');
				subobj[strarr[0]] = strarr[1];
			}
			map.where.classify_sub = await ctx.service.cms.classify.subQuery(classify.id, subobj);
		}
		if (query.keywords) {
			map.where.title = { [Op.like]: `%${query.keywords}%` };
		}
		map.where.status = true;
		const ids = await ctx.service.cms.classify.getSubClassifyIds(classify.id, [], false);
		map.where.classify_id = { [Op.in]: ids };
		const list = await ctx.model.CmsDoc.findAndCountAll(map);
		const pagination = ctx.service.sys.pagination.pagination(list, { limit });
        const classifyList = await this.app.cache.get('classifyList');
		for (const v of list.rows) {
			// v.pathTitle = (await ctx.service.cms.classify.info(v.classify_id)).pathTitle;
            v.pathTitle = classifyList[v.classify_id].title
		}
		let temp;
		// 查询栏目有没有绑定模板
		if (classify.template_lists) {
			temp = `cms/${templatePath}/${classify.template_lists}`;
		} else {
			temp = `cms/${templatePath}/list_default.html`;
		}
		const url = await ctx.service.cms.classify.getUrl(classify.url);
		const orderList = [
			{ name: '默认排序', url: url.replace('__ORDER__', 1), id: '1' },
			{ name: '按更新时间', url: url.replace('__ORDER__', 2), id: '2' },
			{ name: '浏览量:从高到低', url: url.replace('__ORDER__', 3), id: '3' },
			{ name: '浏览量:从低到高', url: url.replace('__ORDER__', 4), id: '4' },
		];
		const def = orderList.find(item => item.id === orderby);
		await ctx.render(temp, { list, pagination, classify, orderby: { list: orderList, def }, breadcrumb });
	}
	// 详情
	async detail() {
		const { ctx } = this;
		const templatePath = await ctx.service.cms.web.cmsTemplatePath();
		const id = parseInt(ctx.params.id);
		if (isNaN(id)) return this.notFound();
		const map = {};
		map.include = [{
			model: ctx.model.CmsClassify,
            where: { status: true },
		}];
		map.where = { id, status: 1 };
		const detail = await ctx.model.CmsDoc.findOne(map);
		if (!detail) return await ctx.render(`cms/${templatePath}/inc_404`);
		const info = detail.toJSON();
		// SEO
		ctx.meta_title = info.title;
		ctx.keywords = info.title;
		ctx.description = info.description;
		// 跳转外部连连
		if (info.ext_link) {
			return ctx.redirect(info.ext_link);
		}
		// 面包屑
		const breadcrumb = await ctx.service.cms.classify.breadcrumb(info.classify_id);
		const pdoc = await ctx.service.cms.doc.pdoc(info.pid);
		const pdocids = pdoc.map(item => item.id);
		const models = await ctx.model.SysModels.findOne({ where: { uuid: info.models_uuid } });
		const className = ctx.helper._.upperFirst(ctx.helper._.camelCase(models.name));
		info[models.name] = (await ctx.model[className].findOne({ where: { doc_id: info.id } })).toJSON();
        if (models.name == 'cms_doc_article' && info[models.name].content_type == 'amis') {
			info[models.name].content = encodeURIComponent(info[models.name].content);
		}
		let temp;
		// 查询栏目有没有绑定模板
		if (info.template) {
			temp = `cms/${templatePath}/${info.template}`;
		} else if (info.cms_classify.template_detail) {
			temp = `cms/${templatePath}/${info.cms_classify.template_detail}`;
		} else {
			temp = `cms/${templatePath}/detail_default.html`;
		}
		info.classify_url = `/cms/list/${info.cms_classify.name ? info.cms_classify.name : info.cms_classify.id}.html`;
		// 增加浏览次数
		await ctx.model.CmsDoc.increment({ view: 1 }, { where: { id } });
		await ctx.render(temp, { detail: info, breadcrumb, pdoc, pdocids });
	}
    // 搜索
    async search() {
        if (!this.config.cms.openSearch) {
            return this.notFound();
        }
        const { ctx } = this;
        ctx.meta_title = '搜索';
		ctx.keywords = this.config.cms.keywords;
		ctx.description = this.config.cms.description;
		const templatePath = await ctx.service.cms.web.cmsTemplatePath();
        try {
            ctx.validate({
                type: { type: 'int', required: false, default: 1, max: 3 },
                keyword: { type: 'string', required: true },
                page: { type: 'int', required: false, default: 1 }
            }, ctx.query);
        } catch (error) {
            return await ctx.render(`cms/${templatePath}/search_default`, { list: { count: 0, rows: [] } });
        }
        let { keyword, type, page } = ctx.query
        keyword = ctx.helper.escapeHtml(keyword)
        const where = { status: 1 }
        const map = { order: [['id', 'DESC']], where, raw: true };
        const limit = 20;
		map.offset = (Number(page) - 1) * limit;
		map.limit = Number(limit);
        if (type == 1) {
            // 文章
            map.include = [{
                model: ctx.model.CmsDocArticle
            }];
            where.models_uuid = 'e86401ba-85cb-47f7-9f53-853e26b939bd';
            where[Op.or] = [
                { title: { [Op.like]: `%${keyword}%` } },
                { description: { [Op.like]: `%${keyword}%` } },
                { '$cms_doc_article.content$': { [Op.like]: `%${keyword}%`} }
            ];
        } else if (type == 2) {
            // 图片
            map.include = [{
                model: ctx.model.CmsDocPicture
            }];
            where.models_uuid = '4e0da60c-13af-4965-8f35-e2b13742398e';
            where[Op.or] = [
                { title: { [Op.like]: `%${keyword}%` } },
                { description: { [Op.like]: `%${keyword}%` } },
                { '$cms_doc_picture.content$': { [Op.like]: `%${keyword}%`} }
            ];
        } else if (type == 3) {
            // 下载
            map.include = [{
                model: ctx.model.CmsDocDownload
            }];
            where.models_uuid = 'aac4b5a3-89f2-4c41-9213-39f43dcc0860';
            where[Op.or] = [
                { title: { [Op.like]: `%${keyword}%` } },
                { description: { [Op.like]: `%${keyword}%` } },
                { '$cms_doc_download.content$': { [Op.like]: `%${keyword}%`} },
                { '$cms_doc_download.desc$': { [Op.like]: `%${keyword}%`} }
            ];
        }
        const list = await ctx.model.CmsDoc.findAndCountAll(map);
        const regex = new RegExp(keyword, 'g')
        for (const doc of list.rows) {
            const { title, description } = doc;
            doc.title = title.replace(regex, '<span class="keyword">' + keyword + '</span>');
            if (description && description.indexOf(keyword) != -1) {
                doc.snippet = description.replace(regex, '<span class="keyword">' + keyword + '</span>');
            } else {
                let content = ''
                if (type == 1 && doc['cms_doc_article.content_type'] == 'html') {
                    content = doc['cms_doc_article.content']
                } else if (type == 3) {
                    content = doc['cms_doc_download.desc'] || ''
                }
                doc.snippet = ctx.service.cms.web.getHtmlSnippet(content, keyword);
            }
        }
        const pagination = ctx.service.sys.pagination.pagination(list, { limit });
        await ctx.render(`cms/${templatePath}/search_default`, { list, pagination });
	}
}
module.exports = WebController;
