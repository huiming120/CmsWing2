'use strict';
module.exports = {
	SpecialData: {
		async cms_doc2(root, params, ctx) {
			const map = {};
			map.where = { id: root.doc_id };
			return await ctx.connector.cms_doc.findOne(map);
		},
		async special(root, params, ctx) {
			const map = {};
			map.where = { id: root.special_id };
			return await ctx.connector.special.findOne(map);
		},
		async cms_doc(root, params, ctx) {
			const map = {};
			map.where = { id: root.doc_id };
			return await ctx.connector.cms_doc.findOne(map);
		},
	},

	Query: {
		async SpecialData_findAll(_root, params, ctx) {
			return await ctx.connector.special_data.findAll(params);
		},
		async SpecialData_findByPk(_root, params, ctx) {
			return await ctx.connector.special_data.findByPk(params);
		},
		async SpecialData_findOne(_root, params, ctx) {
			return await ctx.connector.special_data.findOne(params);
		},
		async SpecialData_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.special_data.findAndCountAll(params);
		},
	},
	Mutation: {
		async SpecialData_create(_root, params, ctx) {
			return await ctx.connector.special_data.create(params);
		},
		async SpecialData_destroy(_root, params, ctx) {
			return await ctx.connector.special_data.destroy(params);
		},
		async SpecialData_update(_root, params, ctx) {
			return await ctx.connector.special_data.update(params);
		},
	},
};