'use strict';
module.exports = {
	CmsAttachment: {
		async cms_attachment_classify(root, params, ctx) {
			const map = {};
			map.where = { id: root.attachment_classify_id };
			return await ctx.connector.cms_attachment_classify.findOne(map);
		},
	},

	Query: {
		async CmsAttachment_findAll(_root, params, ctx) {
			return await ctx.connector.cms_attachment.findAll(params);
		},
		async CmsAttachment_findByPk(_root, params, ctx) {
			return await ctx.connector.cms_attachment.findByPk(params);
		},
		async CmsAttachment_findOne(_root, params, ctx) {
			return await ctx.connector.cms_attachment.findOne(params);
		},
		async CmsAttachment_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.cms_attachment.findAndCountAll(params);
		},
	},
	Mutation: {
		async CmsAttachment_create(_root, params, ctx) {
			return await ctx.connector.cms_attachment.create(params);
		},
		async CmsAttachment_destroy(_root, params, ctx) {
			return await ctx.connector.cms_attachment.destroy(params);
		},
		async CmsAttachment_update(_root, params, ctx) {
			return await ctx.connector.cms_attachment.update(params);
		},
	},
};