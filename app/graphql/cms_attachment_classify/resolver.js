'use strict';
module.exports = {
	CmsAttachmentClassify: {
		async cms_attachment(root, params, ctx) {
			const map = {};
			map.where = { attachment_classify_id: root.id };
			if (Object.hasOwnProperty.call(params, 'limit')) {
				map.limit = params.limit;
			}
			if (Object.hasOwnProperty.call(params, 'offset')) {
				map.offset = params.offset;
			}
			if (Object.hasOwnProperty.call(params, 'order')) {
				map.order = params.order;
			}
			return await ctx.connector.cms_attachment.findAll(map);
		},
	},

	Query: {
		async CmsAttachmentClassify_findAll(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.findAll(params);
		},
		async CmsAttachmentClassify_findByPk(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.findByPk(params);
		},
		async CmsAttachmentClassify_findOne(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.findOne(params);
		},
		async CmsAttachmentClassify_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.findAndCountAll(params);
		},
	},
	Mutation: {
		async CmsAttachmentClassify_create(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.create(params);
		},
		async CmsAttachmentClassify_destroy(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.destroy(params);
		},
		async CmsAttachmentClassify_update(_root, params, ctx) {
			return await ctx.connector.cms_attachment_classify.update(params);
		},
	},
};